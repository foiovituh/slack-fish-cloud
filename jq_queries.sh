#!/bin/bash
###############################################################################
# Shell Style Guide exception:
#   In this file you are allowed to exceed 80 characters per line
###############################################################################
readonly EC2_INSTANCE_PROPERTIES_JQ_QUERY='map(.[].id + " | " + .[].time + " | " + .[].type) | join("\\n")';
readonly EC2_ASG_PROPERTIES_JQ_QUERY='map("Name: \(.id) | MinSize: \(.min) | MaxSize: \(.max) | DesiredCapacity: \(.now)") | join("\\n")';
