## HelloStaticLibraryDependOnDynamicLibrary

### 通知名和userInfo的key采用全局变量方式的问题

静态库依赖lazyload的动态库，通知名和userInfo的key定义在动态库，由于动态库是懒加载，在link阶段，不会链接动态库，所以用到通知名和userInfo的key的静态库，会链接出错。

在.h中换成宏定义的方式，可以避免上面的问题。

