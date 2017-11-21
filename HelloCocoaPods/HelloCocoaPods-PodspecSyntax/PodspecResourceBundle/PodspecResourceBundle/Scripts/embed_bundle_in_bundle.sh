#!/bin/sh

# stop running script when error happens
set -e

# Require no arguments for calling this scripts
if [ "$#" -ne 0 ]; then
  echo "Usage: bash $0" >&2
  exit 1
fi

# Child bundle
child_bundle="PodspecResourceBundle"
child_bundle_path="${BUILD_DIR}/${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/${PRODUCT_NAME}/${child_bundle}.bundle"

# Parent bundle
parent_bundle="Placeholder"
parent_bundle_path="${BUILD_DIR}/${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/${PRODUCT_NAME}/${parent_bundle}.bundle"

# Dest path
dest_path="${BUILD_DIR}/${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/${PRODUCT_NAME}/${parent_bundle}.bundle/${child_bundle}.bundle"

# clean
rm -rf ${dest_path}
mkdir -p ${dest_path}

# sync
rsync -arv ${child_bundle_path} ${parent_bundle_path}

