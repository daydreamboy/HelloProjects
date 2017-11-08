#!/bin/sh

# @see https://stackoverflow.com/a/46037941
# @see https://gist.github.com/cromandini/1a9c4aeab27ca84f5d79

# Set bash script to exit immediately if any commands fail.
set -e

UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-iphoneuniversal

# only build configuration is Debug to create universal, becase AppStore not accept fat arch
if [ "Debug" == ${CONFIGURATION} ]; then
    # make sure the output directory exists
    mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

    # Next, work out if we're in SIM or DEVICE
    if [ "false" == ${ALREADYINVOKED:-false} ]; then

        export ALREADYINVOKED="true"

        if [ ${PLATFORM_NAME} = "iphonesimulator" ]; then
            xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
        else
            xcodebuild -target "${PROJECT_NAME}" -configuration ${CONFIGURATION} -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
        fi

        # Step 2. Copy the framework structure (from iphoneos build) to the universal folder
        cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PRODUCT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

        # Step 3. Copy Swift modules from iphonesimulator build (if it exists) to the copied framework directory
        SIMULATOR_SWIFT_MODULES_DIR="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PRODUCT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule/."
        if [ -d "${SIMULATOR_SWIFT_MODULES_DIR}" ]; then
            cp -R "${SIMULATOR_SWIFT_MODULES_DIR}" "${UNIVERSAL_OUTPUTFOLDER}/${PRODUCT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule"
        fi

        # Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory
        lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PRODUCT_NAME}.framework/${PRODUCT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PRODUCT_NAME}.framework/${PRODUCT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PRODUCT_NAME}.framework/${PRODUCT_NAME}"

        # Step 5. Convenience step to copy the framework to the project's directory
        cp -R "${UNIVERSAL_OUTPUTFOLDER}/${PRODUCT_NAME}.framework" "${PROJECT_DIR}"

        # Step 6. Convenience step to open the project's directory in Finder
        open "${PROJECT_DIR}"

        # Step 7. Remove build folder
        rm -rf build/
    fi
fi
