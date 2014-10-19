## Export PATH
export PATH=/usr/local/bin:$HOME/bin:/usr/local/sbin:$PATH

## Put brew's ruby in front
export PATH=/usr/local/opt/ruby/bin:$PATH

## Use gnu tools instead
export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH

## Modify NODE_PATH
export NODE_PATH=lib

# Set the Android Home
# use: brew install android-sdk
# export ANDROID_HOME=/usr/local/opt/android-sdk

# Use sublime for Ctrl+x+e
# EDITOR="subl -w"

# Default cd path for interactive shells
if test “${PS1+set}”; then
  CDPATH=:"..:~:~/Projects";
fi

# Add bash completion (for git and others)
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

git_branch() {
  # On branches, this will return the branch name
  # On non-branches, (no branch)
  ref="$(git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///')"
  if [[ "$ref" != "" ]]; then
    echo "$ref "
  fi
}

git_progress() {
  # Detect in-progress actions (e.g. merge, rebase)
  # https://github.com/git/git/blob/v1.9-rc2/wt-status.c#L1199-L1241
  git_dir="$(git rev-parse --git-dir)"

  # git merge
  if [[ -f "$git_dir/MERGE_HEAD" ]]; then
    echo "merge "
  elif [[ -d "$git_dir/rebase-apply" ]]; then
    # git am
    if [[ -f "$git_dir/rebase-apply/applying" ]]; then
      echo "am "
    # git rebase
    else
      echo "rebase "
    fi
  elif [[ -d "$git_dir/rebase-merge" ]]; then
    # git rebase --interactive/--merge
    echo "rebase "
  elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
    # git cherry-pick
    echo "cherry-pick "
  fi
  if [[ -f "$git_dir/BISECT_LOG" ]]; then
    # git bisect
    echo "bisect "
  fi
  if [[ -f "$git_dir/REVERT_HEAD" ]]; then
    # git revert --no-commit
    echo "revert "
  fi
}

# colors
color_bold="\[$(tput bold)\]"
color_reset="\[$(tput sgr0)\]"
color_red="\[$(tput setaf 1)\]"
color_green="\[$(tput setaf 2)\]"
color_yellow="\[$(tput setaf 3)\]"
color_blue="\[$(tput setaf 4)\]"
color_purple="\[$(tput setaf 5)\]"
color_teal="\[$(tput setaf 6)\]"
color_white="\[$(tput setaf 7)\]"
color_black="\[$(tput setaf 8)\]"

# Add git to the terminal prompt
git_prompt() {
  # Don't go any further if we're not in a git repo
  git rev-parse --is-inside-work-tree &> /dev/null || return

  # Stylize
  echo -n $color_red
  echo -n "$(git_branch)"
  echo -n $color_reset
  echo -n $color_purple
  echo -n "$(git_progress)"
  echo -n $color_reset
}

## Customize the terminal input line
prompt() {
  PS1="  ☁  $color_blue\W$color_reset $(git_prompt): "
}

PROMPT_COMMAND=prompt

###########
# Aliases #
###########

## Color ls
alias ls='ls --color=auto -hF'

# Update the number of open files
ulimit -n 1000
