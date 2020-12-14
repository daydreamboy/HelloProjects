# NSNotification

[TOC]

## 1、介绍Notification

通知是Foundation提供的通信机制，主要有下面几个类组成

| 类                              | 作用                                           | 说明 |
| ------------------------------- | ---------------------------------------------- | ---- |
| NSNotification                  | 通知的模型，主要有name、object和userInfo等参数 |      |
| NSNotificationCenter            | 通知中心，负责发送和接收通知，单进程内通信     |      |
| NSDistributedNotificationCenter | MacOS上的通知中心，支持多进程之间通信          |      |
| NSNotificationQueue             | 通知中心的通知buffer                           |      |



### （1）NSNotificationCenter

每个iOS进程默认有个一个通知中心，可以通过NSNotificationCenter的类方法defaultCenter来获取。

值得注意的是，NSNotificationCenter发送通知都是同步调用的，当所有注册的观察者的方法都被调用后，该通知才算发送完成。

官方文档描述[^1]，如下

> A notification center delivers notifications to observers synchronously. In other words, when posting a notification, control does not return to the poster until all observers have received and processed the notification.



另外，即使观察者注册到通知中心在其他线程，但是观察者处理通知的方法，都在NSNotificationCenter发送通知的调用线程中触发，因为上面也提到NSNotificationCenter发送通知是同步的。

官方文档描述[^1]，如下

> In a multithreaded application, notifications are always delivered in the thread in which the notification was posted, which may not be the same thread in which an observer registered itself.



#### a. 发送通知

NSNotificationCenter提供下面3个方法，用于发送通知

```objective-c
- (void)postNotification:(NSNotification *)notification;
- (void)postNotificationName:(NSNotificationName)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
- (void)postNotificationName:(NSNotificationName)aName object:(id)anObject;
```

一般可以直接使用后面2个方法，而不用自己构造NSNotification对象。

值得说明的是，object参数表示通知的发送者，该通知的发送者，可以是调用postNotification系列方法的调用者，也是可以其他对象。一般将object参数设置为nil。



#### b. 注册和解绑观察者

NSNotificationCenter注册观察者的API，如下

```objective-c
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject;
// 该方法的返回值是一个observer对象
- (id<NSObject>)addObserverForName:(NSNotificationName)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block;
```



值得说明的，注册观察者实际上可以按照2个维度来注册多个观察者

* name，通知名
* object，通知发送者。如果nil，则该通知名下所有发送者的通知都监听



说明

> addObserverForName:object:queue:(NSOperationQueue *)queue usingBlock:方法，也需要手动移除观察者，因此该方法返回的对象，需要调用者持有。
>
> 官方文档，给出下面的使用示例，如下
>
> ```objective-c
> NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
> NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
> self.localeChangeObserver = [center addObserverForName:NSCurrentLocaleDidChangeNotification object:nil
>     queue:mainQueue usingBlock:^(NSNotification *note) {
>         NSLog(@"The user's locale changed to: %@", [[NSLocale currentLocale] localeIdentifier]);
> }];
> 
> // 解绑观察者
> NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
> [center removeObserver:self.localeChangeObserver];
> ```
>
> 



NSNotificationCenter解绑观察者的API，如下

```objective-c
// 按照name和object维度解绑观察者
- (void)removeObserver:(id)observer name:(NSNotificationName)aName object:(id)anObject;
// 通知中心直接移除观察者
- (void)removeObserver:(id)observer;
```



## 2、通知使用Tips

### （1）一次性通知

一次性通知，即在处理完通知后，就解除继续对该通知的监听。

官方文档，给下面的使用示例，如下

```objective-c
NSNotificationCenter * __weak center = [NSNotificationCenter defaultCenter];
id __block token = [center addObserverForName:@"OneTimeNotification"
                                       object:nil
                                        queue:[NSOperationQueue mainQueue]
                                   usingBlock:^(NSNotification *note) {
                                       NSLog(@"Received the notification!");
                                       [center removeObserver:token];
                                   }];
```















## References

[^1]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Notifications/Articles/NotificationCenters.html









