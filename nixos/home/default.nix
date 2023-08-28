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
in
{
  imports = [
    ./nvim
    ./firefox.nix
    ./git.nix
    ./tmux.nix
    ./fish.nix
    # ./sxhkd.nix
  ];
  home = {
    username = "przemek";
    homeDirectory = "/home/przemek";

    packages = with pkgs; [
      cachix
      neocmakelsp
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

  programs = {
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
