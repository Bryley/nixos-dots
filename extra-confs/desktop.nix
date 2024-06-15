{ config, pkgs, ... }:

{
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # For the wifi card
  # boot.extraModulePackages = [ pkgs.linuxPackages_latest.rtl88x2bu ];  # Add the rtl88x2bu driver
  # boot.kernelPackages = pkgs.linuxPackages_latest;  # Use the latest kernel packages
  boot.extraModulePackages = with config.boot.kernelPackages; [ rtl88x2bu ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true;

    forceFullCompositionPipeline = true;

    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    nvidiaSettings = true;
  };
}
