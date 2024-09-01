{ pkgs, lib, config, ... }:

let 
  inherit (lib) mkIf mkOption types;
  inherit (config.gizmo) lazy-github;
  python-bin = "${pkgs.python311}/bin/python";
  uvx-bin = "${pkgs.uv}/bin/uvx";
  lazy-github-command = "${uvx-bin} --quiet --python ${python-bin} lazy-github";
in
  {
  options.gizmo.lazy-github = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether or not to enable lazy-github";
    };
    addNeovimBinding = mkOption {
      type = types.bool;
      default = true;
      description = "Whether or not to setup a float term binding";
    };
    appearance.dark_mode = mkOption {
      type = types.bool;
      default = true;
      description = "Whether or not to use dark mode";
    };
    repositories.favorites = mkOption {
      type = types.listOf types.str;
      default = [
        "gizmo385/lazy-github"
        "gizmo385/dotfiles"
      ];
      description = "Repositories to pin at the top";
    };
    pull_requests.state_filter = mkOption {
      type = types.enum [ "all" "open" "closed" ];
      default = "all";
      description = "What pull requests to display by default";
    };
    api.base_url = mkOption {
      type = types.str;
      default = "https://api.github.com";
      description = "The API used to pull GitHub information from";
    };
    cache.repo_cache_duration = mkOption {
      type = types.int; 
      default = 3600;
      description = "Number of seconds that repository information should be cached for";
    };
  };

  # TODO: I'd like to set up an actual derivation for this and pull this out as a separate script,
  # but this'll do for now
  config = {
    home.file.lazy-github-config = {
      target = ".config/lazy-github/config.json";
      text = builtins.toJSON {
        appearence.dark_mode = lazy-github.appearance.dark_mode;
        repositories.favorites = lazy-github.repositories.favorites;
        pull_requests.state_filter = lazy-github.pull_requests.state_filter;
        api.base_url = lazy-github.api.base_url;
        cache.repo_cache_duration = lazy-github.cache.repo_cache_duration;
      };
    };

    programs.zsh.shellAliases = mkIf lazy-github.enable {
      lh = lazy-github-command;
      lazy-github = lazy-github-command;
    };
    programs.nixvim.keymaps = mkIf lazy-github.addNeovimBinding [{
      key = "<leader>G";
      action = ":FloatermNew --width=0.9 --height=0.95 ${lazy-github-command}<CR>";
      mode = "n";
      options.silent = true;
    }];
  };
}
