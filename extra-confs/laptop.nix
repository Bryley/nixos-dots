{ pkgs, ... }:

{
  boot.kernelModules = [ "iwlwifi" ];
  boot.kernelParams = [ "iwlwifi.11n_disable=1" "iwlwifi.swcrypto=1" ];
  # boot.kernelParams = [ "iwlwifi.11n_disable=1" "iwlwifi.power_save=0" "iwlwifi.swcrypto=1" ];

  # hardware.enableRedistributableFirmware = true;
}
