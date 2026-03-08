#!/bin/bash

nixos-rebuild switch --flake .#jvyden-pi5 --target-host jvyden@jvyden-pi5.local --sudo --ask-sudo-password
