use clap::{Parser, Subcommand};
use dirs::home_dir;
use glob::glob;
use log::{LevelFilter, debug, info};
use serde_json;
use std::collections::HashMap;
use std::fs::{File, create_dir_all, remove_dir_all, remove_file, read_to_string, set_permissions};
use std::io::Write;
use std::os::unix::fs::PermissionsExt;
use std::os::unix;
use std::process::{Command, Output};
use std::str::FromStr;
use std::{env, io, path};
use reqwest;


// Constants
const EXEC: u32 = 0o744;
const OMF_INSTALL_URL: &str = "https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install";
const OMZ_INSTALL_URL: &str = "https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh";
const FISHER_INSTALL_URL: &str = "https://git.io/fisher";

// Logger implementation
struct SimpleLogger;
impl log::Log for SimpleLogger {
    fn enabled(&self, metadata: &log::Metadata) -> bool { metadata.level() <= log::Level::Trace }
    fn log(&self, record: &log::Record) {
        if self.enabled(record.metadata()) {
            println!("{} - {}", record.level(), record.args());
        }
    }
    fn flush(&self) {}
}
static LOGGER: SimpleLogger = SimpleLogger;

// Application state
fn get_repo_root() -> path::PathBuf {
    let exe_path = env::current_exe().expect("Could not find exe");
    let mut dir = exe_path.parent().expect("Could not find directory of exe");
    loop {
        // We're going to traverse upwards until we find the repo root
        if dir.join(".git").is_dir() {
            return dir.to_path_buf()
        } else {
            match dir.parent() {
                Some(parent_dir) => { dir = parent_dir; },
                None => { panic!("Could not find repo root!")},
            };
        }
    }
}

struct AppState {
    repo_root: path::PathBuf,
    dotfile_dir: path::PathBuf,
    home_dir: path::PathBuf,
}

impl AppState {
    fn new() -> AppState {
        let repo_root = get_repo_root();
        let dotfile_dir = repo_root.clone().join("dotfiles");
        let home_dir = home_dir().expect("Could not find home directory!");
        AppState { repo_root, dotfile_dir, home_dir }
    }
}

#[derive(Parser)]
#[clap(version, about = "CLI tool for managing local dotfiles.")]
struct Cli {
    #[clap(short, long, help="Set the log level", default_value="info")]
    log_level: String,
    #[clap(subcommand)]
    command: Option<SubCommand>,
}

#[derive(Subcommand, Debug)]
enum SubCommand {
    #[clap(about="Install system-wide nix dependencies")]
    Nix {
        #[clap(short, long, help="Whether or not to update the nix channel")]
        update: bool,
    },
    #[clap(about="Setup lazily-evaluated nix-shell scripts")]
    LazyShells,
    #[clap(about="Bootstrap the Fish shell")]
    Fish,
    #[clap(about="Bootstrap the ZSH shell")]
    Zsh,
    #[clap(about="Symlink all dotfiles")]
    Symlinks,
}

fn symlink(original: &path::Path, link: &path::Path) {
    if link.is_file() {
        debug!("Removing existing file @ {:?}", link);
        remove_file(link).expect("Could not remove existing symlink file");
    }
    create_dir_all(link.parent().expect("No parent to link")).expect("Could not create parent dirs");
    debug!("Symlinking {:?} -> {:?}", link, original);
    unix::fs::symlink(original, link).expect("Could not symlink files!")
}

fn execute_command(cmd: &str, args: Vec<&str>) -> Output {
    debug!("Running {:?} ({:?})", cmd, args);
    let proc = Command::new(cmd)
            .args(args)
            .spawn()
            .expect(&format!("Failed to execute command: {:?}", cmd).to_string());
    proc.wait_with_output().expect("Failed to wait for command to finish")
}

fn set_file_mode<P: AsRef<path::Path>>(f: &mut File, filename: P, mode: u32) {
    let mut file_permissions = f.metadata().expect("Error retrieving file metadata!").permissions();
    file_permissions.set_mode(mode);
    debug!("Changing permissions of {:?} to {:?}", f, mode);
    set_permissions(filename, file_permissions).expect("Could not set permissions for file!");
}

fn with_file_created<T, P>(filename: P, mode: u32, delete: bool, handler: T)
    where T: Fn(&mut File, P), P: AsRef<path::Path> + Copy {
    let mut file = File::create(filename).expect("Could not create file!");
    set_file_mode(&mut file, filename, mode);
    handler(&mut file, filename);

    if delete {
        debug!("Removing file {:?} since it is no longer needed", file);
        remove_file(filename).expect("Could not remove file");
    }
}

fn download_to_file(url: &str, file: &mut File) {
    let mut resp = reqwest::blocking::get(url).expect("Could not send HTTP request");
    io::copy(&mut resp, file).expect("failed to copy content");
}

fn setup_nix(app_state: &AppState, update: bool) {
    if update {
        info!("Updating Nix channels");
        execute_command("nix-channel", vec!("--update"));
    }

    info!("Installing development environment via Nix");
    let nix_config = app_state.home_dir.join(".nixpkgs/dev-env.nix");
    symlink(&app_state.dotfile_dir.join("nix/dev-env.nix"), &nix_config);
    execute_command("nix-env", vec!("-i", "-f", &nix_config.as_path().display().to_string()));
}

fn setup_lazy_shells(app_state: &AppState) {
    info!("Creating lazy shells");

    // Parse lazy shell config
    let lazy_shells_config = app_state.repo_root.join("cli/lazy_shells.json");
    let lazy_shells: HashMap<String, Vec<String>> = serde_json::from_str(
        &read_to_string(lazy_shells_config).expect("Could not read lazy shells!")
    ).expect("Could not deserialize lazy shells JSON");

    // Clear out existing lazy shells
    let lazy_shell_dir = app_state.home_dir.join(".lazy_shells/");
    if lazy_shell_dir.is_dir() {
        debug!("Deleting existing lazy shells dir: {:?}", lazy_shell_dir);
        remove_dir_all(&lazy_shell_dir).expect("Could not delete lazy shells directory");
    }
    create_dir_all(&lazy_shell_dir).expect("Could not create lazy shell directory");

    // Populate shell scripts
    for (shell_name, dependencies) in &lazy_shells {
        let packages_to_install = dependencies
            .into_iter()
            .map(|s| format!("-p pkgs.{}", s))
            .collect::<Vec<String>>()
            .join(", ");
        let script = format!(
            "#! /usr/bin/env bash\nexec nix-shell {} --run \"{} $*\"",
            packages_to_install, shell_name
        );
        with_file_created(lazy_shell_dir.join(shell_name).as_path(), EXEC, false, |f, filename| {
            debug!("Creating lazy shell @ {:?}", filename);
            f.write_all(script.as_bytes()).expect("Could not write lazy shell script!");
        });
    }
}

fn setup_fish(app_state: &AppState) {
    info!("Setting up fish shell");

    // Setting up oh-my-fish
    let omf_install_path = app_state.home_dir.join(".local/share/omf");
    if ! omf_install_path.is_dir() {
        info!("Installing Oh-My-Fish");
        with_file_created(".oh-my-fish-install", EXEC, true, |f, filename| {
            download_to_file(OMF_INSTALL_URL, f);
            execute_command("fish", vec!(filename, "--noninteractive"));
        });
    }

    // Setting up fisher
    let fisher_install_path = app_state.home_dir.join(".fisher");
    if ! fisher_install_path.is_file() {
        info!("Installing Fisher plugin manager");
        with_file_created(&fisher_install_path, 0o644, false, |f, _| {
            download_to_file(FISHER_INSTALL_URL, f);
        });
    }
    let plugins = vec!("jorgebucaran/fisher", "PatrickF1/fzf.fish", "lilyball/nix-env.fish");
    let fisher_displayable_install_path = fisher_install_path.as_path().display();
    for plugin in plugins {
        let cmd = format!("source {} && fisher install {}", fisher_displayable_install_path, plugin);
        execute_command("fish", vec!("-c", &cmd));
    }

    // Configure FZF
    let fzf_config = app_state.home_dir.join(".config/fish/functions/fzf_configure_bindings.fish");
    execute_command("fish", vec!(fzf_config.to_str().unwrap()));

    // Install themes
    execute_command("fish", vec!("-c", "omf install coffeeandcode 2> /dev/null"));
}

fn setup_zsh(app_state: &AppState) {
    if ! app_state.home_dir.join(".oh-my-zsh").is_dir() {
        info!("Installing Oh-My-Zsh");
        with_file_created(".oh-my-zsh-install", EXEC, true, |f, filename| {
            download_to_file(OMZ_INSTALL_URL, f);
            execute_command("bash", vec!(filename, "--unattended", "--keep-zshrc"));
        });
    } else {
        info!("Oh-My-Zsh is already installed");
    }
}

fn setup_symlinks(app_state: &AppState) {
    info!("Symlinking dotfiles");
    // Symlink normal dotfiles
    let glob_pattern_path = app_state.dotfile_dir.join(".*");
    let glob_pattern = glob_pattern_path.to_str().unwrap();
    for dotfile in glob(glob_pattern).unwrap().filter_map(Result::ok) {
        if dotfile.is_file() {
            let dest = app_state.home_dir.join(dotfile.file_name().unwrap());
            symlink(&dotfile, &dest);
        }
    }

    // Symlink neovim config
    symlink(
        &app_state.dotfile_dir.join("config/nvim/init.vim"),
        &app_state.home_dir.join(".config/nvim/init.vim"),
    );

    // Symlink fish config
    symlink(
        &app_state.dotfile_dir.join("config/fish/config.fish"),
        &app_state.home_dir.join(".config/fish/config.fish")
    );
}

fn setup_all_the_things(app_state: &AppState) {
    debug!("Setting up all the things");
    setup_symlinks(&app_state);
    setup_nix(&app_state, false);
    setup_lazy_shells(&app_state);
    setup_zsh(&app_state);
    setup_fish(&app_state);
}

fn main() {
    let app_state = AppState::new();
    let args = Cli::parse();

    // Setup the logger
    let level = LevelFilter::from_str(&args.log_level).expect("Invalid log level!");
    log::set_logger(&LOGGER).map(|()| log::set_max_level(level)).expect("Could not init logger!");

    match args.command {
        Some(SubCommand::Nix { update }) => setup_nix(&app_state, update),
        Some(SubCommand::LazyShells) => setup_lazy_shells(&app_state),
        Some(SubCommand::Fish) => setup_fish(&app_state),
        Some(SubCommand::Zsh) => setup_zsh(&app_state),
        Some(SubCommand::Symlinks) => setup_symlinks(&app_state),
        None => setup_all_the_things(&app_state)
    };
}
