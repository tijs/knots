#!/usr/bin/env bash

set -e

# modules
source "$lib/symlink/index.sh"

# Run each program
sh "$osx/defaults.sh"
sh "$osx/binaries.sh"
sh "$osx/apps.sh"

# Symlink the profile
if [[ ! -e "$HOME/.bash_profile" ]]; then
  echo "symlinking: $osx/profile.sh => $HOME/.bash_profile"
  symlink "$osx/profile.sh" "$HOME/.bash_profile"
  source $HOME/.bash_profile
else
  echo "$HOME/.bash_profile already exists. remove and run again."
fi
