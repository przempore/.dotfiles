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
  my_config-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "my_config-nvim";
    src = /home/przemek/.dotfiles/nvim-nix;
  };
  pkgsUnstable = import <nixpkgs-unstable> {};
in
{
  home.username = "przemek";
  home.homeDirectory = "/home/przemek";

  home.stateVersion = "23.05";

  home = {
    packages = with pkgs; [
      firefox
      pkgsUnstable.neocmakelsp
    ];

    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "fish";
      VISUAL = "nvim";
    };
    keyboard = null;
    activation.linkDotfiles = config.lib.dag.entryAfter [ "writeBoundary" ]
      ''
      ln -sfn $HOME/.dotfiles/ranger/.config/ranger/rc.conf       $HOME/.config/ranger/rc.conf
      '';
  };

  xdg.configFile.nvim = {
    enable = true;
    source = "/home/przemek/.dotfiles/nvim/.config/nvim";
  };

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

      delta = {
        enable = true;
        options = {
          chameleon = {
            dark = true;
            line-numbers = true;
            side-by-side = true;
            keep-plus-minus-markers = true;
            syntax-theme = "Nord";
            file-style = "#434C5E bold";
            file-decoration-style = "#434C5E ul";
            file-added-label = "[+]";
            file-copied-label = "[==]";
            file-modified-label = "[*]";
            file-removed-label = "[-]";
            file-renamed-label = "[->]";
            hunk-header-style = "omit";
            line-numbers-left-format = " {nm:>1} │";
            line-numbers-left-style = "red";
            line-numbers-right-format = " {np:>1} │";
            line-numbers-right-style = "green";
            line-numbers-minus-style = "red italic black";
            line-numbers-plus-style = "green italic black";
            line-numbers-zero-style = "#434C5E italic";
            minus-style = "bold red";
            minus-emph-style = "bold red";
            plus-style = "bold green";
            plus-emph-style = "bold green";
            zero-style = "syntax";
            blame-code-style = "syntax";
            blame-format = "{author:<18} ({commit:>7}) {timestamp:^12} ";
            blame-palette = "#2E3440 #3B4252 #434C5E #4C566A";
          };
          features = "chameleon";
          side-by-side = true;
        };
      };
    };

    fish = {
      enable = true;
      shellAliases = {
        vi = "nvim";
        ll = "exa --tree --level=1 --long --icons --git -lh";
        lh = "ll -lah";
      };
      interactiveShellInit = ''
        any-nix-shell fish --info-right | source
        [ -f /home/porebski/.dotfiles/private/fish/config.fish ]; and source /home/porebski/.dotfiles/private/fish/config.fish
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
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

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

      extraPackages = with pkgs; [
        # languages
        jsonnet
        nodejs
        python311Full
        rustc

        # language servers
        gopls
        haskell-language-server
        jsonnet-language-server
        lua-language-server
        nil
        nodePackages."bash-language-server"
        nodePackages."diagnostic-languageserver"
        nodePackages."dockerfile-language-server-nodejs"
        nodePackages."pyright"
        nodePackages."typescript"
        nodePackages."typescript-language-server"
        nodePackages."vscode-langservers-extracted"
        nodePackages."yaml-language-server"
        rust-analyzer
        terraform-ls

        # formatters
        gofumpt
        golines
        nixpkgs-fmt
        python310Packages.black
        rustfmt

        # tools
        cargo
        gcc
        ghc
        lazydocker
        yarn
      ];
    };
  };

  programs.home-manager.enable = true;
}
