{ inputs, config, lib, pkgs, user, ... }:

{
  imports = [
    ./software.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Brisbane";

  # Automatically garbage collect after a week
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  # Automatic system upgrades
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
    dates = "09:00";
    randomizedDelaySec = "45min";
  };

  # Australian Locale
  i18n.defaultLocale = "en_AU.UTF-8";

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
  # Disable the firewall for quickly opening and setting servers
  networking.firewall.enable = false;

  users.users.${user} = {
    isNormalUser = true;
    description = "Bryley Hayter";
    extraGroups = ["wheel" "networkmanager" "syncthing" "docker"];
    shell = pkgs.nushell;
  };

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" "Ubuntu" "CascadiaCode"  ]; })
  ];

  services.openssh.enable = true;

  # Important, don't change
  system.stateVersion = "23.11"; # Did you read the comment?
}

