{

  # TODO NTS: Working on trying to get symlinks to work, pretty close, just need
  #  to get the flake directory in this code

  # TODO:
  # - [X] Nushell
  #   - [ ] Better completions
  #   - [X] Setup neovim to use NIX_LD env var using alias probably
  # - [X] Zelidji or whatever the tmux alternative is
  # - [-] Neovim fullscreen command mode
  # - [X] Symlinks to .config
  # - [ ] Hyprland
  # - [ ] Bar for Hyprland
  # - [ ] Setup script for new system

  description = "Bryley's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, hyprland }: {
    nixosConfigurations = let
      lib = nixpkgs.lib;
      nixSystemSetup = name: arch: nixpkgs.lib.nixosSystem rec{
        system = arch;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [
          ({ ... }: {
            networking.hostName = name;
          })
          hyprland.nixosModules.default
          ./configuration.nix
          ./hardware-confs/${name}.nix
        ];
      };
    in {
      virt = nixSystemSetup "virt" "aarch64-linux";
      virt2 = nixSystemSetup "virt2" "x86_64-linux";
      # virt = lib.nixosSystem rec {
      #   system = "aarch64-linux";
      #   pkgs = import nixpkgs {
      #     inherit system;
      #     config.allowUnfree = true;
      #   };
      #   modules = [
      #     hyprland.nixosModules.default
      #     ./configuration.nix
      #     ./hardware-confs/virt.nix
      #   ];
      # };
      # virt2 = lib.nixosSystem rec {
      #   system = "x86_64-linux";
      #   pkgs = import nixpkgs {
      #     inherit system;
      #     config.allowUnfree = true;
      #   };
      #   modules = [
      #     hyprland.nixosModules.default
      #     ./configuration.nix
      #     ./hardware-confs/virt2.nix
      #   ];
      # };
    };
  };
}
