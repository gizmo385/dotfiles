from __future__ import print_function

from distutils import spawn # For find_executable
from datetime import datetime # For timestamps
from os import path # For path.abspath
import shutil # For copy
import errno
import json # To parse the input
import subprocess # To execute shell commands
import sys # To exit the program with an exit status

flatten = lambda l: [item for sublist in l for item in sublist]

log_file = "dotfiles_log"

def execute_shell_command(command, *args):
    finished_command = command.split(" ")
    finished_command.extend(flatten(map(lambda arg: arg.split(" "), args)))

    with open(log_file, "a") as output:
        output.write(" ".join(finished_command) + "\n")
        # return subprocess.call(["echo", "Command:"] + finished_command,
                               # stdout=output, stderr=output)
        return subprocess.call(finished_command, stdout=output, stderr=output)


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


def copy(src, dst):
    src = path.abspath(src)
    src = path.abspath(src)
    try:
        shutil.copytree(src, dst)
    except OSError as exc:
        if exc.errno == errno.ENOTDIR:
            shutil.copy(src, dst)
        else:
            raise

def copy_dotfiles(config):
    """Copies the dotfiles into the installation directory"""
    dest = path.abspath(config["install_dir"])
    src = path.abspath(config["dotfiles_folder"])

    copy_message= "\tCopying {src}/{name} into to {dest}."

    dotfile_groups = config["dotfiles"]
    for group in dotfile_groups:
        print("Copying {group} dotfiles".format(group=group))

        for dotfile in dotfile_groups[group]:
            copy("{src}/{name}".format(src=src, name=dotfile),
                 "{dest}/{name}".format(dest=dest, name=dotfile))
            print(copy_message.format(src=src, name=dotfile, dest=dest))


def create_links(config):
    if "link_dir" not in config:
        return

    install = path.abspath(config["install_dir"])
    link = path.abspath(config["link_dir"])

    # String formats
    success = "\tCreated link: {src}/{name} --> {dest}/{name}"
    error = "\tError creating link: {src}/{name} --> {dest}/{name}"
    command = "ln -s {src}/{name} {dest}/{name}"

    print("Creating symbolic links:")
    dotfile_groups = config["dotfiles"]
    for group in dotfile_groups:
        for dotfile in dotfile_groups[group]:
            # Execute the commmand
            status = execute_shell_command(command.format(src=install,
                                                          dest=link,
                                                          name=dotfile))

            if status != 0:
                print(error.format(src=install, dest=link, name=dotfile))
            else:
                print(success.format(src=install, dest=link, name=dotfile))


def execute_commands(config):
    """Executes custom commands associated with the dotfiles config"""
    custom_commands = config["commands"]

    for command in custom_commands:
        print(command["message"])
        execute_shell_command(command["command"])


def install_dotfiles(config):
    if "install_dir" not in config:
        print("An installation directory is required!")
        sys.exit(1)

    if "dotfiles_folder" not in config:
        print("You must provide the location of the dotfiles to install!")
        sys.exit(1)

    print("Writing command output to", log_file)

    with open(log_file, "a") as f:
        f.write("Starting install at: {time}\n".format(time=datetime.now()))

    # Run through the installation
    package_sources = get_package_sources(config)
    install_packages(config, package_sources)
    copy_dotfiles(config)
    create_links(config)
    execute_commands(config)

    with open(log_file, "a") as f:
        f.write("Finishing install at: {time}\n".format(time=datetime.now()))


with open("dotfiles.json") as f:
    install_dotfiles(json.loads(f.read()))
