use std::process::{Command, Output};
use clap::{Parser, Subcommand};
use std::fs::File;
use std::os::unix::fs::PermissionsExt;
use std::io;
use reqwest;
use reqwest::Error;

#[derive(Parser)]
#[clap(version, about = "CLI tool for managing local dotfiles.")]
struct Cli {
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

fn execute_command(cmd: &str, args: Vec<&str>) -> Output {
    Command::new(cmd)
            .args(args)
            .output()
            .expect(&format!("Failed to execute command: {:?}", cmd).to_string())
}

fn set_permissions(f: &mut File, f_perms: u32) {
    let mut perms = f.metadata().expect("Could not get metadata").permissions();
    perms.set_mode(f_perms);
}

fn download_to_file(url: &str, filename: &str, perms: u32) -> File {
    let mut download_destination = File::create(filename).expect("Could not create file!");
    set_permissions(&mut download_destination, perms);
    let mut resp = reqwest::blocking::get(url).expect("Could not send HTTP request");
    io::copy(&mut resp, &mut download_destination).expect("failed to copy content");
    return download_destination;
}

fn setup_nix(update: bool) {
    println!("Setting up nix (update = {:?})", update);
}

fn setup_lazy_shells() {
    println!("Setting lazy shells");
}

fn setup_fish() {
    println!("Setting up fish");
}

fn setup_zsh() {
    println!("Setting up zsh");
    let install_url = "https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh";
    let output_file = download_to_file(install_url, ".oh-my-zsh-install", 744);
    execute_command("bash", vec!(".oh-my-zsh-install", "--unattended", "--keep-zshrc"));
}

fn setup_symlinks() {
    println!("Setting up symlinks");
}

fn setup_all_the_things() {
    println!("Setting up all the things");
}

fn main() {
    let result = match Cli::parse().command {
        Some(SubCommand::Nix { update }) => setup_nix(update),
        Some(SubCommand::LazyShells) => setup_lazy_shells(),
        Some(SubCommand::Fish) => setup_fish(),
        Some(SubCommand::Zsh) => setup_zsh(),
        Some(SubCommand::Symlinks) => setup_symlinks(),
        None => setup_all_the_things()
    };
}

