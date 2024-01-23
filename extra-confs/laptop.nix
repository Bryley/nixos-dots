{ pkgs, ... }:

{
  boot.kernelModules = [ "iwlwifi" ];
  boot.kernelParams = [ "iwlwifi.11n_disable=1" "iwlwifi.swcrypto=1" ];
}
