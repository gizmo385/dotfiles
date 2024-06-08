{ inputs
, pkgs
, config
, lib
, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (config.gizmo) graphical;
in
{
  options.gizmo.graphical = mkOption {
    type = types.bool;
    default = false;
    description = "Install UI packages";
  };

  config = mkIf graphical {
    nixpkgs = {
      # This overlay allows us to wrap some packages in NixGL to fix OpenGL
      overlays = [ inputs.nixgl.overlays.default ];

      # This allows us to specify certain unfree programs that we want to be able to install. The
      # nividia inclusion here is required by NixGL for nividia drivers
      config.allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) [
        "nvidia"
        "spotify"
      ];
    };
    programs = {
      # A better terminal emulator
      terminator = {
        enable = true;
        config.profiles.default = {
            background_color = "#282828";
            font = "FiraCode Nerd Font Mono 10";
            foreground_color = "#ebdbb2";
            show_titlebar = false;
            use_system_font = false;
          };
      };
      i3status.enable = true;
    };

    xsession = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        config.terminal = "terminator";
        extraConfig = ''
        # class                 border  bground text    indicator child_border
        client.focused          #4C7899 #285577 #FFFFFF #2E9EF4   #285577
        client.focused_inactive #333333 #5F676A #FFFFFF #484E50   #5F676A
        client.unfocused        #333333 #222222 #888888 #292D2E   #222222
        client.urgent           #2F343A #900000 #FFFFFF #900000   #900000
        client.placeholder      #000000 #0C0C0C #FFFFFF #000000   #0C0C0C

        client.background       #FFFFFF

        bar {
          colors {
            background #000000
            statusline #FFFFFF
            separator  #666666

            focused_workspace  #4C7899 #285577 #FFFFFF
            active_workspace   #333333 #222222 #FFFFFF
            inactive_workspace #333333 #222222 #888888
            urgent_workspace   #2F343A #900000 #FFFFFF
            binding_mode       #2F343A #900000 #FFFFFF
          }
        }

        bindsym $mod+d exec "dmenu_run -nf '#BBBBBB' -nb '#222222' -sb '#005577' -sf '#EEEEEE' -fn 'monospace-10' -p 'dmenu prompt &gt;'"
        '';
      };
    };

    fonts.fontconfig.enable = true;

    home = {
      sessionVariables = {
        # Add the nix to our XDG_DATA_DIRS, which allows application search for find them
        XDG_DATA_DIRS = "$HOME/.nix-profile/bin:$HOME/.nix-profile/share:$XDG_DATA_DIRS";
      };
      packages = with pkgs; [
        # Can't do without music
        spotify
        # Fonts with better code support
        fira-code
        fira-code-nerdfont
      ];
    };
  };
}
