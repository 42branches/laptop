#!/bin/sh

# Setup

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

if [ ! -d "$HOME/.bin/" ]; then
  mkdir "$HOME/.bin"
fi

if [ ! -f "$HOME/.zshrc" ]; then
  touch "$HOME/.zshrc"
fi

append_to_zshrc 'export PATH="$HOME/.bin:$PATH"'

if [ -d "/usr/local" ]; then
  if ! sudo -u "$(whoami)" [ -r /usr/local ]; then
    sudo chown -R "$(whoami)":admin /usr/local
  fi
else
  mkdir /usr/local
  sudo chflags norestricted /usr/local
  sudo chown -R "$(whoami)":admin /usr/local
fi

case "$SHELL" in
  */zsh) : ;;
  *)
    fancy_echo "Changing your shell to zsh ..."
      chsh -s "$(which zsh)"
    ;;
esac
