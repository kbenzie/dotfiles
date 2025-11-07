#!/usr/bin/env bash

error() {
  echo "$1 not found" >&2
  exit 1
}

download() {
  local url=$1
  local output=$2
  # TODO: validate args
  if command -v curl &> /dev/null; then
    curl -o $output --location $url
  elif command -v wget &> /dev/null; then
    wget -O $output $url
  else
    error "curl/wget not found"
  fi
}

# TODO: validate platform & arch work on all supported platforms
platform=$(uname | tr '[:upper:]' '[:lower:]')
arch=$(uname -m)
# TODO: use version agnostic download link
download https://github.com/kbenzie/tuck/releases/download/v0.2.1/tuck-v0.2.1-$platform-$arch.tar.gz ./tuck.tar.gz
tar zxvf ./tuck.tar.gz tuck
mv ./tuck ~/.local/bin/tuck
rm ./tuck.tar.gz

tuck in neovim/neovim
tuck in BurntSushi/ripgrep
tuck in junegunn/fzf
tuck in sharkdp/bat

download https://git.infektor.net/config/local/raw/branch/main/roles/bash/templates/bashrc ~/.bashrc
download https://git.infektor.net/config/local/raw/branch/main/roles/readline/templates/inputrc ~/.inputrc

if ! command -v git &> /dev/null; then
  error "git not found"
fi

git-clone-or-pull() {
  local repo=$1
  local dir=$2
  if [ -d $dir ]; then
    git -C $dir pull
  else
    git clone $repo $dir
  fi
}

git-clone-or-pull https://git.infektor.net/config/nvim.git ~/.config/nvim

git-clone-or-pull https://git.infektor.net/config/zsh.git ~/.config/zsh
zsh ~/.config/zsh/install.zsh

git-clone-or-pull https://git.infektor.net/config/tmux.git ~/.config/tmux
~/.config/tmux/install.sh

mkdir -p ~/.local/bin
mkdir -p ~/.local/share/man/man1
mkdir -p ~/.local/share/zsh/site-functions
