#!/bin/bash

nixos-rebuild switch --flake .#jvyden-pi5 --target-host jvyden@10.0.0.228 --sudo --ask-sudo-password
