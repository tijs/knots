#
# Application installer (via brew-cask)
#

set -e

# Apps
apps=(
  alfred
  dropbox
  flux
  google-chrome
  google-drive
  google-plus-auto-backup
  google-hangouts
  libreoffice
  multibit
  pycharm
  sublime-text
  slack
  spotify
  skype
  steam
  transmission
  transmit
  vagrant
  virtualbox
  vlc
  xquartz
)

main() {

  # Ensure homebrew is installed
  homebrew

  # Install homebrew-cask
  echo "installing cask..."
  brew tap caskroom/homebrew-cask
  brew install brew-cask

  # Tap alternative versions
  brew tap caskroom/versions

  # install apps
  echo "installing apps..."
  brew cask install ${apps[@]}

  # link with alfred
  alfred
  cleanup
}

homebrew() {
  if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}

alfred() {
  brew cask alfred link
}

cleanup() {
  brew cleanup
}

main "$@"
exit 0
