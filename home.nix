{ config, inputs, pkgs, ... }:

{

  imports = [ inputs.ags.homeManagerModules.default ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "bryley";
  home.homeDirectory = "/home/bryley";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [ ];

  programs.ags = {
    enable = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".config/hypr" = {
      source = ./configs/hypr;
      recursive = true;
    };
    ".config/nushell" = {
      source = ./configs/nushell;
      recursive = true;
    };
    ".config/nvim" = {
      source = ./configs/nvim;
      recursive = true;
    };
    ".config/zellij" = {
      source = ./configs/zellij;
      recursive = true;
    };
    ".config/kitty" = {
      source = ./configs/kitty;
      recursive = true;
    };

  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
