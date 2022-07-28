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


  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -gx EDITOR vim
      set -gx VISUAL vim
      fish_add_path /home/simon/.cargo/bin
    '';
    functions = {
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
    };

    shellAbbrs = {
      clion = "clion . 1>/dev/null 2>&1 &";
    };

    shellAliases = {
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    aliases = {
      br = "branch -vv";
      ci = "commit";
      co = "checkout";
      cp = "cherry-pick";
      d  = "diff";
      ds = "diff --staged";
      rb = "rebase";
      sh = "show";
      sm = "submodule";
      smu = "submodule update --recursive --init";
      st = "status";
      ll = "log --graph --pretty=format:'%C(yellow)%h%Creset -%C(red)%d%Creset %s %Cgreen(%cr) %C(blue)[%an]%Creset' --branches --remotes --date=relative";
      lb = "log --graph --pretty=format:'%C(yellow)%h%Creset -%C(red)%d%Creset %s %Cgreen(%cr) %C(blue)[%an]%Creset' --date=relative";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      # Cleans out all files that isn't under version control.
      ca = "submodule foreach git clean -ffdq"; 
      find = "log --all --pretty=format:'%C(yellow)%h%Creset -%C(red)%d%Creset %s %Cgreen(%cr) %C(blue)[%an]%Creset' --branches --name-status --grep";
      rah = "!git submodule foreach git clean -ffdq && git submodule foreach git reset --hard && git submodule update --recursive --init";
      amend = "commit --amend --date=now";
      template = "!f() { git clone --depth=1 --branch=main git@github.com:simonkampe/template-\"$1\".git \"$2\"; rm -rf \"$2\"/.git; }; f";
    };

    # Include an identity file, for example:
    # [user]
    # name = Simon Kämpe
    # email = simon.kampe@gmail.com
    includes = [
      { path = "~/.gitconfig-identity"; }
    ];

    extraConfig = {
      core = {
        editor = "vim";
      };
      init = {
        defaultBranch = "main";
      };
      log = {
        follow = "true";
      };
      pull = {
        ff = "only";
        rebase = "true";
      };
      push = {
        default = "current";
      };
      fetch = {
        prune = "true";
        pruneTags = "true";
      };
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

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      fzf
    ];

    plugins = with pkgs.vimPlugins; [
      vim-gitgutter
      vim-fugitive
      vim-nix
      vim-nixhash
      {
        plugin = nvim-fzf;
        config = ''
          " Search files
          nnoremap <C-p> :Files<CR>
          inoremap <C-p> <ESC>:Files<CR>

          " Search buffers
          nnoremap <C-b> :Buffers<CR>
          inoremap <C-b> <ESC>:Buffers<CR>

          " Search
          nnoremap <C-f> :Ag<CR>
          inoremap <C-f> <ESC>:Ag<CR>

          " Search git commits
          nnoremap <C-c> :Commits<CR>
          inoremap <C-c> <ESC>:Commits<CR>
        '';
      }
      {
        plugin = nord-vim;
        config = "colorscheme nord";
      }
      {
        plugin = lightline-vim;
        config = ''
          set noshowmode
          let g:lightline = { 'colorscheme': 'nord' }
        '';
      }
    ];

    extraConfig = ''
      set number relativenumber
      set mouse=a
    '';
  };

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
  };
}

