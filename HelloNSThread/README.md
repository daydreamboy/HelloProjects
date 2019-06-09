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

  > 注意：其他没有获取锁的线程，释放锁则导致锁失效，线程同步存在问题。示例代码见**UseNSLockIssueWithUnpairLockUnlockViewController**

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

> NSLock的lock方法，不能在当前线程连续调用大于2次，否则当前线程会产生死锁。示例代码见**UseNSLockWithDeadlockViewController**。解决方法：可以换成NSRecursiveLock。



### （2）NSRecursiveLock

​        NSRecursiveLock和NSLock相比，它允许同一个线程连续调用lock方法多次而且不会死锁，当然unlock方法也需要配对使用。在某些递归调用，并且需要加锁的情况，NSRecursiveLock是更好的选择。

举个例子，如下

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    self.rLock = [[NSRecursiveLock alloc] init];
    self.rLock.name = @"My Recursive Lock";
    
    // Note: random json data from https://www.json-generator.com/
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"randomJSON" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    [NSThread detachNewThreadSelector:@selector(printJSONObjectRecursively:) toTarget:self withObject:JSONObject];
    [NSThread detachNewThreadSelector:@selector(printJSONObjectRecursively:) toTarget:self withObject:JSONObject];
}

- (void)printJSONObjectRecursively:(id)JSONObject {
    [self.rLock lock]; // Note: Ok, lock again without unlock is safe for the same thread
    
    if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in [(NSDictionary *)JSONObject allKeys]) {
            [self printJSONObjectRecursively:JSONObject[key]];
        }
    }
    else if ([JSONObject isKindOfClass:[NSArray class]]) {
        for (id object in JSONObject) {
            [self printJSONObjectRecursively:object];
        }
    }
    else {
        printf("Thread %p print: <%p: %s>\n", [NSThread currentThread], JSONObject, [JSONObject description].UTF8String);
        usleep(1);
    }
    
    [self.rLock unlock];
}
```

这里printJSONObjectRecursively:方法有一个递归调用，单个线程调用会递归，多个线程调用该方法需要同步（因为有个共享变量JSONObject），因此使用NSRecursiveLock是合适的。

示例代码见**UseNSRecursiveLockViewController**



### （3）NSConditionLock

​        NSConditionLock提供根据某个条件进行加锁的能力，这里的条件对应的是NSConditionLock的condition属性，它是NSInteger类型。

​        带有condition参数的和不带condition参数的API，对比如下

| 有condition参数                  | 说明                                       | 对比              | 说明                     |
| -------------------------------- | ------------------------------------------ | ----------------- | ------------------------ |
| `lockWhenCondition:`             | 当满足条件时，尝试获取锁                   | `lock`            | 不受条件限制，尝试获取锁 |
| `lockWhenCondition: beforeDate:` |                                            | `lockBeforeDate:` |                          |
| `tryLockWhenCondition:`          |                                            | `tryLock`         |                          |
| `unlockWithCondition:`           | 释放锁同时设置条件                         | `unlock`          |                          |
| `initWithCondition:`             | 初始化条件的NSInteger值。如果不设置默认为0 | `init`            |                          |



NSConditionLock比较适合生产者和消费者情况[^3]，示例代码见**UseNSConditionLockViewController**



## 4、常用技巧

### （1）判断当前线程是否是主线程

| 方式                        | 说明                                                      |
| --------------------------- | --------------------------------------------------------- |
| `+[NSThread isMainThread]`  | 返回YES，表示当前线程是主线程，否则返回NO                 |
| `int pthread_main_np(void)` | 返回非0表示当前线程是主线程。头文件`#include <pthread.h>` |



### （2）同步工具[^4]



| 方式                                   | 说明 |
| -------------------------------------- | ---- |
| Atomic Operations                      |      |
| Memory Barriers and Volatile Variables |      |
| Locks                                  |      |
| Conditions                             |      |
| Perform Selector Routines              |      |



### （3）测试锁的性能[^5]

参考文章[^5]提供的测试方式，针对两种场景（并发写、并发写和读），测试下面几种同步方式的性能。

* NSLock
* NSRecursiveLock
* @synchronized
* 串行dispatch_queue
* 并行dispatch_queue（使用dispatch_barrier_async写）
* C++封装pthread_mutex_t的scoped锁
* pthread读写锁（pthread_rwlock_t）
* 信号量（dispatch_semaphore_t）
* 互斥量（pthread_mutex_t）



并发写，测试数据（iPhone 6s）

| 同步方式                                           | 平均耗时(ns) |
| -------------------------------------------------- | ------------ |
| NSLock                                             | **8024**     |
| NSRecursiveLock                                    | **5571**     |
| @synchronized                                      | **9907**     |
| 串行dispatch_queue                                 | **8997**     |
| 并行dispatch_queue（使用dispatch_barrier_async写） | **3106**     |
| C++封装pthread_mutex_t的scoped锁                   | **11108**    |
| pthread读写锁（pthread_rwlock_t）                  | **7420**     |
| 信号量（dispatch_semaphore_t）                     | **6628**     |
| 互斥量（pthread_mutex_t）                          | **10437**    |

示例代码见Tests_synchronize_concurrent_writes.m



并发写和读，测试数据（iPhone 6s）

| 同步方式                                           | 平均耗时(ns) |
| -------------------------------------------------- | ------------ |
| NSLock                                             | **218967**   |
| NSRecursiveLock                                    | **207352**   |
| @synchronized                                      | **258328**   |
| 串行dispatch_queue                                 | **163020**   |
| 并行dispatch_queue（使用dispatch_barrier_async写） | **48184**    |
| C++封装pthread_mutex_t的scoped锁                   | **116567**   |
| pthread读写锁（pthread_rwlock_t）                  | **80099**    |
| 信号量（dispatch_semaphore_t）                     | **173966**   |
| 互斥量（pthread_mutex_t）                          | **102997**   |

示例代码见Tests_synchronize_concurrent_reads_writes.m



### （4）dispatch_benchmark[^6]

GCD提供dispatch_benchmark函数，这个函数不是public API，属于私有API，但是可以用于测试。

dispatch_benchmark函数的签名，如下

`uint64_t dispatch_benchmark(size_t count, void (^block)(void));`

> 第一个参数count，是执行block的总次数
>
> 第二个参数block，是放置测试代码
>
> 返回值，是执行block的平均时间
>
> 注意：block中一般可以使用@autoreleasepool块释放每次block产生的对象，减少footprint

编程范式，如下

```objective-c
extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));

uint64_t t_0 = dispatch_benchmark(iterations, ^{
    @autoreleasepool {
        // Test code
    }
});
NSLog(@"Avg. Runtime: %llu ns", t_0);
```

示例代码见Tests_benchmarking.m



## References

[^1]: [http://etutorials.org/Programming/Cocoa/Part+I+Introducing+Cocoa/Chapter+2.+Foundation/2.9+Threaded+Programming/](http://etutorials.org/Programming/Cocoa/Part+I+Introducing+Cocoa/Chapter+2.+Foundation/2.9+Threaded+Programming/)
[^2]:http://softpixel.com/~cwright/programming/threads/threads.cocoa.php
[^3]:<http://mirror.informatimago.com/next/developer.apple.com/documentation/Cocoa/Conceptual/Multithreading/Tasks/usinglocks.html>
[^4]: <https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/ThreadSafety/ThreadSafety.html>
[^5]: <http://www.lukeparham.com/blog/2018/6/3/comparing-synchronization-strategies>

[^6]: https://nshipster.com/benchmarking/



