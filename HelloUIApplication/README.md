# HelloUIApplication
[TOC]



## 1、使用UIApplication子类



## 2、关于UIEvent



## 3、关于UITouch





## 4、app常用的系统事件

（1）模拟触发Memory warning通知





## 5、检测Shake设备的手势

UIResponder提供检测动作的API，如下

```objective-c
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event;
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event;
```

当motion的值为UIEventSubtypeMotionShake时，表示设备被摇晃（Shake）。当检测到动作开始和结束时，会分别调用motionBegan:withEvent:和motionEnded:withEvent:方法。

而且motion事件会首先发给第一响应者，然后通过事件链向上传递，即通过nextResponder一直找到UIApplication对象。

官方文档，描述如下

> Motion events are delivered initially to the first responder and are forwarded up the responder chain as appropriate.



由于UIKit中UIResponder的子类很多，例如UIView、UIViewController、UIWindow，甚至UIApplication都是UIResponder的子类。因此检查Shake手势的方式很多。这篇SO[^1]上介绍了好几种方式，这里大体分为两类方式

* 局部检测Shake手势
* 全局检测Shake手势



### （1）局部检测Shake手势

局部检测Shake手势，即只能进入某个特定界面，才能检测，而且需要直接调用becomeFirstResponder，或者该对象在响应链上。



#### a. 使用UIView和UIViewController的子类

由于UIView和UIViewController都是UIResponder的子类，这里以UIView为例

```objective-c
@interface DetectShakeView : UIView
@end
@implementation DetectShakeView
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"detected shake in custom UIView");
    }
    
    [super motionEnded:motion withEvent:event];
}
@end
  
@implementation DetectShakeMotionViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.shakeView becomeFirstResponder];
}
@end
```

UIView的子类实现canBecomeFirstResponder和motionEnded:withEvent:方法，然后在适当的时机，UIView的子类对象调用becomeFirstResponder方法。

注意

> 1. 一定要调用becomeFirstResponder方法，否则motionEnded:withEvent:方法不会被回调
> 2. motionEnded:withEvent:方法的实现，一般需要调用super方法，这样响应链不会被截断。比如DetectShakeView中motionEnded:withEvent:方法里面，没有调用super方法，这样UIViewController中的motionEnded:withEvent:方法，则不会被调用



#### b. 使用UIWindow的子类

​      UIWindow也是UIResponder的子类，可以自定义UIWindow子类，然后赋值到UIApplicationDelegate的window属性。由于window属性，它比较特殊，可以不用调用becomeFirstResponder方法。即使当前app中没有第一响应者，UIKit也会调用UIWindow的motionEnded:withEvent:方法。

举个例子，如下

```objective-c
@implementation MyWindow
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"detected shake in custom UIWindow");
    }
}
@end
```

实现UIWindow的子类，然后子类实现motionEnded:withEvent:方法。

注意

> 1. 上面的方法，必须是UIApplicationDelegate的window换成自定义UIWindow子类，否则还是需要调用becomeFirstResponder方法
> 2. 这个方法，也有缺点，就如果某个UIViewController或者UIViewController.view实现了motionEnded:withEvent:方法，但是没有调用super方法，该UIWindow的子类也无法检测到Shake手势



### （2）全局检测Shake手势



#### a. 使用UIApplication的子类

TODO





## References

[^1]:https://stackoverflow.com/questions/150446/how-do-i-detect-when-someone-shakes-an-iphone/2405692











## Reference





