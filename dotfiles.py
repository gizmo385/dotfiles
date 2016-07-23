from __future__ import print_function

from distutils import spawn # For find_executable
import json # To parse the input
import subprocess # To execute shell commands
import sys # To exit the program with an exit status

flatten = lambda l: [item for sublist in l for item in sublist]

def execute_shell_command(command, *args):
    finished_args = command.split(" ")
    finished_args.extend(flatten(map(lambda arg: arg.split(" "), args)))
    finished_args = finished_args

    print("Command:", " ".join(finished_args))
    return 0

    # return subprocess.call(finished_args)

def command_exists(command_to_check):
    return spawn.find_executable(command_to_check) is not None

def get_package_sources(config):
    """
    Determines valid package sources from the config file and returns them
    """
    possible_sources = config["package_sources"]
    found_sources = []
    return [src for src in possible_sources if command_exists(src["base_command"])]


def install_packages(config, package_sources):
    """Installs the packags from the available package sources"""
    package_groups = config["package_groups"]

    for source in package_sources:
        install = source["install_command"]
        packages = package_groups.get(source["name"], [])

        for package in packages:
            print("Attempting to install", package)
            status = execute_shell_command(install, package)

            if status != 0:
                print("Error while installing package:", package)


def copy_dotfiles(config):
    """Copies the dotfiles into the installation directory"""
    install_dir = config["install_dir"]
    copy_message= "\tCopying {name} to {install_dir}."

    dotfile_groups = config["dotfiles"]
    for group in dotfile_groups:
        print("Copying {group} dotfiles".format(group=group))

        for dotfile in dotfile_groups[group]:
            print(copy_message.format(name=dotfile, install_dir=install_dir))


def create_links(config):
    if "link_dir" not in config:
        return

    print("Creating symbolic links:")

    install_dir = config["install_dir"]
    link_dir = config["link_dir"]

    message = "\t{src}/{name} --> {dest}/{name}"

    dotfile_groups = config["dotfiles"]
    for group in dotfile_groups:
        for dotfile in dotfile_groups[group]:
            print(message.format(src=install_dir, dest=link_dir, name=dotfile))

    pass


def execute_commands(config):
    """Executes custom commands associated with the dotfiles config"""
    custom_commands = config["commands"]

    for command in custom_commands:
        print(command["message"])
        print("\t", command["command"])
    pass


def install_dotfiles(config):
    if "install_dir" not in config:
        print("An installation directory is required!")
        sys.exit(1)

    # Run through the installation
    package_sources = get_package_sources(config)
    install_packages(config, package_sources)
    copy_dotfiles(config)
    create_links(config)
    execute_commands(config)


with open("dotfiles.json") as f:
    install_dotfiles(json.loads(f.read()))
