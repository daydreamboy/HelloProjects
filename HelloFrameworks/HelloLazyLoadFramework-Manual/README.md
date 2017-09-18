
### Setup project

1. Single view app
2. Add new targets (Cocoa Touch Framework) MyFramework1 and MyFramework2. Make `Embed in Application` none
3. Add MFManager classes for each dynamic framework target
4. In `Build Phase` -> `Headers`, move `MFManager.h` from `project` to `public` for each dynamic framework
4. Add both frameworks as target dependencies to app (to make them build)
5. Add a new `Copy Files` build phase in app target, and configured to store files to the `Frameworks` destination
6. Add both frameworks to the new `Copy Files` Build Phase to have them packed and signed together with your app
7. \#import "dlfcn.h"
8. Use dlload ex. `dlload("MyFramework1.framework/MyFramework1", RTLD_LAZY)` to load a framework at runtime.

### Tips

1\. Same symbols in different frameworks, loaded in runtime, will cause `Which one is undefined` error. Afterward loaded same symbols will not work.

```
dyld: loaded: /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloLazyLoadFramework-Manual-ddocsdrrinmirffuqwxdfasdudty/Build/Products/Debug-iphonesimulator/MyFramework2.framework/MyFramework2
objc[24903]: Class MFManager is implemented in both /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloLazyLoadFramework-Manual-ddocsdrrinmirffuqwxdfasdudty/Build/Products/Debug-iphonesimulator/MyFramework1.framework/MyFramework1 (0x11713d160) and /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloLazyLoadFramework-Manual-ddocsdrrinmirffuqwxdfasdudty/Build/Products/Debug-iphonesimulator/MyFramework2.framework/MyFramework2 (0x117142160). One of the two will be used. Which one is undefined.
```

2\. After `dlclose` or NSBundle `unload`, symbols still alive

3\. Only import framework's header files, will not link the framework. But different symbols (e.g. methods) will or not link framework on compile time

* Class name, will not link, e.g. `MFManager *manager = [NSClassFromString(@"MFManager") new]`
* Class methods, will link, e.g. `MFManager *manager = [MFManager new]`
* Instance methods, will not link, e.g. `[manager helloWithName:@"Lucy"];`

4\. Class type can call any method, e.g. `[NSClassFromString(@"XXXClass") anyMethod]`

