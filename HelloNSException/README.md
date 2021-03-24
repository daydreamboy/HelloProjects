# HelloNSException

[TOC]

## 1、Exception vs Signal

​        Exception是在Objective-C中，主要API是NSException类；而Signal是操作系统级别，一般用于IPC（inter-process communication），主要是C API。可见Signal比Exception更加底层一些。mikeash的[文章](https://www.mikeash.com/pyblog/friday-qa-2013-01-11-mach-exception-handlers.html)，提到Signal和Exception的区别。



## 2、Crash的过程

简单来说，Crash是没有捕获的异常或者信号。CocoaWithLove的[这篇文章](https://www.cocoawithlove.com/2010/05/handling-unhandled-exceptions-and.html)提到Crash的来源。

- Crash是应用程序不能处理的信号（signal）或者异常（exception），不能处理的signal或来exception自三种地方：内核（kernel）、其他进程和应用程序自身。
- 常见导致crash的信号和异常
  - EXC\_BAD\_ACCESS，是Mach exception。如果没有在Mach内处理，将转成SIGBUS或者SIGSEGV信号
  - SIGABRT，是应用程序自身发出的，当NSException或者obj\_exception\_throw没有被捕获



## 3、Crash捕获

### （1） NSUncaughtExceptionHandler捕获异常

Objective-C提供两个C函数，如下

```c
// handler类型
typedef void (NSException * _Nonnull) NSUncaughtExceptionHandler;

// 获取当前handler
NSUncaughtExceptionHandler * NSGetUncaughtExceptionHandler(void);

// 设置uncaught exception handler
void NSSetUncaughtExceptionHandler(NSUncaughtExceptionHandler *);
```

​        iOS app默认没有提供handler，开发者可以自己设置NSUncaughtExceptionHandler。常见的nil参数、数组越界可以通过这个handler捕获。

Apple文档对这个handler的解释是，在程序结束之前，做日志操作。



### （2）signal捕获特定信号

signal是一个C函数，定义在`#include <sys/signal.h>`，如下

```c
void (*signal(int, void (*)(int)))(int);
```

signal函数用于配置当前进程，可以接收哪些信号，或者忽略哪些信号。

- 第一个参数，是信号值。例如SIGABRT（abort）、SIGILL（illegal instruction）、SIGSEGV（segmentation violation）、SIGFPE（floating point exception）、SIGBUS（bus error）、SIGPIPE（write on a pipe with no one to read it）等。这些值通过宏提供，也在`<sys/signal.h>`中。
- 第二个参数，是信号handler，类型是函数指针。如果handler指定不是函数指针，而是特定的宏（也是函数指针类型，定义在`<sys/signal.h>`中），如下
  - SIG\_DFL（default）代表默认handler，其实NULL。如果要注销掉handler，可以设置signal(SIGABRT, SIG_DFL)
  - SIG\_IGN（ignore）代表忽略特定的信号。
  - SIG\_HOLD和SIG\_ERR

信号的handler的类型是void (handler)(int)，带一个int参数对应的是信号值。

signal函数的返回值是上一个handler，也是就被替换的handler



### （3）其他方式

- main函数添加try-catch

```objective-c
int main(int argc, char * argv[]) {
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"exception: %@", exception);
        }
    }
}
```

​        不推荐使用这种方式，所有exception被catch住，跳出了主线程的runloop，应用已经不能存活。在catch块除了记录日志，不能做任何UI相关事情，而且不会触发NSUncaughtExceptionHandler句柄。



## 4、如何分析Crash Reports[^1]

### （1）Report的Header部分

```
Incident Identifier: 6C1DF203-BF5B-4A10-98AB-FF1D44A5D518
CrashReporter Key:   7de926b94a450d65d5fbac872f8e146e39954611
Hardware Model:      iPhone8,1
Process:             HelloNSException [37262]
Path:                /private/var/containers/Bundle/Application/B6AC6F47-951D-4AD2-A728-3B84EB610D59/HelloNSException.app/HelloNSException
Identifier:          com.wc.HelloNSException
Version:             1 (1.0)
Code Type:           ARM-64 (Native)
Role:                Foreground
Parent Process:      launchd [1]
Coalition:           com.wc.HelloNSException [3791]


Date/Time:           2018-10-17 15:33:16.1141 +0800
Launch Time:         2018-10-17 15:33:14.0543 +0800
OS Version:          iPhone OS 11.4 (15F79)
Baseband Version:    4.60.00
Report Version:      104
```



* **Incident Identifier**：Client-assigned unique identifier for the report.

  唯一标识一次Crash Report，相当于标识一次crash事件

* **CrashReporter Key**：This is a client-assigned, anonymized, per-device identifier, similar to the UDID. This helps in determining how widespread an issue is.

  在相同设备上，相同的crash下，该值是一样的。可以使用该值，确定某个crash在多少台设备发生过。

* **Hardware Model**：This is the hardware on which a crash occurred, as available from the “hw.machine” sysctl. This can be useful for reproducing some bugs that are specific to a given phone model, but those cases are rare.

  设备型号，可以使用hw.machine

* **Code Type**：This is the target processor type. On an iOS device, this will always be ‘ARM’, even if the code is ARMv7 or ARMv7s.

* **OS Version**：The OS version on which the crash occurred, including the build number. This can be used to identify regressions that are specific to a given OS release. Note that while different models of iOS devices are assigned unique build numbers (eg, 9B206), crashes are only very rarely specific to a given OS build.

* **Report Version**：This opaque value is used by Apple to version the actual format of the report. As the report format is changed, Apple *may* update this version number.



### （2）分析堆栈的frame

frame是crash时调用栈的帧，有一定显示的格式。举个例子，如下

符号化之前

```
// Before symbolication
8 OurApp 0x000029d4 0x1000 + 6612
```

* column 1，the index of the stack frame in the stack trace
* column 2，the name of the binary the function belongs to
* column 3，the address of the function that was called in the process’ address space
* column 4，a base address for the library’s binary image and an offset



符号化之后

```
// After symbolication
8 OurApp 0x000029d4 -[OurAppDelegate applicationDidFinishLaunching:] (OurAppDelegate.m:128)
```

前3列都是一样的，只有最后一列有变化，变成文件名、行号和函数名。



### （3）Report的Exception部分

```
Exception Type:  EXC_CRASH (SIGABRT)
Exception Codes: 0x0000000000000000, 0x0000000000000000
Exception Note:  EXC_CORPSE_NOTIFY
Triggered by Thread:  0
```

Exception部分提供几个信息

* exception type，异常的类型
* exception codes，
* the index of the thread where the crash occurred，crash在哪个线程上

这里的Exception不是指Objective-C的exception，而是*Mach Exceptions*。另外，异常也可以指UNIX信号，例如SIGABRT。



##### 1. Signals

* SIGILL Attempted to execute an illegal (malformed, unknown, or privileged) instruction. This may occur if your code jumps to an invalid but executable memory address.

* SIGTRAP Mostly used for debugger watchpoints and other debugger features.

* SIGABRT Tells the process to abort. It can only be initiated by the process itself using the `abort()` C stdlib function. Unless you’re using `abort()` yourself, this is probably most commonly encountered if an `assert()` or `NSAssert()` fails.

* SIGFPE A floating point or arithmetic exception occurred, such as an attempted division by zero.

* SIGBUS A bus error occurred, e.g. when trying to load an unaligned pointer.

* SIGSEGV Sent when the kernel determines that the process is trying to access invalid memory, e.g. when an invalid pointer is dereferenced.


##### 2. Exceptions

* EXC_BAD_ACCESS Memory could not be accessed. The memory address where an access attempt was made is provided by the kernel. 
* EXC_BAD_INSTRUCTION Instruction failed. Illegal or undefined instruction or operand.
* EXC_ARITHMETIC For arithmetic errors.

除了Exception之外，还有一个关联的exception code用于进一步描述信息。举些例子，如下

`EXC_BAD_ACCESS` could point to a `KERN_PROTECTION_FAILURE`, which would indicate that the address being accessed is valid, but does not permit the required form of access (see[`osfmk/mach/kern_return.h`](http://fxr.watson.org/fxr/source/osfmk/mach/kern_return.h?v=xnu-2050.18.24)). 

`EXC_ARITHMETIC` exceptions will also include the precise nature of the problem as part of the exception code.



### （4）Report的Binary Images部分

```
Binary Images:
0x104910000 - 0x104917fff HelloNSException arm64  <060561111a403aa2a35970db520f2178> /var/containers/Bundle/Application/B6AC6F47-951D-4AD2-A728-3B84EB610D59/HelloNSException.app/HelloNSException
0x104c40000 - 0x104c7bfff dyld arm64  <b15e536a710732dabfafece44c5685e4> /usr/lib/dyld
0x182a37000 - 0x182a38fff libSystem.B.dylib arm64  <f3beb9029e533a899d794429fec383f9> /usr/lib/libSystem.B.dylib
...
```

Crash Report最下面有一个Binary Images部分，这里列出了app目前加载的所有binary image，以及它们在进程中的地址空间。每一条entry也有对应的UUID，它是由linker在编译时确定的，同时存储在Mach-O文件以及对应.dSYM文件中，位置在LC_UUID command中。根据UUID，可以正确匹配Mach-O到对应的.dSYM文件进行符号化。



举个例子，每一条entry格式，如下

```
0x35f62000 - 0x36079fff CoreFoundation armv7 /System/Library/Frameworks/CoreFoundation.framework/CoreFoundation
```

* column 1，binary image在进程中的地址范围，起始地址0x35f62000，结束地址0x36079fff
* column 2，binary image的名称
* column 3，binary image的架构，一般和设备架构是一致的
* column 4，binary image的本地路径 

当分析堆栈的frame时，会有一个内存中的函数地址，例如

```
9 CoreFoundation 0x35fee2ad ___CFRunLoopRun + 1269
```

如果想反汇编CFRunLoopRun函数，则需要计算它在CoreFoundation中偏移量，如下

```
0x35fee2ad - 0x35f62000 == 0x8c2ad
```

在本地反汇编CoreFoundation后，查看地址0x8c2ad的汇编指令就对应上CFRunLoopRun函数



### （5）Report的Register State部分

```
Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x0000000000000000   x1: 0x0000000000000000   x2: 0x0000000000000000   x3: 0x00000001c00f0137
    x4: 0x0000000182ab2abd   x5: 0x000000016b4ef3d0   x6: 0x000000000000006e   x7: 0xffffffffffffffec
    x8: 0x0000000008000000   x9: 0x0000000004000000  x10: 0x000000018352a110  x11: 0x0000000000000003
   x12: 0xffffffffffffffff  x13: 0x0000000000000001  x14: 0x0000000000000000  x15: 0x0000000000000010
   x16: 0x0000000000000148  x17: 0x0000000000000300  x18: 0x0000000000000000  x19: 0x0000000000000006
   x20: 0x00000001b5c78b40  x21: 0x000000016b4ef3d0  x22: 0x0000000000000303  x23: 0x00000001b5c78c20
   x24: 0x0000000000000001  x25: 0x00000001c0002090  x26: 0x0000000000000000  x27: 0x0000000000000001
   x28: 0x000000016b4efb20   fp: 0x000000016b4ef330   lr: 0x000000018352a288
    sp: 0x000000016b4ef300   pc: 0x00000001833892ec cpsr: 0x00000000
```

Register State部分描述crash时寄存器的状态，在某些情况下，这些寄存器信息是非常有用的。

举个例子，下面一行代码发生crash

```
new_data->ptr2 = [myObject executeSomeMethod:old_data->ptr2];
```

假设Crash产生SIGSEGV信号，推断是解引用NULL导致，但是这里有两个解引用，从调用栈上无法判断出来。这时可以通过Register State来分析。

```
str r0, [r1, #4]
```

假设crash发生在上面这行指令，r0和r1在使用。等价的C语言形式如下

```
*(r1 + 4) = r0;
```

这是个赋值语句，而且new_data是指向data_t结构体的指针，

```
typedef struct { void *ptr1, void *ptr2 } data_t;
```

所以，+4是可以看做是new_data->ptr2，这样可以推测new_data->ptr2被赋值时产生的crash，那么解引用应该发生在new_data。实际上，这时r1地址是0x00000000，加上4后也是一个无效的地址，对这个地址进行取值就会出现crash问题。





## 5、常见Crash类型防护



常见crash类型，有下面几种

* nil参数 

* mutable容器快速枚举时，被修改（可以被try-catch） 

* NaN参数 

CALayer的position(x,y)不允许有NaN值，否则会出现crash。（具体见HelloIssueUI_CALayerPositionNaNCrash） 



### （1）参数为nil导致crash的API



#### NSString

| 方法签名                                                     | 说明                       |
| ------------------------------------------------------------ | -------------------------- |
| `-[NSString hasPrefix:]`                                     |                            |
| `-[NSString appendString:]`                                  |                            |
| `-[NSMutableString replaceOccurrencesOfString:withString:options:range:]` | `withString:`参数不能为nil |



#### NSAttributedString

| 方法签名                                           | 说明                           |
| -------------------------------------------------- | ------------------------------ |
| `-[NSAttributedString initWithString:attributes:]` | `initWithString:`参数不能为nil |



#### NSURL

| 方法签名                    | 说明 |
| --------------------------- | ---- |
| `+[NSURL fileURLWithPath:]` |      |



#### NSRegularExpression

| 方法签名                                                     | 说明                                    |
| ------------------------------------------------------------ | --------------------------------------- |
| `-[NSRegularExpression enumerateMatchesInString:options:range:usingBlock:]` | `enumerateMatchesInString`参数不能为nil |



#### NSData

| 方法签名                                          | 说明                                  |
| ------------------------------------------------- | ------------------------------------- |
| `+[NSData dataWithContentsOfFile:options:error:]` | `dataWithContentsOfFile`参数不能为nil |



#### GCD

| 方法签名                           | 说明                |
| ---------------------------------- | ------------------- |
| `dispatch_async(<not nil>, {...})` | 第一个参数不能为nil |



#### UIGestureRecognizer

| 方法签名                                                 | 说明          |
| -------------------------------------------------------- | ------------- |
| `-[UIGestureRecognizer requireGestureRecognizerToFail:]` | 参数不能为nil |







## 6、Crash捕获后程序保活问题（TODO）

![main thread crash - call stack](/Users/wesley_chen/GitHub_Projects/HelloProjects/HelloNSException/images/main%20thread%20crash%20-%20call%20stack.png)



## 7、Crash日志符号化

Crash日志符号化，有几种方式

* Xcode的View Device Logs，将Crash日志拖到左侧的日志列表中，Xcode自动符号化
* 手动调用atos命令
* 手动调用symbolicatecrash脚本



### （1）atos命令

atos用法，如下

```shell
Usage: atos [-p pid] [-o executable] [-f file] [-s slide | -l loadAddress] [-arch architecture] [-printHeader] [-fullPath] [address ...]
```

常见选项，如下

* -o，指定符号文件
* -l，某个镜像(image)的加载地址，该地址可以在Crash日志的Binary Images部分找到
* address，每个函数符号都是一个地址，可以传入多个地址

举个例子，如下

```shell
$ atos -o HelloNSException.app.dSYM/Contents/Resources/DWARF/HelloNSException -l 0x1029a0000 0x19e9b098c 0x19e6d90a4 0x19ea063f8 0x19ea05a8c 0x19e887fc0 0x1029ab524 0x1029ae868 0x1a2b84cf0 0x1a2b8480c 0x1a2b84f0c 0x1a29c7b98 0x1a29b77c0 0x1a29e7594 0x19e92dc48 0x19e928b34 0x19e929100 0x19e9288bc 0x1a8794328 0x1a29be6d4 0x1029a5f68 0x19e7b3460 
0x19e9b098c
0x19e6d90a4
0x19ea063f8
0x19ea05a8c
0x19e887fc0
+[WCCrashCaseTool makeCrashWithNilParameter] (in HelloNSException) (WCCrashCaseTool.m:16)
-[BaseTableViewController tableView:didSelectRowAtIndexPath:] (in HelloNSException) (BaseTableViewController.m:52)
0x1a2b84cf0
0x1a2b8480c
0x1a2b84f0c
0x1a29c7b98
0x1a29b77c0
0x1a29e7594
0x19e92dc48
0x19e928b34
0x19e929100
0x19e9288bc
0x1a8794328
0x1a29be6d4
main (in HelloNSException) (main.m:14)
0x19e7b3460
```

说明

> 由于-l指定的加载地址是HelloNSException的加载地址，所以atos只能解析出HelloNSException镜像中的函数地址对应的符号。



### （2）symbolicatecrash脚本

#### a. 检查系统符号文件

如果要符号化系统的符号，需要检查系统符号文件是否在本地路径`~/Library/Developer/Xcode/iOS DeviceSupport`中。如果没有，需要从真机中获取，还有其他方法[^4]可以获取系统符号文件。



#### b. 执行symbolicatecrash脚本

使用下面的命令找到symbolicatecrash脚本的位置

```shell
$ find /Applications/Xcode.app -name symbolicatecrash -type f
```

一般会找到多个路径，但实际对应的是同一个文件。

> symbolicatecrash脚本是Perl语言编写的



可以直接使用下面的路径，如下

```shell
/Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Resources/symbolicatecrash
```



然后配置DEVELOPER_DIR环境变量，使用symbolicatecrash脚本符号化crash文件[^3]，如下

```shell
$ export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
$ /Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Resources/symbolicatecrash 1.crash > 1.log
```



#### c. 符号化app的符号

如果要符号化app的符号，使用`-d`选项指定dSYM路径，如下

```shell
$ /Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Resources/symbolicatecrash log.crash -d YourApp.app.dSYM > result.log
```





## 8、Watchdog Terminations[^2]













## Reference

[^1]: https://www.plausible.coop/blog/?p=176 "Exploring iOS Crash Reports"

[^2]:https://developer.apple.com/documentation/xcode/diagnosing_issues_using_crash_reports_and_device_logs/identifying_the_cause_of_common_crashes/addressing_watchdog_terminations

[^3]:https://www.infoq.cn/article/jltuf3pgfjv6ovjzu1sq
[^4]:https://zuikyo.github.io/2016/12/18/iOS%20Crash%E6%97%A5%E5%BF%97%E5%88%86%E6%9E%90%E5%BF%85%E5%A4%87%EF%BC%9A%E7%AC%A6%E5%8F%B7%E5%8C%96%E7%B3%BB%E7%BB%9F%E5%BA%93%E6%96%B9%E6%B3%95/



