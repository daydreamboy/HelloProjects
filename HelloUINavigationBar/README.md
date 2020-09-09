# HelloUINavigationBar
[TOC]



## 1、UINavigationBar



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









## 2、UIBarButtonItem





### （1）UIBarButtonItem在iOS 11+上的改动



| 改动点                                 | iOS 10-                        | iOS 11+                            |
| -------------------------------------- | ------------------------------ | ---------------------------------- |
| -[UIBarButtonItem initWithCustomView:] | customView的宽度和高度是有效的 | customView的高度被忽略，仅宽度有效 |







## 3、UINavigationBar常见问题



### （1）UIBarButtonSystemItemFixedSpace的width问题

​       在iOS 11+上设置UIBarButtonSystemItemFixedSpace的width为负数不在起作用[^1]，可以继承UINavigationBar，在子类设置UINavigationBar所有subview的layoutMargin。

​       这种方法对CustomView方式初始化的UIBarButtonItem，在左边和右边的，用UIBarButtonSystemItemFixedSpace调节都是有效的。但是对initWithBarButtonSystemItem方式初始化的UIBarButtonItem，在左边的UIBarButtonItem，用UIBarButtonSystemItemFixedSpace调节无效。







## Reference

[^1]: https://stackoverflow.com/questions/45544961/negative-spacer-for-uibarbuttonitem-in-navigation-bar-on-ios-11 