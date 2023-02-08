#!/bin/bash
break_line() {
  echo;
}

###############################################################################
# Arguments:
#   message
###############################################################################
alert() {
  echo -e "${1}";
  exit;
}

show_banner() {
  figlet "SlackFishCloud" -f "big";
  echo "* Never forget to delete your daily AWS test resources";
  echo -e "* GitHub: https://www.github.com/foiovituh/SlackFishCloud\n";
}

