
{ config, lib, pkgs, inputs, user, ... }:

let
  requiredSoftware = with pkgs; [
    # System Essential Terminal Applications #
    nh        # NixOS helper commands
    gcc       # C Compiler (used by lots of software)
    unzip     # unzipping software
    wget      # curl alternative
    nodejs_21 # Javascript runtime & npm
    rustup    # Everything for Rust (cargo, rustc)
    ripgrep   # Super fast searching in files
    fd        # Better `find` command
    fzf       # Fuzzy finder
    usbutils  # USB Utils, commands like `lsusb`
    bun       # Modern Javascript runtime and needed for AGS
    sass      # Sass cli tool to convert scss files to css (for use with AGS)
    home-manager # For handling dotfiles on NixOS
    just      # Replacement for Make
    (python310.withPackages(ps: with ps; [ rich virtualenv pyyaml ])) # Python 3.10

    # Essential Full Terminal Applications #
    neovim    # IDE
    nushell   # Modern shell
    zellij    # Modern Terminal Multiplexer

    # System Essential GUI Applications #
    wl-clipboard # Clipboard manager for Wayland
    # TODO NTS: Make sure to get this cursor set working
    # apple-cursor # Cursor theme set apple inspired
    kitty     # Terminal Emulator
    eww-wayland # EIKowars Wacky Widgets (Used for status bar)
    swww      # Wallpaper daemon
    wofi      # App launcher
    lxqt.lxqt-policykit # Polkit Authentication Agent
    firefox   # Web Browser
    google-chrome # Chrome browser for webdev testing
    libreoffice # Office Suite
    xournalpp # PDF editor
  ];
  addons = with pkgs; [
    pavucontrol # Audio control
    obsidian  # Note taker
    cargo-leptos # Leptos Tools
    flyctl    # Fly.io ctl command
    cinnamon.nemo-with-extensions # File explorer
    android-studio # Android SDK and IDE for Android Phone development
  ];
  in {
    # Required Software #
    environment.systemPackages = requiredSoftware ++ addons;

    programs.git = {
      enable = true;
      config = {
        init = {
          defaultBranch = "main";
        };
        user = {  
          email = "bryleyhayter@gmail.com";
          name = "Bryley Hayter";
        };
        pull.rebase = "false";
      };
    };

    virtualisation.docker.enable = true;

    # Needed for the battery service used in ASG
    services.upower.enable = true;

    # Nix Dynamic Linker used for somethings like Neovim Mason
    programs.nix-ld.enable = true;
    # environment.variables = {
    #   NIX_LD = "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
    # };

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    # Optional software groups #

    # Personal
    programs.steam.enable = true;

    # Sync files across multiple computers http://127.0.0.1:8384/
    services.syncthing = {
      enable = true;
      inherit user;
      dataDir = "/home/${user}/Documents/vault";
      configDir = "/home/${user}/.config/syncthing";
    };
  }
