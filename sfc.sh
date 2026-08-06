#!/bin/bash
readonly EXECUTION_PATH="$(dirname "$0")";
readonly CURRENT_DATE="$(date +"%Y-%m-%d")";

source "${EXECUTION_PATH}/sh/utils.sh";
source "${EXECUTION_PATH}/sh/jq_queries.sh";
source "${EXECUTION_PATH}/sh/credentials.sh";

declare -a ARGUMENTS="${@:2}";
declare -i WEB_HOOK_BLOCK_MAX_LENGTH=3001;
declare -i AWS_REGION_NOT_FOUND_STATUS_CODE=255;

message_body='';
ec2_asg_properties='';
ec2_volume_properties='';
ec2_snapshot_properties='';
ec2_instance_properties='';

###############################################################################
# Globals:
#  AWS_PROFILE
#  WEB_HOOK_URL
###############################################################################
checks_for_required_constants() {
  if [[ -z "$AWS_PROFILE" || -z "$WEB_HOOK_URL" ]]; then
    alert '-> You must define the required constants, run install.sh';
  fi
}

###############################################################################
# Globals:
#  AWS_REGION_NOT_FOUND_STATUS_CODE
###############################################################################
exit_if_aws_region_was_not_found() {
  if [[ $1 -eq $AWS_REGION_NOT_FOUND_STATUS_CODE ]]; then
    exit;
  fi
}

###############################################################################
# Arguments:
#   region
#   any ec2 properties content
#   any ec2 resource name
#   any ec2 console hashtag to redirect
###############################################################################
call_main_step_functions_if_has_running_resources_in_current_region() {
  if [[ -z "$2" ]] || [[ "$2" == "[]" ]]; then
    printf '%s\n\n' "-> The ${1} region had no running ${3}...";
  else
    call_functions_of_the_main_steps "$1" "$3" "$2" "$4";
  fi
}

###############################################################################
# Arguments:
#   region
# Globals:
#   AWS_PROFILE
#   CURRENT_DATE
#   AWS_REGION_NOT_FOUND_STATUS_CODE
#   eks_clusters_properties
###############################################################################
get_eks_clusters_properties() {
  printf '%s\n' "-> Getting EKS list-clusters in ${1}...";
  eks_clusters_properties="$(aws eks list-clusters \
    --region "$1" \
    --profile "$AWS_PROFILE" \
    --output 'json' \
    --query 'clusters[]')";

  exit_if_aws_region_was_not_found $(echo $?);
}

###############################################################################
# Arguments:
#   region
# Globals:
#   AWS_PROFILE
#   CURRENT_DATE
#   AWS_REGION_NOT_FOUND_STATUS_CODE
#   ec2_asg_properties
###############################################################################
get_ec2_auto_scaling_group_properties() {
  printf '%s\n' "-> Getting EC2 auto scaling group properties in ${1}...";
  ec2_asg_properties="$(aws autoscaling describe-auto-scaling-groups \
    --region "$1" \
    --profile "$AWS_PROFILE" \
    --output 'json' \
    --query 'AutoScalingGroups[?DesiredCapacity>=`1`]
    .{id:AutoScalingGroupName,min:MinSize,max:MaxSize,now:DesiredCapacity}')";

  exit_if_aws_region_was_not_found $(echo $?);

  ec2_asg_properties="$(jq -r "$EC2_ASG_PROPERTIES_JQ_QUERY" \
  <<< "$ec2_asg_properties")";
}

###############################################################################
# Arguments:
#   region
# Globals:
#   AWS_PROFILE
#   CURRENT_DATE
#   AWS_REGION_NOT_FOUND_STATUS_CODE
#   ec2_volume_properties
###############################################################################
get_ec2_volume_properties() {
  printf '%s\n' "-> Getting EC2 volumes properties in ${1}...";
  ec2_volume_properties="$(aws ec2 describe-volumes \
    --region "$1" \
    --profile "$AWS_PROFILE" \
    --output 'json' \
    --filters 'Name=create-time,Values='${CURRENT_DATE}'T*' \
    --query 'Volumes[?State!=`deleted`]
    .{id:VolumeId,type:VolumeType,size:Size}')";

  exit_if_aws_region_was_not_found $(echo $?);

  ec2_volume_properties="$(jq -r "$EC2_VOLUME_PROPERTIES_JQ_QUERY" \
    <<< "$ec2_volume_properties")";
}

###############################################################################
# Arguments:
#   region
# Globals:
#   AWS_PROFILE
#   CURRENT_DATE
#   AWS_REGION_NOT_FOUND_STATUS_CODE
#   ec2_snapshot_properties
###############################################################################
get_ec2_snapshot_properties() {
  printf '%s\n' "-> Getting EC2 snapshots properties in ${1}...";
  ec2_snapshot_properties="$(aws ec2 describe-snapshots \
    --region "$1" \
    --profile "$AWS_PROFILE" \
    --output 'json' \
    --owner-ids 'self' \
    --query 'Snapshots[].{id:SnapshotId,state:State,tier:StorageTier}')";

  exit_if_aws_region_was_not_found $(echo $?);

  ec2_snapshot_properties="$(jq -r "$EC2_SNAPSHOT_PROPERTIES_JQ_QUERY" \
    <<< "$ec2_snapshot_properties")";
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
  printf '%s\n' "-> Getting EC2 instance properties in ${1}...";
  ec2_instance_properties="$(aws ec2 describe-instances \
    --region "$1" \
    --profile "$AWS_PROFILE" \
    --output 'json' \
    --filters 'Name=instance-state-name,Values=running' \
      'Name=launch-time,Values='${CURRENT_DATE}'T*' \
    --query 'Reservations[?!contains(keys(@),`RequesterId`)].Instances[*]
    .{id:InstanceId,time:LaunchTime,type:InstanceType}')";

  exit_if_aws_region_was_not_found $(echo $?); 

  ec2_instance_properties="$(jq -r "$EC2_INSTANCE_PROPERTIES_JQ_QUERY" \
  <<< "$ec2_instance_properties")";
}

###############################################################################
# Arguments:
#   region
#   resouce name
#   "ec2_any_properties" content
#   any ec2 console hashtag to redirect
# Globals:
#   message_body
#   WEB_HOOK_BLOCK_MAX_LENGTH
###############################################################################
insert_ec2_properties_in_message_body() {
  printf '%s\n' '-> Inserting EC2 response in the message body...';

  message_body="$(sed "s/<region>/${1}/g ; s/<type>/${2}/ ; s/<data>/${3}/ ; \
  s/<#>/${4}/" <<< "${message_body}")";

  if [[ ${#message_body} -ge $WEB_HOOK_BLOCK_MAX_LENGTH ]]; then
    alert '-> Too many resources for Webhook Block max length!';
  fi
}

###############################################################################
# Globals:
#   message_body
###############################################################################
send_message_to_channel() {
  printf '%s\n' '-> Sending message...';
  local response_status="$(curl --silent \
    -H 'Content-type: application/json' \
    --data "${message_body}" \
    ''${WEB_HOOK_URL}'')";

  printf "%s\n\n" "-> Response status: ${response_status}";
}

###############################################################################
# Arguments:
#   the first user argument
# Globals:
#   ARGUMENTS
###############################################################################
send_eks_properties_to_channel_for_each_region_specified() {
  if [[ "$1" == '--regions' ]]; then
    for region in ${ARGUMENTS[@]}; do
      get_eks_clusters_properties "$region";
      call_main_step_functions_if_has_running_resources_in_current_region \
      "$region" "$eks_clusters_properties" 'eks' \
      '#EKS:';
    done
  else
    alert '-> You must specify one or more regions, for example:
    "./slack_fish_cloud.sh --regions us-east-1 us-east-2"';
  fi
}

###############################################################################
# Arguments:
#   the first user argument
# Globals:
#   ARGUMENTS
###############################################################################
send_ec2_properties_to_channel_for_each_region_specified() {
  if [[ "$1" == '--regions' ]]; then
    for region in ${ARGUMENTS[@]}; do
      get_ec2_auto_scaling_group_properties "$region";
      call_main_step_functions_if_has_running_resources_in_current_region \
      "$region" "$ec2_asg_properties" 'auto scaling groups' \
      '#AutoScalingGroups:';

      get_ec2_volume_properties "$region";
      call_main_step_functions_if_has_running_resources_in_current_region \
      "$region" "$ec2_volume_properties" 'volumes' '#Volumes:';

      get_ec2_snapshot_properties "$region";
      call_main_step_functions_if_has_running_resources_in_current_region \
      "$region" "$ec2_snapshot_properties" 'snapshots' '#Snapshots:';

      get_ec2_instance_properties "$region";
      call_main_step_functions_if_has_running_resources_in_current_region \
      "$region" "$ec2_instance_properties" 'instances' \
      '#Instances:instanceState=running;sort=tag:Name';
    done
  else
    alert '-> You must specify one or more regions, for example:
    "./slack_fish_cloud.sh --regions us-east-1 us-east-2"';
  fi
}

###############################################################################
# Globals:
#   message_body
###############################################################################
refresh_message_body_template() {
  message_body="$(jq < "${EXECUTION_PATH}/templates/aws_ec2_basic.json")";
}

###############################################################################
# Arguments:
#   region
#   resource name
#   "ec2_any_properties" content
###############################################################################
call_functions_of_the_main_steps() {
  refresh_message_body_template;
  insert_ec2_properties_in_message_body "$1" "$2" "$3" "$4";
  send_message_to_channel;
}

checks_for_required_constants;
show_banner;
send_ec2_properties_to_channel_for_each_region_specified $1;
send_eks_properties_to_channel_for_each_region_specified $1;
