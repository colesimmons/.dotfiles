#!/usr/bin/env bash

###########################
# This script installs the dotfiles and runs all other system configuration scripts
###########################

# include my library helpers for colorized echo and require_brew, etc
source ./helpers/echos.sh
source ./helpers/requirers.sh

# ###########################################################
# /etc/hosts -- spyware/ad blocking
# ###########################################################
bot "Overwriting /etc/hosts with the ad-blocking hosts file from someonewhocares.org"
action "cp /etc/hosts /etc/hosts.backup"
sudo cp /etc/hosts /etc/hosts.backup
ok
action "cp ./configs/hosts /etc/hosts"
sudo cp ./hosts /etc/hosts
ok
bot "Your /etc/hosts file has been updated. Last version is saved in /etc/hosts.backup"

# ###########################################################
# Install non-brew various tools (PRE-BREW Installs)
# Note: this will probably already be done to be able to git pull the repo
# ###########################################################
bot "ensuring build/install tools are available"
if ! xcode-select --print-path &> /dev/null; then

    # Prompt user to install the XCode Command Line Tools
    xcode-select --install &> /dev/null

    # Wait until the XCode Command Line Tools are installed
    until xcode-select --print-path &> /dev/null; do
        sleep 5
    done

    print_result $? ' XCode Command Line Tools Installed'

    # Prompt user to agree to the terms of the Xcode license
    # https://github.com/alrra/dotfiles/issues/10
    sudo xcodebuild -license
    print_result $? 'Agree with the XCode Command Line Tools licence'

fi

# ###########################################################
# install homebrew (CLI Packages)
# ###########################################################
running "checking homebrew..."
brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  action "installing homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  if [[ $? != 0 ]]; then
    error "unable to install homebrew, script $0 abort!"
    exit 2
  fi
  echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.zshrc
  brew analytics off
else
  ok
  bot "Homebrew"
  read -r -p "run brew update && upgrade? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]]; then
    action "updating homebrew..."
    brew update
    ok "homebrew updated"
    action "upgrading brew packages..."
    brew upgrade
    ok "brews upgraded"
  else
    ok "skipped brew package upgrades."
  fi
fi

# Just to avoid a potential bug
mkdir -p ~/Library/Caches/Homebrew/Formula
brew doctor

# Require Git and Fish
require_brew git
require_brew fish

# Require/update Ruby
RUBY_CONFIGURE_OPTS="--with-openssl-dir=`brew --prefix openssl` --with-readline-dir=`brew --prefix readline` --with-libyaml-dir=`brew --prefix libyaml`"
require_brew ruby

# Set fish as the user login shell
CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
if [[ "$CURRENTSHELL" != "/opt/homebrew/bin/fish" ]]; then
  bot "setting fish (/opt/homebrew/bin/fish) as your shell (password required)"
  sudo dscl . -change /Users/$USER UserShell $SHELL /opt/homebrew/bin/fish > /dev/null 2>&1
  ok
fi
oh-my-fish bin/install --offline
omf install boxfish

bot "Dotfiles Setup"
bot "creating symlinks for project dotfiles..."
pushd dotfiles > /dev/null 2>&1
now=$(date +"%Y.%m.%d.%H.%M.%S")

for file in .*; do
  if [[ $file == "." || $file == ".." ]]; then
    continue
  fi
  running "~/$file"
  # if the file exists:
  if [[ -e ~/$file ]]; then
      mkdir -p ~/.dotfiles_backup/$now
      mv ~/$file ~/.dotfiles_backup/$now/$file
      echo "backup saved as ~/.dotfiles_backup/$now/$file"
  fi
  # symlink might still exist
  unlink ~/$file > /dev/null 2>&1
  # create the link
  ln -s ~/.dotfiles/dotfiles/$file ~/$file
  echo -en '\tlinked';ok
done

bot "VIM Setup"
bot "Installing vim plugins"
# cmake is required to compile vim bundle YouCompleteMe
# require_brew cmake
vim +PluginInstall +qall
ok


bot "installing fonts"
# need fontconfig to install/build fonts
require_brew fontconfig
./fonts/install.sh
ok

# node version manager
require_brew nvm

# nvm
require_nvm stable
