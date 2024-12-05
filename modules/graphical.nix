{ pkgs
, config
, lib
, ... }:

let
  inherit (lib) mkIf;
  inherit (config.gizmo) graphical;

  i3Mod = "Mod4";
in
{
  config = mkIf graphical {
    nixpkgs = {
      # This allows us to specify certain unfree programs that we want to be able to install. The
      # nividia inclusion here is required by NixGL for nividia drivers
      config.allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) [
        "nvidia"
        "spotify"
      ];
    };

    programs = {
      zsh.profileExtra = ''
      startx
      '';

      # A better terminal emulator
      terminator = {
        enable = true;
        config.profiles.default = {
            background_color = "#282828";
            font = "FiraCode Nerd Font Mono 12";
            foreground_color = "#ebdbb2";
            show_titlebar = false;
            use_system_font = false;
          };
      };
      
      # A status bar for i3
      i3status-rust = {
        enable = true;
        bars.default = {
          icons = "awesome6";
          theme = "gruvbox-dark";
          blocks = [
            {
              block = "time";
              interval = 5;
              format = " $timestamp.datetime(f:'%a %d/%m %R') ";
            }
            {
              block = "sound";
            }
            {
              block = "memory";
              format = " $icon $mem_total_used_percents.eng(w:2) ";
              format_alt = " $icon_swap $swap_used_percents.eng(w:2) ";
            }
            {
              block = "cpu";
              interval = 1;
              info_cpu = 20;
              warning_cpu = 50;
              critical_cpu = 90;
            }
            {
              block = "load";
              interval = 1;
              format = "{1m}";
            }
          ];
        };
      };
    };

    xsession = {
      enable = true;
      windowManager = {
        command = "${pkgs.i3}/bin/i3";
        i3 = {
          enable = true;
          config = {
            terminal = pkgs.terminator;
            fonts = {
              names = ["FiraCode Nerd Font Mono"];
              size = 10.0;
              style = "Regular";
            };
            keybindings = {
              # Switcher
              "${i3Mod}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";

              # Managing i3
              "${i3Mod}+Shift+r" = "reload";
              "${i3Mod}+Shift+x" = "restart";

              # Focus
              "${i3Mod}+h" = "focus left";
              "${i3Mod}+j" = "focus down";
              "${i3Mod}+k" = "focus up";
              "${i3Mod}+l" = "focus right";

              # Move
              "${i3Mod}+Shift+h" = "move left";
              "${i3Mod}+Shift+j" = "move down";
              "${i3Mod}+Shift+k" = "move up";
              "${i3Mod}+Shift+l" = "move right";

              # Resize windows
              "${i3Mod}+Ctrl+h" = "resize shrink width 10px or 10 ppt";
              "${i3Mod}+Ctrl+j" = "resize grow height 10px or 10 ppt";
              "${i3Mod}+Ctrl+k" = "resize shrink height 10px or 10 ppt";
              "${i3Mod}+Ctrl+l" = "resize grow width 10px or 10 ppt";
            };

            bars = [
              {
                position = "bottom";
                fonts = {
                  names = ["FiraCode Nerd Font Mono"];
                  size = 12.0;
                  style = "Regular";
                };
                statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs config-default.toml";
              }
            ];
          };
        };
      };
    };

    fonts.fontconfig.enable = true;

    home = {
      sessionVariables = {
        # Add the nix to our XDG_DATA_DIRS, which allows application search for find them
        XDG_DATA_DIRS = "$HOME/.nix-profile/bin:$HOME/.nix-profile/share:$XDG_DATA_DIRS";
        NO_AT_BRIDGE = 1;
      };

      packages = with pkgs; [
        # Window management settings
        i3lock
        dmenu
      ];
    };
  };
}
