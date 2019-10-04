# HelloNSFileHandle

[TOC]

## 1、文件句柄数超过系统限制的问题

​        MacOS和iOS系统下，每个进程对正在打开文件句柄数有一个上限数量。如果超过这个数量，则任何对文件系统的访问，都可能存在出现错误的情况。

​       SO上有人通过设备的console日志，看到iPhone 5上允许同时打开的文件句柄是78[^1]。由于每个设备和系统版本存在差异，这个最大数量不是一样的。

> 文件句柄，不仅指打开的文件，也包括设备文件，例如socket等



为了检测，iOS上每个App能打开的文件句柄数，采用下面代码进行测试，如下

```objective-c
NSString *infoPlistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
NSString *mainBundleDirectory = [[NSBundle mainBundle] bundlePath];

NSUInteger maximum = 10000;
// maximum = 100;
NSUInteger count = 0;
if ([[NSFileManager defaultManager] fileExistsAtPath:infoPlistPath]) {
    for (NSUInteger i = 0; i < maximum; ++i) {
        FILE *file = fopen([infoPlistPath UTF8String], "r");
        if (file != NULL) {
            // @see https://stackoverflow.com/questions/3167298/how-can-i-convert-a-file-pointer-file-fp-to-a-file-descriptor-int-fd
            int fd = fileno(file);

            // Note: pass NO to not close the file handle on purpose
            NSFileHandle *handle = [[NSFileHandle alloc] initWithFileDescriptor:fd closeOnDealloc:NO];
            NSLog(@"%@", handle);
            count++;
        }
    }
}

NSError *error;
NSArray *list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:mainBundleDirectory error:&error];
NSLog(@"maximum opening handle: %ld", (long)count);
NSLog(@"%@", list);
NSLog(@"%@", error); // Maybe error: {Error Domain=NSPOSIXErrorDomain Code=24 "Too many open files"}}

if (error) {
    NSString *msg = [NSString stringWithFormat:@"maximum opening file: %ld", (long)count];
    SHOW_ALERT(@"Error: Reached the maximum opening file", msg, @"Ok", nil);
}
```

当文件句柄数超过最大数，`-[NSFileManager contentsOfDirectoryAtPath:error:]`会返回nil。

> 示例代码，见TestMaximumOpeningFileHandleViewController



## References

[^1]:https://stackoverflow.com/questions/18666921/maximum-amount-of-open-files-on-ios

