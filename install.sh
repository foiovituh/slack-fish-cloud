#/bin/bash
readonly EXECUTION_PATH=$(dirname "$0");

source "${EXECUTION_PATH}/utils.sh";

declare -a DEPENDENCIES=$(cat "${EXECUTION_PATH}/dependencies.txt");

read -p "-> CLI profile name: " AWS_PROFILE;
read -p "-> Slack webhook url for your workspace: " WEB_HOOK_URL;

set_credential_constants() {
  sed -e "s,${1}=\"\",${1}=\"${2}\"," -i "${EXECUTION_PATH}/credentials.sh";
}

set_credential_constants "AWS_PROFILE" ${AWS_PROFILE};
set_credential_constants "WEB_HOOK_URL" ${WEB_HOOK_URL};

for dependencie in ${DEPENDENCIES[@]}; do
  if [[ ! -x $(command -v ${dependencie}) ]]; then
    echo -e "\n-> Installing ${dependencie}...";
    if [[ $dependencie == "aws" ]]; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
          -o "awscliv2.zip";
        unzip "awscliv2.zip";
        sudo ./aws/install;
        rm -rf "awscliv2.zip";

        echo -e "\n-> For more information about how to configure CLI see:";
        echo $(cat "${EXECUTION_PATH}/links/aws_cli_setup.txt");
        break_line;
    fi

    sudo apt install "$dependencie";
  fi
done

echo -e "\n-> Copying figlet fonts to \"/usr/share/figlet/\"...";
sudo cp "${EXECUTION_PATH}/fonts/figlet/big.flf" "/usr/share/figlet/";

