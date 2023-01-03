{ config, pkgs, ... }:

{
  # Link stuff currently unsupported by home-manager
  xdg = {
    enable = true;
    configFile."cargo" = {
      source = config/cargo;
      recursive = true;
    };
  };

  # Extra utilities
  home.packages = with pkgs; [
    xcp
    any-nix-shell
  ];

  programs.nushell.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -gx EDITOR vim
      set -gx VISUAL vim
      fish_add_path /home/simon/.cargo/bin


      set -gx ATUIN_NOBIND "true"
      atuin init fish | source

      # bind to ctrl-r in normal and insert mode, add any other bindings you want here too
      bind \cr _atuin_search
      bind -M insert \cr _atuin_search

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
      dhcp = {
        body = ''
          if not set -q argv[1] or not set -q argv[2]
            echo "Usage: dhcp <configuration directory> <interface>" 
            exit 1
          end

          docker run -it --rm --name dhcpd --init --net host -v $argv[1]:/data networkboot/dhcpd $argv[2]
        '';
      };
      wally = {
        body = ''
          set tmpfile (mktemp).bin
          wget https://oryx.zsa.io/BP4GQ/latest/binary -O $tmpfile
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
      dd = "dd status=progress";
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

  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      window = {
        decorations = "full";
        title = "Alacritty";
        dynamic_title = true;
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
        size = 8.00;
      };
      colors = {
        primary = {
          background = "#1d1f21";
          foreground = "#c5c8c6";
        };
      };
    };
  };

  programs.taskwarrior  = {
    enable = true;
    #colorTheme = "dark-gray-blue-256";

    config = {
      color = "on";
      confirmation = false;
    };

    extraConfig = ''
      # Originally adapted from  https://github.com/arcticicestudio/igloo
      # License:    MIT

      # References:
      #   https://taskwarrior.org/docs/themes.html
      #   task-color(5)
      #   taskrc(5)

      # rule.precedence.color=deleted,completed,active,keyword.,tag.,project.,overdue,scheduled,due.today,due,blocked,blocking,recurring,tagged,uda.

      #+---------+
      #+ General +
      #+---------+
      color.label=
      color.label.sort=
      color.alternate=
      color.header=bold magenta
      color.footnote=yellow
      color.warning=bold black on yellow
      color.error=bold white on red
      color.debug=magenta

      #+-------------+
      #+ Task States +
      #+-------------+
      color.completed=gray9
      color.deleted=bold gray9
      color.active=bold black on green
      color.recurring=bold magenta
      color.scheduled=
      color.until=
      color.blocking=black on yellow
      color.blocked=bold black on yellow

      #+----------+
      #+ Projects +
      #+----------+
      color.project.none=

      #+----------+
      #+ Priority +
      #+----------+
      color.uda.priority.H=bold
      color.uda.priority.M=bold yellow
      color.uda.priority.L=

      #+------+
      #+ Tags +
      #+------+
      color.tag.next=
      color.tag.none=
      color.tagged=

      #+-----+
      #+ Due +
      #+-----+
      color.due=black on red
      color.due.today=black on bright red
      color.overdue=bold black on bright red

      #+---------+
      #+ Reports +
      #+---------+
      color.burndown.done=bold black on green
      color.burndown.pending=black on red
      color.burndown.started=black on yellow

      color.history.add=bold black on blue
      color.history.delete=bright white on bold black
      color.history.done=bold black on cyan

      color.summary.background=bright white on black
      color.summary.bar=black on cyan

      #+----------+
      #+ Calendar +
      #+----------+
      color.calendar.due=bold black on blue
      color.calendar.due.today=bold black on cyan
      color.calendar.holiday=bold blue on white
      color.calendar.overdue=white on red
      color.calendar.today=bold black on cyan
      color.calendar.weekend=bright white on bright black
      color.calendar.weeknumber=bold black

      #+-----------------+
      #+ Synchronization +
      #+-----------------+
      color.sync.added=green
      color.sync.changed=yellow
      color.sync.rejected=red

      #+------+
      #+ Undo +
      #+------+
      color.undo.after=green
      color.undo.before=red
    '';
  };

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
  };
}

