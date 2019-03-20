# Thread
[TOC]

## 1、POSIX Thread



* pthread_main_np，返回非0表示当前线程是主线程

```objective-c
/* returns non-zero if the current thread is the main thread */

__API_AVAILABLE(macos(10.4), ios(2.0))

int	pthread_main_np(void);
```



## 2、NSThread

NSThread是官方提供多线程编程的类，编程范式[^1]一般如下

```objective-c
- (void)someActionMethod:(id)sender {
    // 创建一个线程并启动它
    [NSThread detachNewThreadSelector:@selector(longCode) toTarget:self withObject:nil];
}

// 线程的entrance方法。如果开启多个线程，该方法可以被多个线程同时执行
- (void)longCode {
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    BOOL keepGoing = YES;

    while ( keepGoing) {
        // Do something here that will eventually stop by
        // setting keepGoing to NO
    }

    [pool release];
}
```



注意：

> 使用NSAutoreleasePool是必要的，方便在线程结束时可以自动回收对象



### （1）exit方法

NSThread的`+[NSThread exit`]方法，用于当前线程退出。一般来说，线程执行代码结束后会退出，但是某些情况下，可以使用exit方法退出。举个伪代码，如下

```objective-c
- (void)longCode {
  NSAutoreleasePool *pool;
  pool = [[NSAutoreleasePool alloc] init];
  BOOL exitEarly = NO;

  while ( YES ) {
    // Your code here, which may set exitEarly = YES

    if ( exitEarly ) {
      [pool release];
      [NSThread exit];
    }

    [pool release];
}
```



### （2）sleepUntilDate方法和sleepForTimeInterval方法

NSThread支持线程休眠，可以使用+[NSThread sleepUntilDate:]方法和+[NSThread sleepForTimeInterval:]方法。举个伪代码，如下

```objective-c
- (void)longCode {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    BOOL keepGoing = YES;

    while ( keepGoing ) {
        // Put the thread to sleep for 10 seconds
        NSDate *d = [NSDate dateWithTimeIntervalFromNow:10.0];
        [NSThread sleepUntilDate:d];

        // Do something here that will eventually stop by
        // setting keepGoing to NO
    }

    [pool release];
}
```



## 3、NSLocking

`NSLocking`是一个协议，NSLock、NSRecursiveLock、NS







## 4、常用技巧

### （1）判断当前线程是否是主线程

| 方式                        | 说明                                                      |
| --------------------------- | --------------------------------------------------------- |
| `+[NSThread isMainThread]`  | 返回YES，表示当前线程是主线程，否则返回NO                 |
| `int pthread_main_np(void)` | 返回非0表示当前线程是主线程。头文件`#include <pthread.h>` |



## References

[^1]: [http://etutorials.org/Programming/Cocoa/Part+I+Introducing+Cocoa/Chapter+2.+Foundation/2.9+Threaded+Programming/](http://etutorials.org/Programming/Cocoa/Part+I+Introducing+Cocoa/Chapter+2.+Foundation/2.9+Threaded+Programming/)