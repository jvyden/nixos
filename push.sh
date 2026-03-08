#!/bin/bash

nixos-rebuild-ng --flake .#jvyden-pi5 --target-host jvyden@jvyden-pi5.local --sudo --ask-sudo-password switch
