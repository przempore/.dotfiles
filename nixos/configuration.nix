# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  compiledLayout = pkgs.runCommand "keyboard-layout" {} ''
    ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${ ./keyboard/symbols/real-prog-dvorak.xkb} $out
  '';
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./nix-alien.nix
      # <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "przemek" ];

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  # Refer to the following link for more details:
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

#   programs.hyprland = {
#     enable = true;
#     # nvidiaPatches = true;
#     xwayland.enable = true;
#   };
#
#   environment.sessionVariables = {
#     # If your cursor becomes invisible
#     WLR_NO_HARDWARE_CURSORS = "1";
#     # Hint electron apps to use wayland
#     NIXOS_OZONE_WL = "1";
#   };
#
# # XDG portal
#   xdg.portal.enable = true;
#   xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
#

  # LightDM Display Manager
  services.xserver.displayManager.defaultSession = "none+bspwm";
  services.xserver.displayManager.sessionCommands = "${pkgs.xorg.xkbcomp}/bin/xkbcomp ${compiledLayout} $DISPLAY";
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.slick.enable = true;
    # greeter.enable = true;
  };

  # Tiling window manager
  services.xserver.windowManager.bspwm = {
    enable = true;
    configFile = ./config/bspwmrc;
    sxhkd.configFile = ./config/sxhkdrc;
  };

  # Configure keymap in X11
  services.xserver = {
    autoRepeatDelay = 200;
    autoRepeatInterval = 25;
    layout = "pl";
    xkbVariant = "dvp";
  };

  services.logind.extraConfig = "RuntimeDirectorySize=4G"; # I don't know if that's needed

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.opengl.enable = true;
  # hardware.nvidia.modesetting.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.przemek = {
    isNormalUser = true;
    description = "Przemek";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
      git
      stow
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    noto-fonts-emoji
    dejavu_fonts
    liberation_ttf
    source-code-pro
    siji
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" ]; })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
# waybar
    # (pkgs.waybar.overrideAttrs (oldAttrs: {
    #     mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    #   })
    # )
    # hyprland

    home-manager
    direnv
    neovim
    tabnine
    fish
    any-nix-shell
    wget
    ripgrep
    firefox
    starship
    autojump
    youtube-dl
    keepassxc

    xorg.xbacklight
    killall

    gcc
    clang-tools
    clang
    cmake
    # neocmakelsp # why that doesn't work?
    ninja
    ccache
    sccache
    cargo
    rustup
    rustfmt
    rust-analyzer
    go
    gopls
    black
    mypy
    nodejs
    nodePackages_latest.pyright
    # vivictpp

    geany
    git
    bat
    exa
    htop
    xfce.xfce4-power-manager
    arandr

    tmux
    polybar
    kitty
    wezterm
    picom
    pavucontrol
    blueberry
    xclip
    rofi
    dunst
    zathura
    flameshot
    nitrogen
    unzip
    ranger
    rsync
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin

    # waybar
    # eww
    # dunst
    # mako
    # rofi-wayland
    # wofi
    #
    # bemenu
    # fuzzel
    # tofi
    # hyprpaper
    # wpaperd
    # swww
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
