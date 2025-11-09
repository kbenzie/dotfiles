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

git-clone-or-pull() {
  local repo=$1
  local dir=$2
  if [ -d $dir ]; then
    git -C $dir pull
  else
    git clone $repo $dir
  fi
}

curl -sfL https://kbenzie.github.io/tuck/get.sh | sh
export PATH=$HOME/.local/bin:$PATH

tuck in neovim/neovim
tuck in BurntSushi/ripgrep
tuck in junegunn/fzf
tuck in sharkdp/bat

download https://git.infektor.net/config/local/raw/branch/main/roles/bash/templates/bashrc ~/.bashrc
download https://git.infektor.net/config/local/raw/branch/main/roles/readline/templates/inputrc ~/.inputrc

git-clone-or-pull https://git.infektor.net/config/nvim.git ~/.config/nvim

git-clone-or-pull https://git.infektor.net/config/zsh.git ~/.config/zsh
zsh ~/.config/zsh/install.zsh

git-clone-or-pull https://git.infektor.net/config/tmux.git ~/.config/tmux
~/.config/tmux/install.sh
