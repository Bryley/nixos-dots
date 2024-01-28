
{ config, lib, pkgs, inputs, user, ... }:

let
  requiredSoftware = with pkgs; [
    # System Essential Terminal Applications #
    gcc       # C Compiler (used by lots of software)
    unzip     # unzipping software
    wget      # curl alternative
    nodejs_21 # Javascript runtime & npm
    rustup    # Everything for Rust (cargo, rustc)
    ripgrep   # Super fast searching in files
    fd        # Better `find` command
    fzf       # Fuzzy finder
    (python310.withPackages(ps: with ps; [ rich virtualenv pyyaml ])) # Python 3.10

    # Essential Full Terminal Applications #
    neovim    # IDE
    nushell   # Modern shell
    zellij    # Modern Terminal Multiplexer

    # System Essential GUI Applications #
    wl-clipboard # Clipboard manager for Wayland
    kitty     # Terminal Emulator
    eww-wayland # EIKowars Wacky Widgets (Used for status bar)
    swww      # Wallpaper daemon
    wofi      # App launcher
    lxqt.lxqt-policykit # Polkit Authentication Agent
    firefox   # Web Browser
  ];
  addons = with pkgs; [
    pavucontrol # Audio control
    obsidian  # Note taker
    cargo-leptos # Leptos Tools
    flyctl    # Fly.io ctl command
    cinnamon.nemo-with-extensions # File explorer
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
      };
    };

    # Nix Dynamic Linker used for somethings like Neovim Mason
    programs.nix-ld.enable = true;

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