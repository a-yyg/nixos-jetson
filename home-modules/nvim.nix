{ config, lib, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "xterm";
    mouse = true;
    baseIndex = 1;
    keyMode = "vi";
    prefix = "C-a";
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.onedark-theme
    ];
    extraConfig = ''
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      # vim-like pane switching
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      set -g allow-passthrough on
    '';
  };
  programs.nixvim = {
    enable = true;
    enableMan = true;
    colorscheme = "torte";
    # colorschemes.catppuccin = {
    #   enable = true;
    #   settings.background.dark = "mocha";
    # };
    # # colorschemes.yellow-moon.enable = true;
    opts = {
      hlsearch = false;
      number = true;
      mouse = "a";
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      completeopt = "menuone,noselect";
      termguicolors = true;
      # guifont = "FantasqueSansM Nerd Font:h14";
      # mapleader = "<Space>";
    };
    globals = {
      mapleader = " ";
    };
    keymaps = [
      {
        action = "<cmd>lua require('telescope.builtin').find_files()<CR>";
        key = "<leader>lf";
      }
      {
        action = "<cmd>lua require('telescope.builtin').live_grep()<CR>";
        key = "<leader>lg";
      }
      # {
      #   action = "<cmd>Lspsaga term_toggle<CR>";
      #   key = "<A-d>";
      # }
      {
        action = "<cmd>copilot#Accept(\"<CR>\")";
        key = "<C-S-l>";
      }
      {
        action = "<cmd>Neotree toggle<CR>";
        key = "<C-n>";
      }
    ];
    # extraPackages = with pkgs; [
    #   # vimPlugins.nvim-web-devicons
    #   luajitPackages.lua-utils-nvim
    # ];
    # extraPlugins = with pkgs.vimPlugins; [
    #   orgmode
    #   # (gruvbox-material.overrideAttrs (old: {
    #   #   src = pkgs.fetchFromGitHub {
    #   #     repo = "gruvbox-material";
    #   #     owner = "sainnhe";
    #   #     rev = "80331fbbec9ba18590a17bc6b7d277d96c05c2b6";
    #   #     sha256 = "sha256-a6rbmGB5WlGG2deEwo5e/anR1S35gfmAYc+sNxnHp5I=";
    #   #   };
    #   # }))
    #   # (pkgs.vimUtils.buildVimPlugin {
    #   #   name = "palenight";
    #   #   src = pkgs.fetchFromGitHub {
    #   #     owner = "alexmozaidze";
    #   #     repo = "palenight.nvim";
    #   #     rev = "43445069c058a717183458cb895b68563e91ff22";
    #   #     sha256 = "sha256-Qa8qUC0oAByYtDoxdZEZTPBM0n6P3WOAn0uL01j0W+k=";
    #   #   };
    #   # })
    # ];
    clipboard = {
      register = "unnamedplus";
      providers = {
        wl-copy.enable = true;
        xclip.enable = true;
      };
    };
    # #lsp config
    plugins = {
      telescope = {
        enable = true;
        # extensions = {
        #   fzf-native = {
        #     enable = true;
        #     settings = { caseMode = "smart_case"; };
        #   };
        # };
        defaults = {
          # layout_config = {
          #   prompt_position = "top";
          #   preview_width = 0.6;
          #   width = 0.8;
          #   height = 0.8;
          # };
          # mappings.n = {
          #   "<leader>lg".__raw = "require('telescope.builtin').live_grep()";
          #   "<leader>lf".__raw = "require('telescope.builtin').find_files()";
          # };
        };
      };
      lspsaga.enable = true;
      # dashboard = { enable = true; };
      # lsp = {
      #   enable = true;
      #   servers = {
      #     # tsserver.enable = true;
      #     # rust-analyzer = {
      #     #   enable = true;
      #     #   installCargo = false;
      #     #   installRustc = false;
      #     # };
      #     # lua-ls.enable = true;
      #     pyright.enable = true;
      #     # dockerls.enable = true;
      #     # nil_ls.enable = true;
      #   };
      # };
      # lspkind.enable = true;
      # image.enable = true;
      # rust-tools.enable = true;
      # lsp-format.enable = true;
      # luasnip.enable = true;
      # cmp_luasnip.enable = true;
      # cmp-treesitter.enable = true;
      # which-key.enable = true;
      # nvim-autopairs.enable = true;
      # direnv.enable = true;
      neo-tree.enable = true;
      fugitive.enable = true;
      # lazygit.enable = true;
      gitsigns.enable = true;
      treesitter = {
        enable = true;
        ensureInstalled = "all";
        incrementalSelection = {
          enable = true;
          keymaps = {
            initSelection = "+";
            nodeIncremental = "+";
            nodeDecremental = "-";
          };
        };
        nixvimInjections = true;
      };
      #treesitter-context.enable = true;
      # barbar = {
      #   enable = true;
      #   autoHide = true;
      #   clickable = true;
      # };
      nix.enable = true;
      tmux-navigator.enable = true;
      # cmp = {
      #   enable = true;
      #   autoEnableSources = true;
      #   settings = {
      #     mapping = {
      #       "<Down>" = "cmp.mapping.select_next_item()";
      #       "<Up>" = "cmp.mapping.select_prev_item()";
      #       "<C-d>" = "cmp.mapping.scroll_docs(-4)";
      #       "<C-f>" = "cmp.mapping.scroll_docs(4)";
      #       "<C-Space>" = " cmp.mapping.complete {}";
      #       "<CR>" = "cmp.mapping.confirm({ select = true })";
      #       "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
      #       "<S-Tab>" =
      #         "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
      #     };
      #     sources = [
      #       { name = "nvim_lsp"; }
      #       { name = "path"; }
      #       { name = "buffer"; }
      #       { name = "luasnip"; }
      #     ];
      #     snippet.expand = ''
      #       function(args)
      #       require "luasnip".lsp_expand(args.body)
      #       end
      #     '';
      #   };
      # };
      # cmp-nvim-lsp = { enable = true; };
      # lualine = {
      #   enable = true;
      #   iconsEnabled = false;
      #   # theme = "onedark";
      #   componentSeparators = {
      #     left = " ";
      #     right = " ";
      #   };
      #   sectionSeparators = {
      #     left = " ";
      #     right = " ";
      #   };
      # };

      # comment = { enable = true; };

      # noice = {
      #   enable = true;
      #   lsp = {
      #     override = {
      #       "vim.lsp.util.convert_input_to_markdown_lines" = true;
      #       "vim.lsp.util.stylize_markdown" = true;
      #       "cmp.entry.get_documentation" = true;
      #     };
      #   };
      #   cmdline = { view = "cmdline"; };
      #   presets = {
      #     bottom_search = true; # use a classic bottom cmdline for search
      #     command_palette = true; # position the cmdline and popupmenu together
      #     long_message_to_split = true; # long messages will be sent to a split
      #     inc_rename = false; # enables an input dialog for inc-rename.nvim
      #     lsp_doc_border =
      #       false; # add a border to hover docs and signature help
      #   };
      # };
    };
  };
}
