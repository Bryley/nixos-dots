# NixOS dots

This README is a work in progress

## Step 1: Setup network

[Networking](https://nixos.org/manual/nixos/stable/#sec-installation-manual-networking)

## Step 2: Partitioning and formatting

First find disk using `lsblk`. Might be `sda`, `vda` or something else.

```bash
sudo -i
parted /dev/{disk name} -- mklabel gpt
parted /dev/{disk name} -- mkpart root ext4 512MB -8GB
parted /dev/{disk name} -- mkpart swap linux-swap -8GB 100%
parted /dev/{disk name} -- mkpart ESP fat32 1MB 512MB
parted /dev/{disk name} -- set 3 esp on

mkfs.ext4 -L nixos /dev/{disk name}1
mkswap -L swap /dev/{disk name}2
mkfs.fat -F 32 -n boot /dev/{disk name}3
```

`lsblk` should now show 3 partitions, the first one being the file system, the
next being swap and the final being the boot partition

## Step 3: Installing

Still in root:

```bash
mount /dev/disk/by-label/nixos /mnt

mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

swapon /dev/disk/by-label/swap

nix-shell -p git
git clone https://github.com/Bryley/nixos-dots.git /mnt/nixos-dots

# Generate new host (TODO, write a script for it)
# nixos-generate-config --root /mnt --show-hardware-config > $HOSTDIR/hardware-configuration.nix

git add .
nixos-install --flake .#<host>
```

Now you can reboot your system and boot into your hard disk

## Step 4: Final touches

First thing todo when booting into your new system is to set a new password for
the user (in this case `bryley`):

```bash
passwd bryley
```

Then login to the account.
Finally move the folder to a better location and change the perms:

```bash
mv /nixos-dots ~
chown -R bryley:users ~/nixos-dots
```

Note there are probably some other small things you might want to setup, for
example setting up a rust toolchain to get cargo and more:

```bash
rustup default stable
```

## Notes when setting up

- If you are having trouble with the clipboard in brave or any issues in brave
  for that matter, try manually chainging the ozone settings to Wayland as it
  might think it is in X11. Go to chrome://flags, serach for `ozone` and change
  `Preferred Ozone platform` to Wayland.
