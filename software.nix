
{ config, lib, pkgs, inputs, system, user, ... }:

let
  requiredSoftware = with pkgs; [
    # System Essential Terminal Applications #
    nh        # NixOS helper commands
    pkg-config # Finds packages
    gcc       # C Compiler (used by lots of software)
    zip       # zipping software
    unzip     # unzipping software
    openssl   # TLS Security stuff
    openssl.dev # Dev Openssl
    xdg-utils # XDG utils for setting and managing default applications
    wget      # curl alternative
    nodePackages_latest.nodejs # Javascript runtime and npm
    # rustup    # Everything for Rust (cargo, rustc)
    ripgrep   # Super fast searching in files
    fd        # Better `find` command
    fzf       # Fuzzy finder
    usbutils  # USB Utils, commands like `lsusb`
    bun       # Modern Javascript runtime and needed for AGS
    sass      # Sass cli tool to convert scss files to css (for use with AGS)
    home-manager # For handling dotfiles on NixOS
    just      # Replacement for Make
    fastfetch # Neofetch alternative
    (python310.withPackages(ps: with ps; [ rich virtualenv pyyaml ])) # Python 3.10
    pkg-config # Finds packages
    openssl   # Used as a dep for a lot of projects
    (python310.withPackages(ps: with ps; [ rich virtualenv pyyaml ])) # Python 3.10
    ollama    # LLMs
    elmPackages.elm # ELM programming language
    bat       # Better cat
    hurl      # CLI tool and file format for API testing
    jq        # JSON parser CLI tool
    nodePackages.prettier # Javascript formatter (required for neovim)
    nvidia-container-toolkit # Let nvidia work with docker containers

    # Essential Full Terminal Applications #
    neovim    # IDE
    nushell   # Modern shell
    zellij    # Modern Terminal Multiplexer
    distrobox # Create containers easier

    # System Essential GUI Applications #
    wl-clipboard # Clipboard manager for Wayland
    spacedrive  # Cool file explorer
    kitty     # Terminal Emulator
    eww-wayland # EIKowars Wacky Widgets (Used for status bar)
    swww      # Wallpaper daemon
    wofi      # App launcher
    lxqt.lxqt-policykit # Polkit Authentication Agent
    firefox   # Web Browser
    inputs.zen-browser.packages."${system}".specific
    google-chrome # Chrome browser for webdev testing
    libreoffice # Office Suite
    xournalpp # PDF editor
    evince    # PDF viewer
    ollama    # AI LLM tool
    ngrok     # Quick servers
    postman   # Curl GUI
    dbeaver-bin # Database GUI

    # TODO NTS: Make sure to get this cursor set working
    # apple-cursor # Cursor theme set apple inspired
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
        pull.rebase = "false";
      };
    };

    environment.variables = {
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    };

    virtualisation.docker = {
      enable = true;
      enableNvidia = true;
    };

    # Needed for the battery service used in ASG
    services.upower.enable = true;

    environment.variables = {
      # PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      OPENSSL_DEV=pkgs.openssl.dev;
    };

    # Nix Dynamic Linker used for somethings like Neovim Mason
    programs.nix-ld.enable = true;
    # environment.variables = {
    #   NIX_LD = "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
    # };

    programs.hyprland = {
      enable = true;
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
