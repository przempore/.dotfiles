{ config, pkgs, ... }:

let
  catppuccin-bat = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
    sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
  };
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
  # my_config-nvim = pkgs.vimUtils.buildVimPlugin {
  #   name = "my_config-nvim";
  #   src = home.homeDirectory/.dotfiles/nvim-nix;
  # };
  # pkgsUnstable = import <nixpkgs-unstable> {};
in
{
  imports = [
    ./nvim
    ./firefox.nix
    ./git.nix
    ./tmux.nix
  ];
  home = {
    username = "przemek";
    homeDirectory = "/home/przemek";

    packages = with pkgs; [
      cachix
      # pkgsUnstable.neocmakelsp
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
      ln -sfn $HOME/.dotfiles/wezterm/.wezterm.lua                $HOME/.wezterm.lua
      '';

    stateVersion = "23.05";
  };

  # xdg = {
  #   enable = true;
  #   configHome.folder.".config/nvim".source = 
  # };

  # xdg.configFile = { 
  #   nvim = {
  #     enable = true;
  #     source = /home/przemek/.dotfiles/nvim/.config/nvim;
  #   };
  # };

  programs = {

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

  };

  programs.home-manager.enable = true;
}
