#!/bin/sh
#
# References
#   https://stackoverflow.com/questions/33846361/hook-in-podfile-to-edit-my-project-file
set -e
pod install
ruby "../PodspecResourceBundle/Scripts/add_run_script_to_pod_target.rb"

