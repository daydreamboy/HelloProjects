#!/bin/sh

# @see https://stackoverflow.com/a/46037941
# @see https://gist.github.com/cromandini/1a9c4aeab27ca84f5d79

# Note:
# 1. Targets -> <Universal Target> -> General -> Deployment Info -> Deployment Target,
#    set iOS Deployment Target to `iOS 8.0` to include i386 for simulator and armv7 for device. `iOS 11.2` won't include those archs
# 2. error: Check dependencies No architectures to compile for (ARCHS=i386 x86_64, VALID_ARCHS=arm64 armv7 armv7s).
#    solution: build settings, set VALID_ARCHS="arm64 armv7 armv7s i386 x86_64"

# Set bash script to exit immediately if any commands fail.
set -e
set -x

UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-iphoneuniversal

xcode_version=`xcodebuild -version | head -n 1 | cut -d' ' -f2`
xcode_10=10

# only build configuration is Debug to create universal, becase AppStore not accept fat arch
if [ "Debug" == ${CONFIGURATION} ]; then
    # make sure the output directory exists
    mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

    # Next, work out if we're in SIM or DEVICE
    if [ "false" == ${ALREADYINVOKED:-false} ]; then

        export ALREADYINVOKED="true"

        additional_arch=${PLATFORM_NAME}
        if [ ${PLATFORM_NAME} = "iphonesimulator" ]; then
            additional_arch='iphoneos'
        else
            additional_arch='iphonesimulator'
        fi

        if (( $(echo "$xcode_version >= $xcode_10" | bc -l) )); then
            xcodebuild -target "${TARGET_NAME}" -configuration ${CONFIGURATION} -sdk ${additional_arch} ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" OBJROOT="${OBJROOT}" -UseModernBuildSystem=NO
        else
            xcodebuild -target "${TARGET_NAME}" -configuration ${CONFIGURATION} -sdk ${additional_arch} ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" OBJROOT="${OBJROOT}" clean build
        fi
        
        # Step 2. Copy the framework structure (from iphoneos build) to the universal folder
        rsync -arv "${BUILD_DIR}/${CONFIGURATION}-${additional_arch}/${PRODUCT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

        # Step 3. Copy Swift modules from iphonesimulator build (if it exists) to the copied framework directory
        SIMULATOR_SWIFT_MODULES_DIR="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PRODUCT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule/."
        if [ -d "${SIMULATOR_SWIFT_MODULES_DIR}" ]; then
            rsync -arv "${SIMULATOR_SWIFT_MODULES_DIR}" "${UNIVERSAL_OUTPUTFOLDER}/${PRODUCT_NAME}.framework/Modules/${PRODUCT_NAME}.swiftmodule"
        fi

        # Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory
        lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PRODUCT_NAME}.framework/${PRODUCT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PRODUCT_NAME}.framework/${PRODUCT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PRODUCT_NAME}.framework/${PRODUCT_NAME}"

        # Step 5. Convenience step to copy the framework to the project's directory
        rsync -arv "${UNIVERSAL_OUTPUTFOLDER}/${PRODUCT_NAME}.framework" "${PROJECT_DIR}"

        # Step 6. Convenience step to open the project's directory in Finder
        open "${PROJECT_DIR}"

        # Step 7. Remove build folder
        rm -rf build/
    fi
fi


if [ "Release" == ${CONFIGURATION} ]; then
    # make sure the output directory exists
    mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

    # Next, work out if we're in SIM or DEVICE
    if [ "false" == ${ALREADYINVOKED:-false} ]; then

        export ALREADYINVOKED="true"

        additional_arch=${PLATFORM_NAME}
        if [ ${PLATFORM_NAME} = "iphonesimulator" ]; then
            additional_arch='iphoneos'
        else
            additional_arch='iphonesimulator'
        fi
        
        if (( $(echo "$xcode_version >= $xcode_10" | bc -l) )); then
            xcodebuild -target "${TARGET_NAME}" -configuration ${CONFIGURATION} -sdk ${additional_arch} ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" OBJROOT="${OBJROOT}" -UseModernBuildSystem=NO
        else
            xcodebuild -target "${TARGET_NAME}" -configuration ${CONFIGURATION} -sdk ${additional_arch} ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" OBJROOT="${OBJROOT}" clean build
        fi
        
        # Step 2. Copy the framework structure (from iphoneos build) to the universal folder
        rsync -arv "${BUILD_DIR}/${CONFIGURATION}-${additional_arch}/${PRODUCT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"
        
		# Note: copy dSYM if needed
		dSYM="${BUILD_DIR}/${CONFIGURATION}-${additional_arch}/${PRODUCT_NAME}.framework.dSYM"
		if [ -d "$dSYM" ]; then
			rsync -arv "$dSYM" "${UNIVERSAL_OUTPUTFOLDER}/"
		fi

        # Step 3. Copy Swift modules from iphonesimulator build (if it exists) to the copied framework directory
        SIMULATOR_SWIFT_MODULES_DIR="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PRODUCT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule/."
        if [ -d "${SIMULATOR_SWIFT_MODULES_DIR}" ]; then
            rsync -arv "${SIMULATOR_SWIFT_MODULES_DIR}" "${UNIVERSAL_OUTPUTFOLDER}/${PRODUCT_NAME}.framework/Modules/${PRODUCT_NAME}.swiftmodule"
        fi

        # Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory
        lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PRODUCT_NAME}.framework/${PRODUCT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PRODUCT_NAME}.framework/${PRODUCT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PRODUCT_NAME}.framework/${PRODUCT_NAME}"
        
        if [ ${MACH_O_TYPE} == "mh_dylib" ]; then
            strip -x "${UNIVERSAL_OUTPUTFOLDER}/${PRODUCT_NAME}.framework/${PRODUCT_NAME}"
        fi

		# Note: create universal dSYM
		dSYM_iphoneos="${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PRODUCT_NAME}.framework.dSYM/Contents/Resources/DWARF/${PRODUCT_NAME}"
		dSYM_iphonesimulator="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PRODUCT_NAME}.framework.dSYM/Contents/Resources/DWARF/${PRODUCT_NAME}"
	
		if [ -f "$dSYM_iphoneos" ] && [ -f "$dSYM_iphonesimulator" ] ; then
			lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PRODUCT_NAME}.framework.dSYM/Contents/Resources/DWARF/${PRODUCT_NAME}" "${dSYM_iphoneos}" "${dSYM_iphonesimulator}"
		fi

        # Step 5. Convenience step to copy the framework to the project's directory
        rsync -arv "${UNIVERSAL_OUTPUTFOLDER}/${PRODUCT_NAME}.framework" "${PROJECT_DIR}"

        # Step 6. Convenience step to open the project's directory in Finder
        open "${PROJECT_DIR}"

        # Step 7. Remove build folder
        rm -rf build/
    fi
fi
