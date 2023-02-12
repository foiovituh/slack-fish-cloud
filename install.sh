#!/bin/bash
readonly EXECUTION_PATH="$(dirname "$0")";

source "${EXECUTION_PATH}/sh/utils.sh";

declare -a DEPENDENCIES="$(cat "${EXECUTION_PATH}/dependencies.txt")";

for dependencie in ${DEPENDENCIES[@]}; do
  if [[ ! -x "$(command -v "$dependencie")" ]]; then
    printf "%s\n" "-> Installing ${dependencie}...";
    if [[ "$dependencie" == "aws" ]]; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
          -o "${EXECUTION_PATH}/awscliv2.zip";
        unzip "${EXECUTION_PATH}/awscliv2.zip";
        sudo "./aws/install";
        sudo rm -rf "${EXECUTION_PATH}/awscliv2.zip" "./aws";
        printf "\n%s\n" "-> For more information about CLI, see:";
        printf "%s\n" "$(cat "${EXECUTION_PATH}/links/aws_cli_setup.txt")";

        continue;
    fi

    sudo apt install "$dependencie";
    break_line;
  fi
done

printf "%s\n" "-> Copying figlet fonts to \"/usr/share/figlet/\"...";
sudo cp "${EXECUTION_PATH}/fonts/figlet/big.flf" "/usr/share/figlet/";
break_line;

read -p "-> CLI profile name: " AWS_PROFILE;
read -p "-> Slack webhook url for your workspace: " WEB_HOOK_URL;

###############################################################################
# Arguments:
#   constant name
#   new content to insert in constant
# Globals:
#  EXECUTION_PATH
###############################################################################
set_credential_constants() {
  sed -e "s,${1}=\"\",${1}=\"${2}\"," -i "${EXECUTION_PATH}/sh/credentials.sh";
}

set_credential_constants "AWS_PROFILE" "${AWS_PROFILE}";
set_credential_constants "WEB_HOOK_URL" "${WEB_HOOK_URL}";
