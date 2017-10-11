#!/bin/sh
# @see https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/xcodebuild.1.html

# active_target=AppTests
# active_target=HelloXcodebuildForApp
active_target=MyTarget1

xcodebuild -target $active_target
if [ $? -eq 0 ]; then
    echo "[INFO] build with target $active_target successfully"
else
    echo "[INFO] build with target $active_target failed"
fi
