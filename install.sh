#!/usr/bin/env bash

error() {
  echo "$1 not found" >&2
  exit 1
}

download() {
  [ "$1" = "" ] && error "download 'url'"
  [ "$2" = "" ] && error "download 'output'"
  local url=$1
  local output=$2
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

symlink() {
  local source=$1
  local dest=$2
  if [ -L $dest ]; then
    local target=`readlink $dest`
    if [ "$target" != "$source" ]; then
      rm $dest
      ln -s $source $dest
      echo changed replace incorrect symlink $dest
    fi
  elif [ -f $dest ]; then
    error symlink failed $dest exists but is a regular file
  else
    ln -s $source $dest
    echo changed created symlink $dest
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

curl -o- https://fnm.vercel.app/install | bash -s -- --install-dir ~/.local/bin --skip-shell
fnm install --lts
symlink ~/.local/share/fnm/aliases/default/bin/node ~/.local/bin/node
symlink ~/.local/share/fnm/aliases/default/bin/npm ~/.local/bin/npm
