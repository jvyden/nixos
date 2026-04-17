#!/usr/bin/env bash

nixos-rebuild --flake .#red-nugget --target-host jvyden@10.1.0.129 -L --sudo --ask-sudo-password switch
