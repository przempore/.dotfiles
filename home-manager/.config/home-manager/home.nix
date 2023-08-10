{ config, pkgs, ... }:

let
  catppuccin-bat = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
    sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
  };
  wezterm_config = builtins.readFile(/home/przemek/.dotfiles/wezterm/.wezterm.lua);
  ranger_config = builtins.readFile(/home/przemek/.dotfiles/ranger/.config/ranger/rc.conf);
  tabnine-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "tabnine-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "codota";
      repo = "tabnie-nvim";
      rev = "352485ea136e9593a5a7dada12eec17a8def881f";
      buildPhase = ''
        ./dl_binaries.sh
      '';
    };
  };
in
{
  home.username = "przemek";
  home.homeDirectory = "/home/przemek";

  home.stateVersion = "23.05";

  home = {
    packages = with pkgs; [
      firefox
    ];

    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "fish";
      VISUAL = "nvim";
    };
  };

  home.keyboard = null;

  home.activation.linkDotfiles = config.lib.dag.entryAfter [ "writeBoundary" ]
    ''
    ln -sfn $HOME/.dotfiles/ranger/.config/ranger/rc.conf       $HOME/.config/ranger/rc.conf
    '';

  programs = {
    firefox = {
      enable = true;
      profiles.default = {
        userChrome = ''
          @import "${
            builtins.fetchGit {
              url = "https://github.com/rockofox/firefox-minima";
              ref = "main";
              rev = "1477b2a28091aad4ebba330c539110c311eb8084";
            }
          }/userChrome.css";
        '';
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
    };

    wezterm = {
      enable = true;

      extraConfig = wezterm_config;
    };

    git = {
      enable = true;

      aliases = {
        lg = "log --graph --pretty=format:'%C(auto)%h -%d %s"
          + " %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
        st = "status -sb";
      };

      userEmail = "przempore@gmail.com";
      userName = "Przemek";
    };

    fish = {
      enable = true;
      shellAliases = {
        vi = "nvim";
      };
      interactiveShellInit = ''
        fish_add_path = /home/przemek/.local/share/nvim/mason/bin/;
        any-nix-shell fish --info-right | source
      '';
    };

    bat = {
      enable = true;
      config = { theme = "catppuccin"; };
      themes = {
        catppuccin = builtins.readFile
          (catppuccin-bat + "/Catppuccin-macchiato.tmTheme");
      };
    };

    neovim = {
      enable = true;

      plugins = with pkgs; [
        # tabnine-nvim
        vimPlugins.copilot-vim
        vimPlugins.vim-fugitive
        vimPlugins.vim-rhubarb
        vimPlugins.nvim-fzf
        vimPlugins.plenary-nvim
        vimPlugins.telescope-nvim
        vimPlugins.telescope-fzf-native-nvim
        vimPlugins.lualine-nvim
        vimPlugins.nvim-fzf
        vimPlugins.vim-qml
        vimPlugins.catppuccin-vim
        vimPlugins.vim-be-good
        vimPlugins.cmp-git
        vimPlugins.git-worktree-nvim
        vimPlugins.harpoon
        vimPlugins.gitsigns-nvim
        vimPlugins.fzf-checkout-vim
        vimPlugins.firenvim
        vimPlugins.fidget-nvim
        vimPlugins.neodev-nvim
        vimPlugins.lsp-zero-nvim
        vimPlugins.mason-tool-installer-nvim
        vimPlugins.mason-nvim
        vimPlugins.mason-lspconfig-nvim
        vimPlugins.nvim-lspconfig
        vimPlugins.nvim-cmp
        vimPlugins.cmp-buffer
        vimPlugins.cmp-path
        vimPlugins.cmp_luasnip
        vimPlugins.cmp-nvim-lsp
        vimPlugins.cmp-nvim-lua
        vimPlugins.luasnip
        vimPlugins.friendly-snippets
        vimPlugins.rust-vim
        vimPlugins.cmp-cmdline
        vimPlugins.lspkind-nvim
        vimPlugins.lsp_extensions-nvim
        vimPlugins.cmp-nvim-lsp-document-symbol
        vimPlugins.cmp-tabnine
        vimPlugins.vim-clang-format
        vimPlugins.undotree
        vimPlugins.nvim-web-devicons
        vimPlugins.nvim-treesitter.withAllGrammars
        vimPlugins.nvim-treesitter-context
        vimPlugins.nvim-treesitter-textobjects
        vimPlugins.playground
        vimPlugins.markdown-preview-nvim
        vimPlugins.zen-mode-nvim
        vimPlugins.comment-nvim
        vimPlugins.vim-sleuth
        vimPlugins.lualine-nvim
        vimPlugins.lspsaga-nvim
        vimPlugins.nvim-notify
        vimPlugins.nvim-lint
        vimPlugins.vim-go
      ];
    };
  };

  programs.home-manager.enable = true;
}
