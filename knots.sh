#!/usr/bin/env bash
version="0.0.1"

# knots(1) main
main() {

  # paths
  export dirname=$(dirname $(realpath $0))
  export lib="$dirname/lib"
  export osx="$dirname/osx"

  # parse options
  while [[ "$1" =~ ^- ]]; do
    case $1 in
      -v | --version )
        echo $version
        exit
        ;;
      -h | --help )
        usage
        exit
        ;;
    esac
    shift
  done

  # run command
  case $1 in
    reload )
      source "$HOME/.bash_profile"
      ;;
    boot )
      boot $2
      exit
      ;;
    update )
      update $2
      exit
      ;;
    *)
      usage
      exit
      ;;
  esac
}

# usage info
usage() {
  cat <<EOF

  Usage: knots [options] [command] [args ...]

  Options:

    -v, --version           Get the version
    -h, --help              This message

  Commands:

    reload                  Reload the dotfiles
    boot                    Bootstrap osx
    update <os|knots>       Update the os or knots

EOF
}

# Bootstrap the OS
boot() {
  if [[ -e "$osx/index.sh" ]]; then
    sh "$osx/index.sh"
  else
    echo "boot: could not find directory"
    exit 1
  fi
}

# update either knots or OS
update() {
  case $1 in
      osx )
        sh "$osx/update.sh"
        exit
        ;;
      knots )
        updateknots
        exit
        ;;
    esac
}

# update knots(1) via git clone
updateknots() {
  echo "updating knots..."
  mkdir -p /tmp/knots \
    && cd /tmp/knots \
    && curl -L# https://github.com/tijs/knots/archive/master.tar.gz | tar zx --strip 1 \
    && ./install.sh \
    && echo "updated knots to $(knots --version)."
  exit
}

# "readlink -f" shim for mac os x
realpath() {
  target=$1
  cd `dirname $target`
  target=`basename $target`

  # Iterate down a (possible) chain of symlinks
  while [ -L "$target" ]
  do
      target=`readlink $target`
      cd `dirname $target`
      target=`basename $target`
  done

  dir=`pwd -P`
  echo $dir/$target
}

# Call main
main "$@"