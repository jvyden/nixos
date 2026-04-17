#!/usr/bin/env bash

nixos-rebuild --flake .#jvyden-pi5 --target-host jvyden@jvyden-pi5.local --build-host jvyden@jvyden-pi5.local --sudo --ask-sudo-password switch
