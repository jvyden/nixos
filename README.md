# jvyden's NixOS configuration
This is my [flake](https://wiki.nixos.org/wiki/Flakes)-based [NixOS](https://nixos.org/) configuration.
I use it for most of my machines that run Linux, including servers, laptops, and my primary desktop machine.

I like flakes because they make importing easy and allow me to pin to a given version of nixpkgs or other repositories, and easily allow me to roll back if something goes wrong.

## What am I looking at?

- `modules/`: Self-contained composable modules allowing me to design generally how I want a computer to run from a high-level.
  - `hardware/`: Support and integration for certain pieces of hardware, e.g. NVIDIA graphics cards, batteries, and fingerpint readers.
  - `workloads/`: Sets up the machine for a task I want to perform. For example, gaming, VR, or development.
  - `desktop/`: Common modules for desktop use.
  - `common.nix`: Common setup for every machine I use.
- `machines/`: NixOS configurations for every machine I've used NixOS on, built using a combination of the above modules.
  - `jvyden-pi5`: My current home server, running from a Raspberry Pi 5.
  - `jvyden-thinkpad`: A Thinkpad T440P. Primary laptop.
  - `red-nugget`: A very red HP laptop that dualboots NixOS with Windows 8.1. If you saw it, you'd know why.
  - `srv.jvyden.xyz`: My VPS. Not deployed yet.
  - **`the-overcooler`**: My main machine. This is where I do just about everything.
- `assets/`: Images and stuffs.
- `pkgs/`: Custom (mostly from-binary) packages I've written for random pieces of software. I plan to fix these up and contribute them to `nixpkgs` at some point.
- `home/jvyden/`: My custom home-manager configuration. Defines things like KDE panels and other software configurations.

## Could I use this for my own machine?

No. At least, it would be difficult to. My configurations likely won't even build on your machine OOTB; I have a private `secrets` submodule that cannot be accessed outside of my home network.
This is intentional for security reasons and won't change. Yes, agenix encrypts these secrets, but I don't think that means it's a good idea to publish them.

Even so, I do a lot of weird things on my computers that probably don't make sense for you.
I encourage you to write your own configurations.

## Could I simply reference it instead?

Absolutely! Use it as reference! This code is licensed under the [WTFPL](https://github.com/jvyden/nixos/blob/master/LICENSE), literally meaning you can do WTF you want to.

You can credit me if you want to, or don't.

Just note that while I've been at sysadmin-ing and Linux for years and years and years, I'm relatively new to NixOS.
