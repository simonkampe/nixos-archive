{ config, pkgs, ... }:

{
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
      silver-searcher
      ripgrep
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
        plugin = nord-nvim;
        config = ''
          colorscheme nord
        '';
      }
      {
        plugin = lightline-vim;
        config = ''
          set noshowmode
          let g:lightline = { 'colorscheme': 'nord' }
        '';
      }
      {
        plugin = nvim-lspconfig;
        config = ''
          lua << EOF
            -- Rust
            local nvim_lsp = require'lspconfig'

            -- Mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            local opts = { noremap=true, silent=true }
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
            local on_attach = function(client, bufnr)
              -- Enable completion triggered by <c-x><c-o>
              vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

              -- Mappings.
              -- See `:help vim.lsp.*` for documentation on any of the below functions
              local bufopts = { noremap=true, silent=true, buffer=bufnr }
              vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
              vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
              vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
              vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
              vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
              vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
              vim.keymap.set('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end, bufopts)
              vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
              vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
              vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
              vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
              vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
            end

            nvim_lsp.rust_analyzer.setup({
              on_attach=on_attach,
              settings = {
                ["rust-analyzer"] = {
                  imports = {
                    granularity = {
                      group = "module",
                    },
                    prefix = "self",
                  },
                  cargo = {
                    buildScripts = {
                      enable = true,
                    },
                  },
                  procMacro = {
                    enable = true
                  },
                }
              }
            })
          EOF
        '';
      }
    ];

    extraConfig = ''
      " Make FZF respect .gitignore
      let $FZF_DEFAULT_COMMAND = 'ag -g ""'

      " Fix dark colours in Nord theme
      highlight Comment ctermfg=darkgray cterm=italic
      highlight LineNr ctermfg=gray

      lua << EOF
        vim.wo.number = true
        vim.wo.relativenumber = true

        vim.o.mouse = "a"
      EOF
    '';
    #''
    #  set number relativenumber
    #  set mouse=a
    #'';
  };
}

