#!/bin/sh

set -e
pod install
ruby "../PodspecResourceBundle/Scripts/add_run_script_to_pod_target.rb"

