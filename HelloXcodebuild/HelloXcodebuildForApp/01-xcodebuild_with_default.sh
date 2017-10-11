#!/bin/sh

xcodebuild
if [ $? -eq 0 ]; then
    echo "[INFO] build successfully"
else
    echo "[INFO] build failed"
fi
