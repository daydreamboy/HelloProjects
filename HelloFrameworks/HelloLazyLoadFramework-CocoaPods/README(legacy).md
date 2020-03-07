## CocoaPod集成的动态库换成懒加载方式

### Setup project

1. Prepare a podspec to provide binary framework
2. Create Podfile to import the framework
3. Add `DYLD_PRINT_LIBRARIES` environment variable to check launching load
4. Modify xcconfig (Debug/Release)

* Remove framework in `FRAMEWORK_SEARCH_PATHS`, e.g. 

```
FRAMEWORK_SEARCH_PATHS = $(inherited) "${PODS_ROOT}/../../MyFramework/Frameworks"
=>
FRAMEWORK_SEARCH_PATHS = $(inherited)
```

* Remove framework in `OTHER_LDFLAGS `, e.g. 

```
OTHER_LDFLAGS = $(inherited) -ObjC -framework "MyFramework"
=>
OTHER_LDFLAGS = $(inherited) -ObjC
```

