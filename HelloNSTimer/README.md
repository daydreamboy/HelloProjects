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

* NSTimer需要一个live状态的NSRunLoop，即一个RunLoop一直保持运行，用于执行timer事件。主线程中NSRunLoop总是运行中，但是其他线程中的NSRunLoop默认不是运行状态，需要手动调用run方法，让NSRunLoop运行起来[^1]。



### （3）Timer的三种创建方式

NSTimer的API提供三种创建NSTimer对象的方式，如下

* 使用`+[scheduledTimerWithTimeInterval:XXX]`系列方法
  * 类方法创建NSTimer对象，并将NSTimer对象加入到当前线程的RunLoop的default mode（NSDefaultRunLoopMode）中。

* 使用`+[timerWithTimeInterval:XXX]`系列方法
  * 类方法创建NSTimer对象，需要手动调用NSRunLoop的`-[NSRunLoop addTimer:forMode:]`方法，将NSTimer对象加入到
* 使用`-[initWithFireDate:XXX]`系列方法











### （4）Timer的tolerance属性







NSTimer提供两种方式创建Timer，如下

* scheduled方式，使用`+[scheduledTimerWithTimeInterval:XXX]`系列方法，返回timer对象。该方式无需手动加到当前 调用fire方法触发timer，RunLoop自动会触发timer的回调。
* 非scheduled方式，使用`+[timerWithTimeInterval:XXX]`或者`-[]`



## References

[^1]:<http://www.acttos.org/2016/08/NSTimer-and-GCD-Timer-in-iOS/>



