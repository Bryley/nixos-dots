# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, ... }:

let user = "bryley"; in {

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };
  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Nix Dynamic Linker used for somethings like Neovim Mason
  programs.nix-ld.enable = true;

  # Add User
  users.users.${user} = {
    isNormalUser = true;
    description = "Bryley Hayter";
    extraGroups = ["wheel" "networkmanager" "syncthing"];
    shell = pkgs.nushell;
  };

  # Config files
  system.activationScripts.symlinks = let
    dots = "/home/${user}/nixos-dots/configs";
    homeDir = "/home/${user}";
    config = "${homeDir}/.config";
  in {
    text = ''
      if [ -d "${homeDir}" ]; then
        mkdir -p ${config}

        rm -r ${config}/nushell
        ln -sfn ${dots}/nushell ${config}/nushell
        ln -sfn ${dots}/nvim ${config}/nvim
        ln -sfn ${dots}/zellij ${config}/zellij
        ln -sfn ${dots}/hypr ${config}/hypr
        ln -sfn ${dots}/kitty ${config}/kitty
        ln -sfn ${dots}/eww ${config}/eww

        chown -R ${user}:users ${config}
      fi
    '';
  };

  # Sync files across multiple computers http://127.0.0.1:8384/
  services.syncthing = {
    enable = true;
    inherit user;
    dataDir = "/home/${user}/Documents/vault";
    configDir = "/home/${user}/.config/syncthing";
  };

  # Global Packages
  environment.systemPackages = with pkgs; [
    gcc       # C Compiler (used by lots of software)
    unzip     # unzipping software
    wget      # curl alternative
    nodejs_21 # For npm
    rustup    # Everything for Rust (cargo, rustc)
    neovim    # IDE
    ripgrep   # Super fast searching in files
    fd        # Better `find` command
    pavucontrol # Audio control

    nushell   # Modern shell
    zellij    # Modern Terminal Multiplexer
    kitty     # Terminal Emulator
    eww-wayland # EIKowars Wacky Widgets

    wl-clipboard # Clipboard manager for Wayland
    lxqt.lxqt-policykit # Polkit Authentication Agent

    firefox   # Web Browser
    cargo-leptos # Leptos Tools
    flyctl    # Fly.io ctl command
    obsidian  # Note taker

  ];

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" ]; })
  ];

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

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}

