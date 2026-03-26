#!/bin/bash

nixos-rebuild --flake .#jvyden-thinkpad --target-host jvyden@jvyden-thinkpad.local -L --sudo --ask-sudo-password switch
