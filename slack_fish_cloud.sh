#/bin/bash
readonly EXECUTION_PATH=$(dirname "$0");
readonly CURRENT_DATE=$(date +"%Y-%m-%d");

source "${EXECUTION_PATH}/utils.sh";
source "${EXECUTION_PATH}/credentials.sh";

declare -a ARGUMENTS=${@:2};
declare -i WEB_HOOK_BLOCK_MAX_LENGTH=3001;
declare -i AWS_REGION_NOT_FOUND_STATUS_CODE=255;

message_body="";
ec2_instance_properties="";

checks_for_required_constants() {
  if [[ -z $AWS_PROFILE || -z $WEB_HOOK_URL ]]; then
    alert "-> You must define the required constants, run install.sh";
  fi
}

###############################################################################
# Arguments:
#   region
# Globals:
#   AWS_PROFILE
#   CURRENT_DATE
#   AWS_REGION_NOT_FOUND_STATUS_CODE
#   ec2_instance_properties
###############################################################################
get_ec2_instance_properties() {
  echo "-> Getting EC2 instance properties in ${1}...";
  ec2_instance_properties=$(aws ec2 describe-instances \
    --region $1 \
    --profile ${AWS_PROFILE} \
    --output json \
    --filters 'Name=instance-state-name,Values=running' \
      'Name=launch-time,Values='${CURRENT_DATE}'T*' \
    --query 'Reservations[?!contains(keys(@),`RequesterId`)].Instances[*]
    .{id:InstanceId,time:LaunchTime,type:InstanceType}');

  if [[ $(echo $?) -eq $AWS_REGION_NOT_FOUND_STATUS_CODE ]]; then
    exit;
  elif [[ -z $ec2_instance_properties ]] || \
    [[ $ec2_instance_properties == "[]" ]]; then
    alert "-> The ${1} region had no running instances started today
    ...";
  else
    ec2_instance_properties=$(echo $ec2_instance_properties | \
      jq -r 'map(.[].id + " | " + .[].time + " | " + .[].type) | join("\\n")');
  fi
}

###############################################################################
# Arguments:
#   region
# Globals:
#   message_body
#   ec2_instance_properties
#   WEB_HOOK_BLOCK_MAX_LENGTH
###############################################################################
insert_ec2_instance_properties_in_message_body() {
  echo "-> Inserting EC2 response in the message body...";
  message_body=$(echo ${message_body} | \
    sed "s/<region>/${1}/g ; s/<properties>/${ec2_instance_properties}/");

  if [[ ${#message_body} -ge $WEB_HOOK_BLOCK_MAX_LENGTH ]]; then
    alert "-> Too many instances for Webhook Block max length!";
  fi
}

###############################################################################
# Globals:
#   message_body
###############################################################################
send_message_to_channel() {
  echo "-> Sending message...";
  local response_status=$(curl --silent \
    -H 'Content-type: application/json' \
    --data "${message_body}" \
    ''${WEB_HOOK_URL}'');

  echo "-> Response status: ${response_status}";
}

###############################################################################
# Arguments:
#   the first user argument
# Globals:
#   ARGUMENTS
#   AWS_REGION
###############################################################################
send_ec2_properties_to_channel_for_each_region_specified() {
  if [[ $1 == "--regions" ]]; then
    for region in $ARGUMENTS; do
      call_functions_of_the_main_steps $region;
    done
  elif [[ -z $AWS_REGION ]]; then
    alert "-> Set default AWS_REGION or pass as arguments, for example:\n-> \
    \"./slack_fish_cloud.sh --regions us-east-1 us-east-2\"";
  else
    call_functions_of_the_main_steps $AWS_REGION;
  fi
}

###############################################################################
# Globals:
#   message_body
###############################################################################
refresh_message_body_template() {
  message_body=$(cat "${EXECUTION_PATH}/templates/aws_ec2_basic.json" | jq);
}

###############################################################################
# Arguments:
#   region
###############################################################################
call_functions_of_the_main_steps() {
  refresh_message_body_template;
  get_ec2_instance_properties $1;
  insert_ec2_instance_properties_in_message_body $1;
  send_message_to_channel;
  break_line;
}

checks_for_required_constants;
show_banner;
send_ec2_properties_to_channel_for_each_region_specified $1;
