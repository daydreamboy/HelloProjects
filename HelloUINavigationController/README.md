# HelloUINavigationController

[TOC]



## 1、UINavigationController





## 2、UINavigationBar



### （1）UINavigationBar的属性



| 属性         | 说明                                                         |
| ------------ | ------------------------------------------------------------ |
| tintColor    | 修改返回箭头的颜色。默认值nil。                              |
| barTintColor | 修改导航栏的颜色，必须和translucent=NO一起使用才生效。默认值nil。 |
| shadowImage  | 修改导航栏下面的分割线（hair line）。在iOS 11+上可以单独使用该属性，而且考虑shadowImage的大小。而iOS 10以及以下必须和setBackgroundImage:forBarMetrics:方法同时使用才能生效，需要自定义backgroundImage，而且忽略shadowImage的大小，总是1px高度。 |



### （2）自定义UINavigationBar



UINavigationController提供下面的API，允许传入UINavigationBar的子类，来实现导航栏定制

```objective-c
- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass;
```



extendedLayoutIncludesOpaqueBars=YES，对当前viewController的view有效。如果parent和child的关系，需要都设置。





### （3）UINavigationBar常见问题



#### a. UIBarButtonSystemItemFixedSpace的width问题

​       在iOS 11+上设置UIBarButtonSystemItemFixedSpace的width为负数不在起作用[^1]，可以继承UINavigationBar，在子类设置UINavigationBar所有subview的layoutMargin。

​       这种方法对CustomView方式初始化的UIBarButtonItem，在左边和右边的，用UIBarButtonSystemItemFixedSpace调节都是有效的。但是对initWithBarButtonSystemItem方式初始化的UIBarButtonItem，在左边的UIBarButtonItem，用UIBarButtonSystemItemFixedSpace调节无效。

注意

> 在iOS 13+设置UINavigationBar下面的subview的layoutMargins，会导致异常



#### b. 设置translucent为NO导致View下移

​      在导航栈中，从ViewController A (translucent=YES) 压入ViewController B (translucent=NO) ，由于UINavigationBar是共用的，导致返回到ViewController A时，UINavigationBar是不透明的，系统对于不透明的UINavigationBar，会自动将ViewController的view下移到UINavigationBar的下面。

> 示例代码，见NavRootViewControllerWithIssueTranslucentIsNO









## 3、UIBarButtonItem





### （1）UIBarButtonItem在iOS 11+上的改动



| 改动点                                 | iOS 10-                        | iOS 11+                            |
| -------------------------------------- | ------------------------------ | ---------------------------------- |
| -[UIBarButtonItem initWithCustomView:] | customView的宽度和高度是有效的 | customView的高度被忽略，仅宽度有效 |











## Reference

[^1]: https://stackoverflow.com/questions/45544961/negative-spacer-for-uibarbuttonitem-in-navigation-bar-on-ios-11 







