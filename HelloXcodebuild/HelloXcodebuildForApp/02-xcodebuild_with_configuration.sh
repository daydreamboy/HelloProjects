#!/bin/sh
# @see https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/xcodebuild.1.html

xcodebuild -configuration Debug
if [ $? -eq 0 ]; then
    echo "[INFO] build with Debug successfully"
else
    echo "[INFO] build with Debug failed"
fi
