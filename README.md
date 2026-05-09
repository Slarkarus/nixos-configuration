# NIXOS-CONFIGURATION by slarkarus

## Installation

Install NixOS first using [desktop](https://nixos.org/download#nixos-iso)

### Cloning repo

```bash
mkdir ~/nixos
sudo mv /etc/nixos/* ~/nixos/
sudo chown -R $(id -un) ~/nixos
sudo rmdir /etc/nixos
sudo ln -s ~/nixos /etc/
```

### First build

```bash
sudo nixos-rebuild switch --flake .#<desired hostname>
```