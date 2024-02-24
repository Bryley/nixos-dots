{

  # TODO:
  # - [X] Nushell
  #   - [ ] Better completions
  #   - [X] Setup neovim to use NIX_LD env var using alias probably
  # - [X] Zelidji or whatever the tmux alternative is
  # - [-] Neovim fullscreen command mode
  # - [X] Symlinks to .config
  # - [X] Hyprland
  #     - [X] Clipboard support
  #     - [X] Polkit
  #     - [ ] Wallpaper
  # - [ ] Bar for Hyprland
  # - [ ] Plymouth
  # - [ ] Setup script for new system
  # - [X] kitty config

  description = "Bryley's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs: {
    homeConfigurations."bryley" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      extraSpecialArgs = { inherit inputs; };
      modules = [ ./home.nix ];
    };
    nixosConfigurations = let
      lib = nixpkgs.lib;
      conditionalImport = path:
        if builtins.pathExists path then
          import path
        else
          {};
      nixSystemSetup = name: arch: lib.nixosSystem rec{
        system = arch;
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              # This is required for obsidian to work until they update electron
              "electron-25.9.0"
            ];
          };
        };
        specialArgs = { user = "bryley"; inherit inputs; };
        modules = [
          ./hardware-confs/${name}.nix
          ({ ... }: {
            networking.hostName = name;
            imports = [
              (conditionalImport ./extra-confs/${name}.nix)
            ];
          })
          ./configuration.nix
        ];
      };
    in {
      virt = nixSystemSetup "virt" "aarch64-linux";
      virt2 = nixSystemSetup "virt2" "x86_64-linux";
      laptop = nixSystemSetup "laptop" "x86_64-linux";
    };
  };
}
