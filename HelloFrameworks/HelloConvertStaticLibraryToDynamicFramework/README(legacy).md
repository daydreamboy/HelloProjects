## HelloConvertStaticLibraryToDynamicFramework

静态库转动态库的方法

下面说明的示例是

源码 -> 静态库 -> 动态库

动态库target的Other Linker Flags需要设置-all_load或者-ObjC，这样将静态库的符号复制到动态库中；否则动态库仅包含它自身的源码符号。




