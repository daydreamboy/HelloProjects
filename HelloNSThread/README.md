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

NSThread支持线程休眠，可以使用`+[NSThread sleepUntilDate:]`方法和`+[NSThread sleepForTimeInterval:]`方法。举个伪代码，如下

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

`NSLocking`是一个协议，NSLock、NSRecursiveLock、NSConditionLock都实现了该协议的lock和unlock方法。



### （1）NSLock

​        NSLock是最简单的锁，NSRecursiveLock和NSConditionLock在它的基础上增加了其他功能。这里介绍NSLock最基础的方法[^2]（NSRecursiveLock和NSConditionLock也同样适用）。

* `[myLock lock]`（示例代码见**UseNSLockViewController**）

  * 当前线程获取锁并且成功，当前线程继续执行；其他线程调用该方法，会被阻塞住，直到当前线程释放锁，其他线程才继续执行该方法后的代码。
  * 当前线程获取锁但是失败，则当前线程会被阻塞

* `[myLock unlock]`，获取锁的线程负责释放锁。

  > 注意：其他没有获取锁的线程，释放锁则导致锁失效，线程同步存在问题。

* `[myLock tryLock]`，当前线程尝试获取锁，获取成功返回YES；获取失败，则返回NO。（示例代码见**UseNSLockWithTryLockViewController**）

  > tryLock方法和lock方法，区别在于当获取锁失败时，lock方法是阻塞的，而tryLock方法，无论获取锁成功还是失败，都不是阻塞的

* `[myLock lockBeforeDate]`，当前线程在某个时间之前都是一直获取锁，而且是阻塞的。如果超过这个时间后或者在规定时间内成功获取到锁，当前线程继续执行。返回YES，在超时之前获取到锁；返回NO，时间超时。（示例代码见**UseNSLockWithTimeoutViewController**）



tryLock方法和lockBeforeDate方法的编程范式，大致如下

```objective-c
if ([myLock tryLock]) {
    // do something on shared data
    [myLock unlock];
}
else {
    // do other thing
}

NSTimeInterval timeInUSecond = 1 / 1000.0 / 1000.0 * 20;
NSDate *deadline = [NSDate dateWithTimeInterval:timeInUSecond sinceDate:[NSDate date]];
if ([myLock lockBeforeDate:deadline]) {
    // do something on shared data
    [myLock unlock];
}
else {
    // do other thing
}
```



注意：

> NSLock的lock方法，不能在当前线程连续调用大于2次，否则当前线程会产生死锁。示例代码见**UseNSLockWithDeadlockViewController**。解决该方法，可以换成NSRecursiveLock。



## 4、常用技巧

### （1）判断当前线程是否是主线程

| 方式                        | 说明                                                      |
| --------------------------- | --------------------------------------------------------- |
| `+[NSThread isMainThread]`  | 返回YES，表示当前线程是主线程，否则返回NO                 |
| `int pthread_main_np(void)` | 返回非0表示当前线程是主线程。头文件`#include <pthread.h>` |



## References

[^1]: [http://etutorials.org/Programming/Cocoa/Part+I+Introducing+Cocoa/Chapter+2.+Foundation/2.9+Threaded+Programming/](http://etutorials.org/Programming/Cocoa/Part+I+Introducing+Cocoa/Chapter+2.+Foundation/2.9+Threaded+Programming/)
[^2]:http://softpixel.com/~cwright/programming/threads/threads.cocoa.php