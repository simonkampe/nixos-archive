{ config, pkgs, ... }:

{
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "simon";
  home.homeDirectory = "/home/simon";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Extra utilities
  home.packages = with pkgs; [
    # Shell
    any-nix-shell

    # Network/web
    curl
    nmap
    wget

    # Filesystem
    parted
    p7zip

    # Hardware
    glxinfo
    pciutils
    usbutils
    inxi

    # Utilities
    htop
    imagemagick
    iperf
    killall
    screen
    silver-searcher
    unrar
    unzip
    xcp

    # Terminal
    alacritty
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -gx EDITOR vim
      set -gx VISUAL vim
      set -gx NIX_SHELL_PRESERVE_PROMPT 1

      fish_add_path /home/simon/.cargo/bin


      set -gx ATUIN_NOBIND "true"
      atuin init fish | source

      # bind to ctrl-r in normal and insert mode, add any other bindings you want here too
      bind \cr _atuin_search
      bind -M insert \cr _atuin_search

      # Use ksshaskpass
      if command -s ksshaskpass > /dev/null
        set -gx SSH_ASKPASS $(command -s ksshaskpass)
      end

      set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh"

      any-nix-shell fish --info-right | source
    '';
    functions = {
      ducks = {
        body = ''
          sudo du -cks $argv | sort -rn | head
        '';
      };
      fish_greeting = {
        body = ''
          echo
          echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
          echo -e (uptime | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
          echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
          echo -e " \\e[1mDisk usage:\\e[0m"
          echo
          echo -ne (\
              df -l -h 2>/dev/null | grep -E 'dev/(nvme|xvda|sd|mapper)' | \
              awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
              sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
              paste -sd '''\
          )
          echo

          echo -e " \\e[1mNetwork:\\e[0m"
          echo
          # http://tdt.rocks/linux_network_interface_naming.html
          echo -ne (\
              ip addr show up scope global | \
                  grep -E ': <|inet' | \
                  sed \
                      -e 's/^[[:digit:]]\+: //' \
                      -e 's/: <.*//' \
                      -e 's/.*inet[[:digit:]]* //' \
                      -e 's/\/.*//'| \
                  awk 'BEGIN {i=""} /\.|:/ {print i" "$0"\\\n"; next} // {i = $0}' | \
                  sort | \
                  column -t -R1 | \
                  # public addresses are underlined for visibility \
                  sed 's/ \([^ ]\+\)$/ \\\e[4m\1/' | \
                  # private addresses are not \
                  sed 's/m\(\(10\.\|172\.\(1[6-9]\|2[0-9]\|3[01]\)\|192\.168\.\).*\)/m\\\e[24m\1/' | \
                  # unknown interfaces are cyan \
                  sed 's/^\( *[^ ]\+\)/\\\e[36m\1/' | \
                  # ethernet interfaces are normal \
                  sed 's/\(\(en\|em\|eth\)[^ ]* .*\)/\\\e[39m\1/' | \
                  # wireless interfaces are purple \
                  sed 's/\(wl[^ ]* .*\)/\\\e[35m\1/' | \
                  # wwan interfaces are yellow \
                  sed 's/\(ww[^ ]* .*\).*/\\\e[33m\1/' | \
                  sed 's/$/\\\e[0m/' | \
                  sed 's/^/\t/' \
              )
          echo

          set_color normal
        '';
      };
      wally = {
        body = ''
          set tmpfile (mktemp).bin
          wget https://oryx.zsa.io/$argv/latest/binary -O $tmpfile
          sudo wally-cli $tmpfile
        '';
      };
    };

    shellAbbrs = {
      clion = "clion . 1>/dev/null 2>&1 &";
      idea = "idea-community . 1>/dev/null 2>&1 &";
      pycharm = "pycharm-community . 1>/dev/null 2>&1 &";
    };

    shellAliases = {
      flake = "nix flake";
      cp = "xcp";
    };
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = false; # This is added in fish config instead
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      command_timeout = 1000;
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  xdg = {
    configFile."alacritty" = {
      source = ./config/alacritty;
      recursive = true;
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      window = {
        decorations = "full";
        title = "Alacritty";
        dynamic_title = true;
        padding = {
          x = 10;
          y = 10;
        };
        dynamic_padding = true;
        class = {
          instance = "Alacritty";
          general = "Alacritty";
        };
      };
      font = {
        normal = {
          family = "FiraCode Nerd Font";
          style = "regular";
        };
        bold = {
          family = "FiraCode Nerd Font";
          style = "bold";
        };
        italic = {
          family = "FiraCode Nerd Font";
          style = "regular";
        };
        bold_italic = {
          family = "FiraCode Nerd Font";
          style = "regular";
        };
        size = 10.00;
      };
      import = [
        config/alacritty/colors/catppuccin-frappe.yml
      ];
    };
  };

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
  };

  services.syncthing = {
    enable = true;
    tray.enable = true;
    tray.command = "syncthingtray --wait";
    extraOptions = [ ];
  };
}
