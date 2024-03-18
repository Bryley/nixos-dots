#!/usr/bin/env bash

# This is a bash script from the Youtuber No Boilerplate for rebuilding his NixOS
# system. It has been modified to work better with my particular config and to
# my own liking

set -e

# cd to your config dir
pushd ~/nixos-dots/

# # Early return if no changes were detected (thanks @singiamtel!)
# if git diff --quiet *.nix; then
#     echo "No changes detected, exiting."
#     popd
#     exit 0
# fi

# Shows your changes
git diff -U0 *.nix

# Stage everything (required for flakes to work correctly)
git add .

echo "NixOS rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild switch --flake . &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)
home-manager switch --flake . &>home-manager-switch.log || (cat home-manager-switch.log | grep --color error && false)

# Get current generation metadata
current=$(sudo nix-env --list-generations -p /nix/var/nix/profiles/system | grep current | awk '{print "Generation", $1}')

# Commit all changes witih the generation metadata
git commit -am "$current"

# Back to where you were
popd

# Notify all OK!
# TODO enable once notify-send is available on my system
# notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
echo "NixOS finished rebuilding"
