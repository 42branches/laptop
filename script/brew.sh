#!/bin/sh
source 'script/functions.sh'

# Brew

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

    append_to_zshrc '# recommended by brew doctor'

    # shellcheck disable=SC2016
    append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1

    export PATH="/usr/local/bin:$PATH"
fi

if brew list | grep -Fq brew-cask; then
  fancy_echo "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

fancy_echo "Updating Homebrew formulae ..."
brew tap 'homebrew/bundle'
brew update

fancy_echo "Adding Brew Taps ..."
brew bundle -v --file=brew/Tapfile

fancy_echo "Installing Homebrew Packages ..."
brew bundle -v --file=brew/Brewfile
brew unlink openssl && brew link openssl --force

fancy_echo "Installing Casks ..."
brew bundle -v --file=brew/Caskfile

fancy_echo "Cleaning up old Homebrew formulae ..."
brew cleanup
brew cask cleanup
