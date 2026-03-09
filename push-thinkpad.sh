#!/bin/bash

nixos-rebuild --flake .#jvyden-thinkpad --target-host jvyden@jvyden-thinkpad.local --build-host jvyden@jvyden-thinkpad.local --sudo --ask-sudo-password switch
