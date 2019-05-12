# NSTimer

[TOC]

## 1、介绍NSTimer

​       NSTimer是iOS进行定时任务常见方式之一。除了NSTimer，还可以使用GCD的`dispatch_after`函数以及dispatch_source创建GCD Timer。



### （1）Timer和RunLoop

​       NSTimer是基于RunLoop工作的。当前线程（一般是主线程，非主线程的Timer后面介绍）中的RunLoop加入了NSTimer对象后，则该RunLoop强持有NSTimer对象。因此不需要持有NSTimer对象，除非需要invalidate的情况。

官方描述，如下

> Timers work in conjunction with run loops. Run loops maintain strong references to their timers, so you don’t have to maintain your own strong reference to a timer after you have added it to a run loop. 



​        值得注意的是，NSTimer不是实时的，当NSTimer加入到RunLoop中到Timer触发存在延迟的情况。常见的例子是，当UITableView一直处于Dragging状态（手指按住拖动不松手），默认创建的NSTimer是被阻塞的。

官方文档指出，存在两种情况，Timer触发会被延迟

* Timer触发之前有一个长时间的RunLoop任务调用
* RunLoop的特定mode下没有监听Timer事件，直到定时Timer下次触发前，才开始监听Timer事件

> A timer is not a real-time mechanism. If a timer’s firing time occurs during a long run loop callout or while the run loop is in a mode that isn't monitoring the timer, the timer doesn't fire until the next time the run loop checks the timer. Therefore, the actual time at which a timer fires can be significantly later. 



### （2）Timer分类

在NSTimer创建时可以通过`repeats`参数指定timer为重复定时或者一次定时。

* 重复定时timer
  * 无需手动调用fire方法触发timer，而且timer触发后自动将timer加入到相同的RunLoop中。
  * 即使手动调用fire方法触发timer后，也不影响重复定时timer的下一次触发。
  * 重复定时timer需要手动调用invalidate方法，将timer移出所在RunLoop

* 一次定时timer

  * timer触发后自动将timer移出所在的RunLoop，无需手动调用invalidate方法

  * 如果在timer触发之前，手动调用fire方法，则timer也自动调用invalidate方法

    > If the timer is non-repeating, it is automatically invalidated after firing, even if its scheduled fire date has not arrived.



使用NSTimer需要注意下面事项

* NSTimer调用invalidate方法，必须和NSTimer创建时是同一个线程，即NSTimer加入和移出RunLoop，都必须是同一个线程，否则invalidate方法有可能无效。

  > invalidate方法描述，如下
  >
  > You must send this message from the thread on which the timer was installed. If you send this message from another thread, the input source associated with the timer may not be removed from its run loop, which could prevent the thread from exiting properly.

* NSTimer的invalidate方法，是唯一将NSTimer移出RunLoop的方式。调用invalidate方法，在invalidate方法返回之前或者在更晚的时间点，RunLoop才会解除对NSTimer的引用。同时，也会解除对target和userInfo参数引用的对象。

  > This method is the only way to remove a timer from an [`NSRunLoop`](dash-apple-api://load?topic_id=1409898&language=occ) object. The `NSRunLoop` object removes its strong reference to the timer, either just before the [`invalidate`](dash-apple-api://load?request_key=hcaODPrPmP#dash_1415405) method returns or at some later point.
  >
  > If it was configured with target and user info objects, the receiver removes its strong references to those objects as well.

* NSTimer的invalidate方法调用后，该NSTimer对象不能再次复用

  > Once invalidated, timer objects cannot be reused.

* NSTimer需要一个live状态的NSRunLoop，即一个RunLoop一直保持运行，用于执行timer事件。主线程中NSRunLoop总是运行中，但是其他线程中的NSRunLoop默认不是运行状态，需要手动调用run方法，让NSRunLoop运行起来[^1]。



根据Timer是否是重复定时还是一次定时，以及是否自动schedule（见下面"*（3）Timer的三种创建方式*"小节），可以将Timer划分下面四类

| Repeated | Scheduled | Timer类型                    |
| -------- | --------- | ---------------------------- |
| NO       | NO        | 一次定时的NonScheduled Timer |
| NO       | YES       | 一次定时的Scheduled Timer    |
| YES      | NO        | 重复定时的NonScheduled Timer |
| YES      | YES       | 重复定时的Scheduled Timer    |



> 重复定时的Scheduled Timer，示例代码见**UseScheduledRepeatedTimerViewController**



### （3）Timer的三种创建方式

NSTimer的API提供三种创建NSTimer对象的方式，如下

* 使用`+[scheduledTimerWithTimeInterval:XXX]`系列方法
  * 类方法创建NSTimer对象（Scheduled Timer），并将NSTimer对象加入到当前线程的RunLoop的default mode（NSDefaultRunLoopMode）中。

* 使用`+[timerWithTimeInterval:XXX]`系列方法
  * 类方法创建NSTimer对象（NonScheduled Timer），需要手动调用NSRunLoop的`-[NSRunLoop addTimer:forMode:]`方法，将NSTimer对象加入到当前线程的RunLoop的default mode（NSDefaultRunLoopMode）中。
* 使用`-[initWithFireDate:XXX]`系列方法

  * 实例方法创建NSTimer对象（NonScheduled Timer），也需要手动调用NSRunLoop的`-[NSRunLoop addTimer:forMode:]`方法，将NSTimer对象加入到当前线程的RunLoop的default mode（NSDefaultRunLoopMode）中。





### （4）Timer的tolerance属性

​        iOS 7和macOS 10.9开始，NSTimer提供tolerance属性。目的在于系统利用该属性来优化节约能耗和提高timer响应度。指定tolerance属性，timer触发在**[指定时间,指定时间+tolerance]**这个区间触发。如果是重复定时timer，则下次触发时间是**触发时间+interval**，不会加上tolerance。tolerance属性，默认是0，但是系统保留对特定的timer设置tolerance属性的权利。

​        对应的官方描述，如下

> In iOS 7 and later and macOS 10.9 and later, you can specify a tolerance for a timer ([`tolerance`](dash-apple-api://load?request_key=hcaODPrPmP#dash_1415085)). This flexibility in when a timer fires improves the system's ability to optimize for increased power savings and responsiveness. The timer may fire at any time between its scheduled fire date and the scheduled fire date plus the tolerance. The timer doesn't fire before the scheduled fire date. For repeating timers, the next fire date is calculated from the original fire date regardless of tolerance applied at individual fire times, to avoid drift. The default value is zero, which means no additional tolerance is applied. The system reserves the right to apply a small amount of tolerance to certain timers regardless of the value of the [`tolerance`](dash-apple-api://load?request_key=hcaODPrPmP#dash_1415085) property.

​        可能会遇到一个问题：该设置tolerance为多少。官方文档，推荐设置tolerance为interval属性的10%，即如果重复定时timer的interval为1s，则tolerance设置100ms。

> As the user of the timer, you can determine the appropriate tolerance for a timer. A general rule, set the tolerance to at least 10% of the interval, for a repeating timer.

​        如果对是否设置tolerance属性抱着没有什么关系的态度，官方文档又强调即使设置很小的tolerance也会对应用使用系统的能耗有明显改善影响。如果对定时任务不要求那么实时，可以设置tolerance=interval*10%。

> Even a small amount of tolerance has significant positive impact on the power usage of your application.



## 2、使用NSTimer常见问题

​        由于NSTimer的实现机制以及较晚提供block回调方式的API，导致使用NSTimer会遇到一些问题，这里列举常见问题。

### （1）循环引用问题

使用重复定时的NSTimer，经常会遇见循环引用问题。常见代码如下

```objective-c
@interface TimerRetainCycleViewController ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TimerRetainCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)dealloc {
    NSLog(@"the bellow timer invalidate never called, because dealloc never called");
    [_timer invalidate];
}

- (void)timerFired:(NSTimer *)timer {
    NSLog(@"timerFired");
}

@end
```

示例代码见TimerRetainCycleViewController



​      如果将target传入weakSelf，将timer的属性修饰符换成weak是否解决循环引用问题呢？如下面代码所示。当然不行，原因这篇SO[^2]上有解释

```objective-c
@interface TimerRetainCycleWithWeakSelfViewController ()
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation TimerRetainCycleWithWeakSelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weak_self = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weak_self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)dealloc {
    NSLog(@"the bellow timer invalidate never called, because dealloc never called");
    [_timer invalidate];
}

- (void)timerFired:(NSTimer *)timer {
    NSLog(@"timerFired");
}

@end
```



针对上面循环引用问题，有几种解法[^2]

#### 1. 使用block方式的API

大致代码如下

```objective-c
@interface ViewController ()
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    typeof(self) __weak weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * timer) {
        [weakSelf timerTigger];
    }];
}

- (void)timerTigger {
    NSLog(@"timer fired");
}

- (void)dealloc {
    [self.timer invalidate];
}

@end
```



注意：NSTimer的带block参数的API，例如`+[NSTimer scheduledTimerWithTimeInterval:repeats:block:]`，都在iOS 10+才有，低版本系统不能使用。



#### 2. 使用GCD方式的timer

示例代码参考**CreateTimerDispatchSourceViewController**



#### 3. 不要在dealloc中调用NSTimer的invalidate方法

大致代码如下

```objective-c
@interface ViewController ()
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTigger:) userInfo:nil repeats:true];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self.timer invalidate];
}

- (void)timerTigger:(NSTimer *)timer {
    NSLog(@"do something");
}

@end
```

​        这种方式有一定局限性，即适用于可以在dealloc中调用invalidate方法之外的场景中，比如viewDidDisappear触发时就不需要timer定时了。



#### 4. 使用Wrapper类弱引用target对象（e.g. WCWeakProxy）

​       利用@property(weak)在对象释放时，也将weak属性进行引用解除，达到属性对象被释放的目的。WCWeakProxy参考YYKit代码，根据这个方式进行实现。

示例代码见**UseScheduledRepeatedTimerViewController**



### （2）创建非主线程的NSTimer







## References

[^1]:<http://www.acttos.org/2016/08/NSTimer-and-GCD-Timer-in-iOS/>
[^2]: <https://stackoverflow.com/questions/42930241/nstimer-with-weak-self-why-is-dealloc-not-called/42931729>



