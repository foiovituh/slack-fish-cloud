#!/bin/bash
break_line() {
  printf '\n';
}

###############################################################################
# Arguments:
#   message
###############################################################################
alert() {
  printf '%s\n' "$1";
  exit;
}

show_banner() {
  figlet 'SlackFishCloud' -f 'big';
  printf '%s\n' '* Never forget to delete your daily AWS test resources';
  printf '%s\n\n' '* GH -> https://www.github.com/foiovituh/slack-fish-cloud';
}
