#!/bin/sh
# @see https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/xcodebuild.1.html

# active_scheme=MyScheme
active_scheme=HelloXcodebuildForApp

xcodebuild -scheme $active_scheme
if [ $? -eq 0 ]; then
    echo "[INFO] build with scheme $active_scheme successfully"
else
    echo "[INFO] build with scheme $active_scheme failed"
fi
