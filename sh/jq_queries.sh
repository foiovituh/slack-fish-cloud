#!/bin/bash
###############################################################################
# Shell Style Guide exception:
#   In this file you are allowed to exceed 80 characters per line
###############################################################################
readonly EC2_INSTANCE_PROPERTIES_JQ_QUERY='map("ID: \(.[].id) | LaunchTime: \(.[].time) | Type: \(.[].type)") | join("\\n")';
readonly EC2_ASG_PROPERTIES_JQ_QUERY='map("Name: \(.id) | MinSize: \(.min) | MaxSize: \(.max) | DesiredCapacity: \(.now)") | join("\\n")';
readonly EC2_VOLUME_PROPERTIES_JQ_QUERY='map("ID: \(.id) | Type: \(.type) | Size: \(.size)") | join("\\n")';
