import click
import json
import os
import requests
import shutil
import subprocess
import sys
import tempfile
from enum import Enum, auto
from pathlib import Path
from typing import List

REPO_ROOT = Path(__file__).parent.parent
NIX_BIN = Path.home() / '.nix-profile/bin'
LAZY_SHELLS_CONFIG = REPO_ROOT / 'cli/lazy_shells.json'


class SupportedHosts(Enum):
    MACOS = auto()
    LINUX = auto()

    @classmethod
    def get(cls):
        if sys.platform.startswith('darwin'):
            return SupportedHosts.MACOS
        elif sys.platform.startswith('linux'):
            return SupportedHosts.LINUX
        else:
            raise ValueError(f'Unsupported platform: {sys.platform}')


class Cli:
    platform = SupportedHosts.get()
    dotfiles_dir = REPO_ROOT / 'dotfiles'
    is_root = os.geteuid() == 0


def _shell_run(command: List[str], sudo: bool = False, shell: bool = False) -> subprocess.CompletedProcess[str]:
    command_to_run = ['sudo'] + command if sudo else command
    return subprocess.run(command_to_run, shell=shell)


def _symlink(from_path: Path, to_path: Path) -> None:
    """Creates a symlink from-->to"""
    if not to_path.exists():
        raise ValueError(f'Cannot create symlink {from_path}->{to_path}, {to_path} does not exist')
    from_path.unlink(missing_ok=True)
    from_path.parent.mkdir(parents=True, exist_ok=True)
    from_path.symlink_to(to_path)


@click.group(context_settings={'help_option_names': ['-h', '--help']})
@click.pass_obj
def cli(app: Cli) -> None:
    """A command line tool for managing and interacting with my dev environment"""


@cli.group(chain=True, invoke_without_command=True)
@click.pass_context
def dotfiles(ctx: click.Context) -> None:
    """Commands for installing and updating dotfiles"""
    if not ctx.invoked_subcommand:
        ctx.invoke(setup_all_dotfiles)


@dotfiles.command('all')
@click.pass_context
def setup_all_dotfiles(ctx: click.Context) -> None:
    """Command alias to run all dotfile installation steps in the proper order"""
    ctx.invoke(nix)
    ctx.invoke(symlinks)
    ctx.invoke(zsh)
    ctx.invoke(fish)
    ctx.invoke(lazy_shells)


@dotfiles.command()
@click.option('--update/--no-update', default=False, help='Update the nix channel to the latest version')
@click.pass_obj
def nix(cli: Cli, update: bool) -> None:
    """Update the nix channel and install system-wide Nix packages"""
    if update:
        _shell_run([str(NIX_BIN / 'nix-channel'), '--update'])

    nix_config = Path.home() / '.nixpkgs/dev-env.nix'
    _symlink(nix_config, cli.dotfiles_dir / 'nix/dev-env.nix')
    _shell_run([str(NIX_BIN / 'nix-env'), '-i', '-f', nix_config])


@dotfiles.command()
@click.pass_obj
def symlinks(cli: Cli) -> None:
    """Symlink dotfiles into the $HOME directory"""
    click.echo('Updating symlinks')

    # Symlink all the basic dotfiles
    files_to_link = cli.dotfiles_dir.glob('.*')
    for df in files_to_link:
        target = Path.home() / df.name
        _symlink(target, df)

    # Neovim config
    _symlink(Path.home() / '.config/nvim/init.vim', cli.dotfiles_dir / 'config/nvim/init.vim')

    # Fish config
    _symlink(Path.home() / '.config/fish/config.fish', cli.dotfiles_dir / 'config/fish/config.fish')


@dotfiles.command()
@click.pass_obj
def zsh(cli: Cli) -> None:
    """Install ZSH customizations (like oh-my-zsh)"""
    omz_install_path = Path.home() / '.oh-my-zsh'
    omz_install_url = 'https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh'
    if not omz_install_path.exists():
        with tempfile.NamedTemporaryFile(mode='x') as f:
            response = requests.get(omz_install_url)
            f.write(response.content.decode('utf-8'))
            f.flush()
            _shell_run(['bash', f.name, '--unattended', '--keep-zshrc'])


@dotfiles.command()
@click.pass_obj
def fish(cli: Cli) -> None:
    """Install Fish shell customizations (like oh-my-fish, fisher)"""
    # Install Oh-My-Fish
    omf_install_path = Path.home() / '.local/share/omf'
    omf_install_script_url = 'https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install'

    if not omf_install_path.exists():
        with tempfile.NamedTemporaryFile(mode='x') as omf_install:
            response = requests.get(omf_install_script_url)
            omf_install.write(response.content.decode('utf-8'))
            omf_install.flush()
            _shell_run(['fish', omf_install.name, '--path', omf_install_path, '--noninteractive'])

    # Install Fisher Plugin Manager
    fisher_install_path = Path.home() / '.fisher'
    fisher_install_url = 'https://git.io/fisher'
    if not fisher_install_path.exists():
        response = requests.get(fisher_install_url)
        fisher_install_path.write_text(response.content.decode('utf-8'))

    # Install Fisher plugins
    fisher_plugins_to_install = [
        'jorgebucaran/fisher',
        'PatrickF1/fzf.fish',
        'lilyball/nix-env.fish',
    ]

    for plugin in fisher_plugins_to_install:
        _shell_run(['fish', '-c', f'source {fisher_install_path} && fisher install {plugin}'])

    # Configure fzf
    _shell_run(['fish', Path.home() / '.config/fish/functions/fzf_configure_bindings.fish'])

    # Install Themes
    _shell_run(['fish', '-c', 'omf install coffeeandcode 2> /dev/null'])


_lazy_shell_template = """
#! /usr/bin/env bash
exec {nix_bin}/nix-shell {packages_to_install} --run "{command} $*"
""".strip()


@dotfiles.command()
def lazy_shells() -> None:
    """Setup path definitions for programs that installed lazily via nix-shell"""
    configuration = json.loads(LAZY_SHELLS_CONFIG.read_text())
    lazy_shells_dir = Path.home() / '.lazy_shells'
    shutil.rmtree(lazy_shells_dir, ignore_errors=True)
    lazy_shells_dir.mkdir()

    print(f'Generating shell files for commands: {", ".join(configuration.keys())}')
    for command, packages in configuration.items():
        packages_to_install = ' '.join(f'-p pkgs.{p}' for p in packages)
        script = _lazy_shell_template.format(nix_bin=NIX_BIN, packages_to_install=packages_to_install, command=command)

        lazy_shell_file = lazy_shells_dir / command
        lazy_shell_file.touch(mode=0o744)
        lazy_shell_file.write_text(script)


if __name__ == '__main__':
    cli(obj=Cli())
