## HelloCrash


### 1. Exception vs Signal

Exception是在Objective-C中，主要API是NSException类；而Signal是操作系统级别，一般用于IPC（inter-process communication），主要是C API。可见Signal比Exception更加底层一些。

补充
>  
https://www.mikeash.com/pyblog/friday-qa-2013-01-11-mach-exception-handlers.html，提到Signal和Exception的区别

### 2. Crash的过程

简单来说，Crash是没有捕获的异常或者信号。CocoaWithLove的[这篇文章](https://www.cocoawithlove.com/2010/05/handling-unhandled-exceptions-and.html)提到Crash的来源。

* Crash是应用程序不能处理的信号（signal）或者异常（exception），不能处理的signal或来exception自三种地方：内核（kernel）、其他进程和应用程序自身。
* 常见导致crash的信号和异常
  - EXC\_BAD\_ACCESS，是Mach exception。如果没有在Mach内处理，将转成SIGBUS或者SIGSEGV信号
  - SIGABRT，是应用程序自身发出的，当NSException或者obj\_exception\_throw没有被捕获

### 3. Crash捕获

（1） NSUncaughtExceptionHandler，捕获异常

Objective-C提供两个C函数，如下

```
// handler类型
typedef void (NSException * _Nonnull) NSUncaughtExceptionHandler;

// 获取当前handler
NSUncaughtExceptionHandler * NSGetUncaughtExceptionHandler(void);

// 设置uncaught exception handler
void NSSetUncaughtExceptionHandler(NSUncaughtExceptionHandler *);
```

iOS app默认没有提供handler，开发者可以自己设置NSUncaughtExceptionHandler。常见的nil参数、数组越界可以通过这个handler捕获。

Apple文档对这个handler意思是，在程序结束之前，做日志操作。


（2）signal，捕获特定信号

signal是一个C函数，定义在`#include <sys/signal.h>`，如下

```
void	(*signal(int, void (*)(int)))(int);
```

signal函数用于配置当前进程，可以接收哪些信号，或者忽略哪些信号。

* 第一个参数，是信号值。例如SIGABRT（abort）、SIGILL（illegal instruction）、SIGSEGV（segmentation violation）、SIGFPE（floating point exception）、SIGBUS（bus error）、SIGPIPE（write on a pipe with no one to read it）等。这些值通过宏提供，也在`<sys/signal.h>`中。
* 第二个参数，是信号handler，类型是函数指针。如果handler指定不是函数指针，而是特定的宏（也是函数指针类型，定义在`<sys/signal.h>`中），如下
  * SIG\_DFL（default）代表默认handler，其实NULL。如果要注销掉handler，可以设置signal(SIGABRT, SIG_DFL)
  * SIG\_IGN（ignore）代表忽略特定的信号。
  * SIG\_HOLD和SIG\_ERR

信号的handler的类型是void (handler)(int)，带一个int参数对应的是信号值。

signal函数的返回值是上一个handler，也是就被替换的handler

（3）其他方式

* main函数添加try-catch

```
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

不推荐使用这种方式，所有exception被catch住，跳出了主线程的runloop，应用已经不能存活。在catch块除了记录日志，不能做任何UI相关事情，而且不会触发NSUncaughtExceptionHandler句柄。


### 4. Crash捕获后程序保活问题


![main thread crash - call stack](images/main thread crash - call stack.png)