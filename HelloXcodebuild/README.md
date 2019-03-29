# xcodebuild命令

[TOC]



## 1. 基本使用

​       `xcodebuild`是Xcode相应的命令行工具，执行它相当于调用一组命令行。如果想自动化完成Xcode支持的GUI操作，则需要使用这个命令。

​       `xcodebuild`的工作方式是，xcodebuild在当前目录找`.xcodeproj`文件，根据这个文件的配置输出相应的产物。



### （1）build文件夹

​         `xcodebuild`会在当前`.xcodeproj`文件对应目录下生成build文件夹，它的结构和Xcode的DerivedData中结构是相同的。

​        以HelloXcodebuildForApp工程为例，build文件夹结构如下

```
build  
 |- HelloXcodebuildForApp.build
 |   |- Debug-iphoneos
 |   |   |- HelloXcodebuildForApp.build (存放编译中间产物)
 |   |- Release-iphones
 |       |- HelloXcodebuildForApp.build (存放编译中间产物)
 |- Debug-iphoneos
 |   |- HelloXcodebuildForApp.app (单架构)
 |- Release-iphones
     |- HelloXcodebuildForApp.app (多结构)
     |- HelloXcodebuildForApp.app.dSYM
```



### （2）显示build settings

`xcodebuild`可以使用`-showBuildSettings`选项显示编译配置项。

举个例子，如下

```
Build settings for action build and target HelloXcodebuildForApp:
    ACTION = build
    AD_HOC_CODE_SIGNING_ALLOWED = NO
    ALTERNATE_GROUP = staff
    ALTERNATE_MODE = u+w,go-w,a+rX
    ALTERNATE_OWNER = wesley_chen
    ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = NO
    ALWAYS_SEARCH_USER_PATHS = NO
    ALWAYS_USE_SEPARATE_HEADERMAPS = NO
    APPLE_INTERNAL_DEVELOPER_DIR = /AppleInternal/Developer
    APPLE_INTERNAL_DIR = /AppleInternal
    APPLE_INTERNAL_DOCUMENTATION_DIR = /AppleInternal/Documentation
    APPLE_INTERNAL_LIBRARY_DIR = /AppleInternal/Library
    APPLE_INTERNAL_TOOLS = /AppleInternal/Developer/Tools
    APPLICATION_EXTENSION_API_ONLY = NO
    APPLY_RULES_IN_COPY_FILES = NO
    ARCHS = armv7 arm64
    ARCHS_STANDARD = armv7 arm64
    ARCHS_STANDARD_32_64_BIT = armv7 arm64
    ARCHS_STANDARD_32_BIT = armv7
    ARCHS_STANDARD_64_BIT = arm64
    ARCHS_STANDARD_INCLUDING_64_BIT = armv7 arm64
    ARCHS_UNIVERSAL_IPHONE_OS = armv7 arm64
    ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
    AVAILABLE_PLATFORMS = appletvos appletvsimulator iphoneos iphonesimulator macosx watchos watchsimulator
    BITCODE_GENERATION_MODE = marker
    BUILD_ACTIVE_RESOURCES_ONLY = NO
    BUILD_COMPONENTS = headers build
    BUILD_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Products
    BUILD_ROOT = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Products
    BUILD_STYLE = 
    BUILD_VARIANTS = normal
    BUILT_PRODUCTS_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Products/Release-iphoneos
    CACHE_ROOT = /var/folders/40/gq7s8z1n0sqg976xvn7ymxcw0000gn/C/com.apple.DeveloperTools/8.3.3-8E3004b/Xcode
    CCHROOT = /var/folders/40/gq7s8z1n0sqg976xvn7ymxcw0000gn/C/com.apple.DeveloperTools/8.3.3-8E3004b/Xcode
    CHMOD = /bin/chmod
    CHOWN = /usr/sbin/chown
    CLANG_ANALYZER_NONNULL = YES
    CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
    CLANG_CXX_LANGUAGE_STANDARD = gnu++0x
    CLANG_CXX_LIBRARY = libc++
    CLANG_ENABLE_MODULES = YES
    CLANG_ENABLE_OBJC_ARC = YES
    CLANG_WARN_BOOL_CONVERSION = YES
    CLANG_WARN_CONSTANT_CONVERSION = YES
    CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
    CLANG_WARN_DOCUMENTATION_COMMENTS = YES
    CLANG_WARN_EMPTY_BODY = YES
    CLANG_WARN_ENUM_CONVERSION = YES
    CLANG_WARN_INFINITE_RECURSION = YES
    CLANG_WARN_INT_CONVERSION = YES
    CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
    CLANG_WARN_SUSPICIOUS_MOVE = YES
    CLANG_WARN_UNREACHABLE_CODE = YES
    CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
    CLASS_FILE_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build/JavaClasses
    CLEAN_PRECOMPS = YES
    CLONE_HEADERS = NO
    CODESIGNING_FOLDER_PATH = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Products/Release-iphoneos/HelloXcodebuildForApp.app
    CODE_SIGNING_ALLOWED = YES
    CODE_SIGNING_REQUIRED = YES
    CODE_SIGN_CONTEXT_CLASS = XCiPhoneOSCodeSignContext
    CODE_SIGN_IDENTITY = iPhone Developer
    COLOR_DIAGNOSTICS = YES
    COMBINE_HIDPI_IMAGES = NO
    COMPOSITE_SDK_DIRS = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/CompositeSDKs
    COMPRESS_PNG_FILES = YES
    CONFIGURATION = Release
    CONFIGURATION_BUILD_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Products/Release-iphoneos
    CONFIGURATION_TEMP_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos
    CONTENTS_FOLDER_PATH = HelloXcodebuildForApp.app
    COPYING_PRESERVES_HFS_DATA = NO
    COPY_HEADERS_RUN_UNIFDEF = NO
    COPY_PHASE_STRIP = NO
    COPY_RESOURCES_FROM_STATIC_FRAMEWORKS = YES
    CORRESPONDING_SIMULATOR_PLATFORM_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform
    CORRESPONDING_SIMULATOR_PLATFORM_NAME = iphonesimulator
    CORRESPONDING_SIMULATOR_SDK_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator10.3.sdk
    CORRESPONDING_SIMULATOR_SDK_NAME = iphonesimulator10.3
    CP = /bin/cp
    CREATE_INFOPLIST_SECTION_IN_BINARY = NO
    CURRENT_ARCH = arm64
    CURRENT_VARIANT = normal
    DEAD_CODE_STRIPPING = YES
    DEBUGGING_SYMBOLS = YES
    DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
    DEFAULT_COMPILER = com.apple.compilers.llvm.clang.1_0
    DEFAULT_KEXT_INSTALL_PATH = /System/Library/Extensions
    DEFINES_MODULE = NO
    DEPLOYMENT_LOCATION = NO
    DEPLOYMENT_POSTPROCESSING = NO
    DEPLOYMENT_TARGET_CLANG_ENV_NAME = IPHONEOS_DEPLOYMENT_TARGET
    DEPLOYMENT_TARGET_CLANG_FLAG_NAME = miphoneos-version-min
    DEPLOYMENT_TARGET_CLANG_FLAG_PREFIX = -miphoneos-version-min=
    DEPLOYMENT_TARGET_SETTING_NAME = IPHONEOS_DEPLOYMENT_TARGET
    DEPLOYMENT_TARGET_SUGGESTED_VALUES = 8.0 8.1 8.2 8.3 8.4 9.0 9.1 9.2 9.3 10.0 10.1 10.2 10.3
    DERIVED_FILES_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build/DerivedSources
    DERIVED_FILE_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build/DerivedSources
    DERIVED_SOURCES_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build/DerivedSources
    DEVELOPER_APPLICATIONS_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Applications
    DEVELOPER_BIN_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/usr/bin
    DEVELOPER_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer
    DEVELOPER_FRAMEWORKS_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Library/Frameworks
    DEVELOPER_FRAMEWORKS_DIR_QUOTED = /Applications/Xcode_8/Xcode.app/Contents/Developer/Library/Frameworks
    DEVELOPER_LIBRARY_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Library
    DEVELOPER_SDK_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs
    DEVELOPER_TOOLS_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Tools
    DEVELOPER_USR_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/usr
    DEVELOPMENT_LANGUAGE = English
    DOCUMENTATION_FOLDER_PATH = HelloXcodebuildForApp.app/English.lproj/Documentation
    DO_HEADER_SCANNING_IN_JAM = NO
    DSTROOT = /tmp/HelloXcodebuildForApp.dst
    DT_TOOLCHAIN_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain
    DWARF_DSYM_FILE_NAME = HelloXcodebuildForApp.app.dSYM
    DWARF_DSYM_FILE_SHOULD_ACCOMPANY_PRODUCT = NO
    DWARF_DSYM_FOLDER_PATH = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Products/Release-iphoneos
    EFFECTIVE_PLATFORM_NAME = -iphoneos
    EMBEDDED_CONTENT_CONTAINS_SWIFT = NO
    EMBEDDED_PROFILE_NAME = embedded.mobileprovision
    EMBED_ASSET_PACKS_IN_PRODUCT_BUNDLE = NO
    ENABLE_BITCODE = YES
    ENABLE_DEFAULT_HEADER_SEARCH_PATHS = YES
    ENABLE_HEADER_DEPENDENCIES = YES
    ENABLE_NS_ASSERTIONS = NO
    ENABLE_ON_DEMAND_RESOURCES = YES
    ENABLE_STRICT_OBJC_MSGSEND = YES
    ENABLE_TESTABILITY = NO
    ENTITLEMENTS_ALLOWED = YES
    ENTITLEMENTS_REQUIRED = YES
    EXCLUDED_INSTALLSRC_SUBDIRECTORY_PATTERNS = .DS_Store .svn .git .hg CVS
    EXCLUDED_RECURSIVE_SEARCH_PATH_SUBDIRECTORIES = *.nib *.lproj *.framework *.gch *.xcode* *.xcassets (*) .DS_Store CVS .svn .git .hg *.pbproj *.pbxproj
    EXECUTABLES_FOLDER_PATH = HelloXcodebuildForApp.app/Executables
    EXECUTABLE_FOLDER_PATH = HelloXcodebuildForApp.app
    EXECUTABLE_NAME = HelloXcodebuildForApp
    EXECUTABLE_PATH = HelloXcodebuildForApp.app/HelloXcodebuildForApp
    EXPANDED_CODE_SIGN_IDENTITY = 
    EXPANDED_CODE_SIGN_IDENTITY_NAME = 
    EXPANDED_PROVISIONING_PROFILE = 
    FILE_LIST = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build/Objects/LinkFileList
    FIXED_FILES_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build/FixedFiles
    FRAMEWORKS_FOLDER_PATH = HelloXcodebuildForApp.app/Frameworks
    FRAMEWORK_FLAG_PREFIX = -framework
    FRAMEWORK_VERSION = A
    FULL_PRODUCT_NAME = HelloXcodebuildForApp.app
    GCC3_VERSION = 3.3
    GCC_C_LANGUAGE_STANDARD = gnu99
    GCC_INLINES_ARE_PRIVATE_EXTERN = YES
    GCC_NO_COMMON_BLOCKS = YES
    GCC_PFE_FILE_C_DIALECTS = c objective-c c++ objective-c++
    GCC_SYMBOLS_PRIVATE_EXTERN = YES
    GCC_THUMB_SUPPORT = YES
    GCC_TREAT_WARNINGS_AS_ERRORS = NO
    GCC_VERSION = com.apple.compilers.llvm.clang.1_0
    GCC_VERSION_IDENTIFIER = com_apple_compilers_llvm_clang_1_0
    GCC_WARN_64_TO_32_BIT_CONVERSION = YES
    GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
    GCC_WARN_UNDECLARED_SELECTOR = YES
    GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
    GCC_WARN_UNUSED_FUNCTION = YES
    GCC_WARN_UNUSED_VARIABLE = YES
    GENERATE_MASTER_OBJECT_FILE = NO
    GENERATE_PKGINFO_FILE = YES
    GENERATE_PROFILING_CODE = NO
    GENERATE_TEXT_BASED_STUBS = NO
    GID = 20
    GROUP = staff
    HEADERMAP_INCLUDES_FLAT_ENTRIES_FOR_TARGET_BEING_BUILT = YES
    HEADERMAP_INCLUDES_FRAMEWORK_ENTRIES_FOR_ALL_PRODUCT_TYPES = YES
    HEADERMAP_INCLUDES_NONPUBLIC_NONPRIVATE_HEADERS = YES
    HEADERMAP_INCLUDES_PROJECT_HEADERS = YES
    HEADERMAP_USES_FRAMEWORK_PREFIX_ENTRIES = YES
    HEADERMAP_USES_VFS = NO
    HIDE_BITCODE_SYMBOLS = YES
    HOME = /Users/wesley_chen
    ICONV = /usr/bin/iconv
    INFOPLIST_EXPAND_BUILD_SETTINGS = YES
    INFOPLIST_FILE = HelloXcodebuildForApp/Info.plist
    INFOPLIST_OUTPUT_FORMAT = binary
    INFOPLIST_PATH = HelloXcodebuildForApp.app/Info.plist
    INFOPLIST_PREPROCESS = NO
    INFOSTRINGS_PATH = HelloXcodebuildForApp.app/English.lproj/InfoPlist.strings
    INLINE_PRIVATE_FRAMEWORKS = NO
    INSTALLHDRS_COPY_PHASE = NO
    INSTALLHDRS_SCRIPT_PHASE = NO
    INSTALL_DIR = /tmp/HelloXcodebuildForApp.dst/Applications
    INSTALL_GROUP = staff
    INSTALL_MODE_FLAG = u+w,go-w,a+rX
    INSTALL_OWNER = wesley_chen
    INSTALL_PATH = /Applications
    INSTALL_ROOT = /tmp/HelloXcodebuildForApp.dst
    IPHONEOS_DEPLOYMENT_TARGET = 10.3
    JAVAC_DEFAULT_FLAGS = -J-Xms64m -J-XX:NewSize=4M -J-Dfile.encoding=UTF8
    JAVA_APP_STUB = /System/Library/Frameworks/JavaVM.framework/Resources/MacOS/JavaApplicationStub
    JAVA_ARCHIVE_CLASSES = YES
    JAVA_ARCHIVE_TYPE = JAR
    JAVA_COMPILER = /usr/bin/javac
    JAVA_FOLDER_PATH = HelloXcodebuildForApp.app/Java
    JAVA_FRAMEWORK_RESOURCES_DIRS = Resources
    JAVA_JAR_FLAGS = cv
    JAVA_SOURCE_SUBDIR = .
    JAVA_USE_DEPENDENCIES = YES
    JAVA_ZIP_FLAGS = -urg
    JIKES_DEFAULT_FLAGS = +E +OLDCSO
    KEEP_PRIVATE_EXTERNS = NO
    LD_DEPENDENCY_INFO_FILE = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build/Objects-normal/arm64/HelloXcodebuildForApp_dependency_info.dat
    LD_GENERATE_MAP_FILE = NO
    LD_MAP_FILE_PATH = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build/HelloXcodebuildForApp-LinkMap-normal-arm64.txt
    LD_NO_PIE = NO
    LD_QUOTE_LINKER_ARGUMENTS_FOR_COMPILER_DRIVER = YES
    LD_RUNPATH_SEARCH_PATHS =  @executable_path/Frameworks
    LEGACY_DEVELOPER_DIR = /Applications/Xcode_8/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer
    LEX = lex
    LIBRARY_FLAG_NOSPACE = YES
    LIBRARY_FLAG_PREFIX = -l
    LIBRARY_KEXT_INSTALL_PATH = /Library/Extensions
    LINKER_DISPLAYS_MANGLED_NAMES = NO
    LINK_FILE_LIST_normal_arm64 = 
    LINK_FILE_LIST_normal_armv7 = 
    LINK_WITH_STANDARD_LIBRARIES = YES
    LOCALIZABLE_CONTENT_DIR = 
    LOCALIZED_RESOURCES_FOLDER_PATH = HelloXcodebuildForApp.app/English.lproj
    LOCAL_ADMIN_APPS_DIR = /Applications/Utilities
    LOCAL_APPS_DIR = /Applications
    LOCAL_DEVELOPER_DIR = /Library/Developer
    LOCAL_LIBRARY_DIR = /Library
    LOCROOT = 
    LOCSYMROOT = 
    MACH_O_TYPE = mh_execute
    MAC_OS_X_PRODUCT_BUILD_VERSION = 16G29
    MAC_OS_X_VERSION_ACTUAL = 101206
    MAC_OS_X_VERSION_MAJOR = 101200
    MAC_OS_X_VERSION_MINOR = 1206
    METAL_LIBRARY_FILE_BASE = default
    METAL_LIBRARY_OUTPUT_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Products/Release-iphoneos/HelloXcodebuildForApp.app
    MODULE_CACHE_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/ModuleCache
    MTL_ENABLE_DEBUG_INFO = NO
    NATIVE_ARCH = armv7
    NATIVE_ARCH_32_BIT = i386
    NATIVE_ARCH_64_BIT = x86_64
    NATIVE_ARCH_ACTUAL = x86_64
    NO_COMMON = YES
    OBJECT_FILE_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build/Objects
    OBJECT_FILE_DIR_normal = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build/Objects-normal
    OBJROOT = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates
    ONLY_ACTIVE_ARCH = NO
    OS = MACOS
    OSAC = /usr/bin/osacompile
    PACKAGE_TYPE = com.apple.package-type.wrapper.application
    PASCAL_STRINGS = YES
    PATH = /Applications/Xcode_8/Xcode.app/Contents/Developer/usr/bin:/Users/wesley_chen/.rvm/gems/ruby-2.4.0/bin:/Users/wesley_chen/.rvm/gems/ruby-2.4.0@global/bin:/Users/wesley_chen/.rvm/rubies/ruby-2.4.0/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Wireshark.app/Contents/MacOS:/Users/wesley_chen/.rvm/bin
    PATH_PREFIXES_EXCLUDED_FROM_HEADER_DEPENDENCIES = /usr/include /usr/local/include /System/Library/Frameworks /System/Library/PrivateFrameworks /Applications/Xcode_8/Xcode.app/Contents/Developer/Headers /Applications/Xcode_8/Xcode.app/Contents/Developer/SDKs /Applications/Xcode_8/Xcode.app/Contents/Developer/Platforms
    PBDEVELOPMENTPLIST_PATH = HelloXcodebuildForApp.app/pbdevelopment.plist
    PFE_FILE_C_DIALECTS = objective-c
    PKGINFO_FILE_PATH = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build/PkgInfo
    PKGINFO_PATH = HelloXcodebuildForApp.app/PkgInfo
    PLATFORM_DEVELOPER_APPLICATIONS_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Applications
    PLATFORM_DEVELOPER_BIN_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin
    PLATFORM_DEVELOPER_LIBRARY_DIR = /Applications/Xcode_8/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library
    PLATFORM_DEVELOPER_SDK_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs
    PLATFORM_DEVELOPER_TOOLS_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Tools
    PLATFORM_DEVELOPER_USR_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr
    PLATFORM_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform
    PLATFORM_DISPLAY_NAME = iOS
    PLATFORM_NAME = iphoneos
    PLATFORM_PREFERRED_ARCH = arm64
    PLATFORM_PRODUCT_BUILD_VERSION = 14E8301
    PLIST_FILE_OUTPUT_FORMAT = binary
    PLUGINS_FOLDER_PATH = HelloXcodebuildForApp.app/PlugIns
    PRECOMPS_INCLUDE_HEADERS_FROM_BUILT_PRODUCTS_DIR = YES
    PRECOMP_DESTINATION_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build/PrefixHeaders
    PRESERVE_DEAD_CODE_INITS_AND_TERMS = NO
    PRIVATE_HEADERS_FOLDER_PATH = HelloXcodebuildForApp.app/PrivateHeaders
    PRODUCT_BUNDLE_IDENTIFIER = com.wc.HelloXcodebuildForApp
    PRODUCT_MODULE_NAME = HelloXcodebuildForApp
    PRODUCT_NAME = HelloXcodebuildForApp
    PRODUCT_SETTINGS_PATH = /Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloXcodebuild/HelloXcodebuildForApp/HelloXcodebuildForApp/Info.plist
    PRODUCT_TYPE = com.apple.product-type.application
    PROFILING_CODE = NO
    PROJECT = HelloXcodebuildForApp
    PROJECT_DERIVED_FILE_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/DerivedSources
    PROJECT_DIR = /Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloXcodebuild/HelloXcodebuildForApp
    PROJECT_FILE_PATH = /Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloXcodebuild/HelloXcodebuildForApp/HelloXcodebuildForApp.xcodeproj
    PROJECT_NAME = HelloXcodebuildForApp
    PROJECT_TEMP_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build
    PROJECT_TEMP_ROOT = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates
    PROVISIONING_PROFILE_REQUIRED = YES
    PUBLIC_HEADERS_FOLDER_PATH = HelloXcodebuildForApp.app/Headers
    RECURSIVE_SEARCH_PATHS_FOLLOW_SYMLINKS = YES
    REMOVE_CVS_FROM_RESOURCES = YES
    REMOVE_GIT_FROM_RESOURCES = YES
    REMOVE_HEADERS_FROM_EMBEDDED_BUNDLES = YES
    REMOVE_HG_FROM_RESOURCES = YES
    REMOVE_SVN_FROM_RESOURCES = YES
    RESOURCE_RULES_REQUIRED = YES
    REZ_COLLECTOR_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build/ResourceManagerResources
    REZ_OBJECTS_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build/ResourceManagerResources/Objects
    SCAN_ALL_SOURCE_FILES_FOR_INCLUDES = NO
    SCRIPTS_FOLDER_PATH = HelloXcodebuildForApp.app/Scripts
    SDKROOT = /Applications/Xcode_8/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS10.3.sdk
    SDK_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS10.3.sdk
    SDK_DIR_iphoneos10_3 = /Applications/Xcode_8/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS10.3.sdk
    SDK_NAME = iphoneos10.3
    SDK_NAMES = iphoneos10.3
    SDK_PRODUCT_BUILD_VERSION = 14E8301
    SDK_VERSION = 10.3
    SDK_VERSION_ACTUAL = 100300
    SDK_VERSION_MAJOR = 100000
    SDK_VERSION_MINOR = 300
    SED = /usr/bin/sed
    SEPARATE_STRIP = NO
    SEPARATE_SYMBOL_EDIT = NO
    SET_DIR_MODE_OWNER_GROUP = YES
    SET_FILE_MODE_OWNER_GROUP = NO
    SHALLOW_BUNDLE = YES
    SHARED_DERIVED_FILE_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Products/Release-iphoneos/DerivedSources
    SHARED_FRAMEWORKS_FOLDER_PATH = HelloXcodebuildForApp.app/SharedFrameworks
    SHARED_PRECOMPS_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/PrecompiledHeaders
    SHARED_SUPPORT_FOLDER_PATH = HelloXcodebuildForApp.app/SharedSupport
    SKIP_INSTALL = NO
    SOURCE_ROOT = /Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloXcodebuild/HelloXcodebuildForApp
    SRCROOT = /Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloXcodebuild/HelloXcodebuildForApp
    STRINGS_FILE_OUTPUT_ENCODING = binary
    STRIP_BITCODE_FROM_COPIED_FILES = YES
    STRIP_INSTALLED_PRODUCT = YES
    STRIP_STYLE = all
    SUPPORTED_DEVICE_FAMILIES = 1,2
    SUPPORTED_PLATFORMS = iphonesimulator iphoneos
    SUPPORTS_TEXT_BASED_API = NO
    SWIFT_PLATFORM_TARGET_PREFIX = ios
    SYMROOT = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Products
    SYSTEM_ADMIN_APPS_DIR = /Applications/Utilities
    SYSTEM_APPS_DIR = /Applications
    SYSTEM_CORE_SERVICES_DIR = /System/Library/CoreServices
    SYSTEM_DEMOS_DIR = /Applications/Extras
    SYSTEM_DEVELOPER_APPS_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Applications
    SYSTEM_DEVELOPER_BIN_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/usr/bin
    SYSTEM_DEVELOPER_DEMOS_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Applications/Utilities/Built Examples
    SYSTEM_DEVELOPER_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer
    SYSTEM_DEVELOPER_DOC_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/ADC Reference Library
    SYSTEM_DEVELOPER_GRAPHICS_TOOLS_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Applications/Graphics Tools
    SYSTEM_DEVELOPER_JAVA_TOOLS_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Applications/Java Tools
    SYSTEM_DEVELOPER_PERFORMANCE_TOOLS_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Applications/Performance Tools
    SYSTEM_DEVELOPER_RELEASENOTES_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/ADC Reference Library/releasenotes
    SYSTEM_DEVELOPER_TOOLS = /Applications/Xcode_8/Xcode.app/Contents/Developer/Tools
    SYSTEM_DEVELOPER_TOOLS_DOC_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/ADC Reference Library/documentation/DeveloperTools
    SYSTEM_DEVELOPER_TOOLS_RELEASENOTES_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/ADC Reference Library/releasenotes/DeveloperTools
    SYSTEM_DEVELOPER_USR_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/usr
    SYSTEM_DEVELOPER_UTILITIES_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Applications/Utilities
    SYSTEM_DOCUMENTATION_DIR = /Library/Documentation
    SYSTEM_KEXT_INSTALL_PATH = /System/Library/Extensions
    SYSTEM_LIBRARY_DIR = /System/Library
    TAPI_VERIFY_MODE = ErrorsOnly
    TARGETED_DEVICE_FAMILY = 1
    TARGETNAME = HelloXcodebuildForApp
    TARGET_BUILD_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Products/Release-iphoneos
    TARGET_NAME = HelloXcodebuildForApp
    TARGET_TEMP_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build
    TEMP_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build
    TEMP_FILES_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build
    TEMP_FILE_DIR = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates/HelloXcodebuildForApp.build/Release-iphoneos/HelloXcodebuildForApp.build
    TEMP_ROOT = /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloXcodebuildForApp-gjpvajsvfyjmubdgqngytnhciesw/Build/Intermediates
    TOOLCHAIN_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain
    TREAT_MISSING_BASELINES_AS_TEST_FAILURES = NO
    UID = 501
    UNLOCALIZED_RESOURCES_FOLDER_PATH = HelloXcodebuildForApp.app
    UNSTRIPPED_PRODUCT = NO
    USER = wesley_chen
    USER_APPS_DIR = /Users/wesley_chen/Applications
    USER_LIBRARY_DIR = /Users/wesley_chen/Library
    USE_DYNAMIC_NO_PIC = YES
    USE_HEADERMAP = YES
    USE_HEADER_SYMLINKS = NO
    VALIDATE_PRODUCT = YES
    VALID_ARCHS = arm64 armv7 armv7s
    VERBOSE_PBXCP = NO
    VERSIONPLIST_PATH = HelloXcodebuildForApp.app/version.plist
    VERSION_INFO_BUILDER = wesley_chen
    VERSION_INFO_FILE = HelloXcodebuildForApp_vers.c
    VERSION_INFO_STRING = "@(#)PROGRAM:HelloXcodebuildForApp  PROJECT:HelloXcodebuildForApp-"
    WRAPPER_EXTENSION = app
    WRAPPER_NAME = HelloXcodebuildForApp.app
    WRAPPER_SUFFIX = .app
    WRAP_ASSET_PACKS_IN_SEPARATE_DIRECTORIES = NO
    XCODE_APP_SUPPORT_DIR = /Applications/Xcode_8/Xcode.app/Contents/Developer/Library/Xcode
    XCODE_PRODUCT_BUILD_VERSION = 8E3004b
    XCODE_VERSION_ACTUAL = 0833
    XCODE_VERSION_MAJOR = 0800
    XCODE_VERSION_MINOR = 0830
    XPCSERVICES_FOLDER_PATH = HelloXcodebuildForApp.app/XPCServices
    YACC = yacc
    arch = arm64
    diagnostic_message_length = 112
    variant = normal
```

上面比较常用的配置名有

| 配置名            | 含义                                   |
| ----------------- | -------------------------------------- |
| CONFIGURATION     | Debug或者Release                       |
| PROJECT_DIR       | .xcodeproj文件所在的绝对路径           |
| SRCROOT           | 和PROJECT_DIR一样的                    |
| PROJECT_NAME      | 和.xcodeproj文件名一致                 |
| TARGET\_TEMP\_DIR | 编译时中间文件所在的文件夹路径         |
| CURRENT\_ARCH     | 当前硬件架构，值有arm64、armv7、x86_64 |

说明

> Xcode的环境变量，可以使用${var}或者$(var)取值。除了Xcode的<b>Build Settings</b>中使用上面的Xcode的环境变量，还可以使用inherited。



### （3）设置build settings

build settings可以作为独立的选项传给`xcodebuild`命令。举个例子，如下

```shell
$ xcodebuild -scheme Test -destination 'platform=iOS Simulator,name=iPhone 8,OS=12.1' GCC_TREAT_WARNINGS_AS_ERRORS=NO
```

说明

> 命令行中的build settings配置，优先级高于xcodebuild会读取.xcodeproj文件中的配置



## 2. 常用选项

​         `xcodebuild`命令的选项非常多。使用`xcodebuild -help`打印完整的帮助信息，`xcodebuild -usage`打印简明的帮助信息

​        常用选项，如下

| 选项                                             | 含义                                                         | 说明                                                       |
| ------------------------------------------------ | ------------------------------------------------------------ | ---------------------------------------------------------- |
| 选项为空                                         | 默认在当前目录下生成build文件夹，存放编译产物，采用Release build configuration |                                                            |
| `-project <name>.xcodeproj`                      | 指定某个`.xcodeproj`工程文件                                 |                                                            |
| `-scheme <scheme name>`                          | 指定scheme后，build文件夹生成在DerivedData路径下。           | scheme和target只能同时指定一个                             |
| `-target <target name>`                          | 指定project下面需要编译哪个target，如果不指定，默认编译targets列表中的第一个target |                                                            |
| `-configuration <build configuration>`           | 指定采用哪种build configuration（一般是Debug或者Release）编译target |                                                            |
| `-destination 'platform=<platform>,name=<name>'` | 指定目标设备[^2]，如果不指定则是真机设备。`-destination`     | 示例`-destination 'platform=iOS Simulator,name=iPhone XR'` |



复杂的选项，下面详细介绍下

### （1）`-destination`选项[^3]

`-destination`选项的值是`'key1=value1,key2=value2'`形式。



#### a. 常用键值对



##### OS X和iOS通用的key值

| key        | value                                                        | 示例 |
| ---------- | ------------------------------------------------------------ | ---- |
| `platform` | `OS X`, your Mac<br />`iOS`, a connected iOS device <br />`iOS Simulator` <br />`watchOS` <br />`watchOS Simulator` <br />`tvOS` <br />`tvOS Simulator` |      |



##### OS X特有的key值

| key    | value                | 示例                                                         |
| ------ | -------------------- | ------------------------------------------------------------ |
| `arch` | `x86_64`<br />`i386` | xcodebuild \\<br/>  -workspace MyMacApp.xcworkspace \\<br />
  -scheme MyMacApp \\<br />
  -destination 'platform=OS X,arch=x86_64' \\<br />
  clean test |



##### iOS/iOS Simulator特有的key值

| key    | value                | 示例                                                         |
| ------ | -------------------- | ------------------------------------------------------------ |
| `id`   | UUID                 | xcodebuild \\<br/>-workspace MyApp.xcworkspace \\<br />
  -scheme MyApp \\<br />
  -destination 'platform=iOS,id=YOUR_PHONE_UUID' \\<br />
  clean test |
| `name` | 设备名               | xcodebuild \\<br/>  -workspace MyApp.xcworkspace \\<br />
  -scheme MyApp \\<br />
  -destination "platform=iOS,name=Gio's iPhone" \\<br />
  clean test |
| `OS`   | 系统版本或者`latest` | xcodebuild \\<br/>  -workspace MyApp.xcworkspace \\<br />
  -scheme MyApp \\<br />
  -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.1' \\<br/>
  clean test |

说明

> 1. 模拟器设备的UUID和设备名，可以使用`xcrun simctl list`查询到
> 2. 真机设备的UUID和设备名，可以使用`instruments -s devices`查询到
> 3. 当platform=iOS或者platform=iOS Simulator时，必须指定`id`或者`name`
> 4. 如果使用`name`时，xcodebuild找不到设备，则需要同时使用`OS`指定系统版本



#### b. Generic形式

`-destination`支持通用的设备，例如通用iOS设备则是`-destination generic/platform=iOS`



#### c. 多个`-destination`选项

xcodebuild允许多个`-destination`选项，这样可以编译多个目标设备上的产物。








References
--

[^1]:https://developer.apple.com/library/mac/documentation/DeveloperTools/Reference/XcodeBuildSettingRef/1-Build_Setting_Reference/build_setting_ref.html#//apple_ref/doc/uid/TP40003931-CH3-SW38
[^2]: https://stackoverflow.com/a/34005020
[^3]:<https://www.mokacoding.com/blog/xcodebuild-destination-options/>