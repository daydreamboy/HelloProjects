# HelloUINavigationBar
---

UINavigationBar的属性

* tintColor，修改返回箭头的颜色。默认值nil。
* barTintColor，修改导航栏的颜色，必须和translucent=NO一起使用才生效。默认值nil。
* shadowImage，修改导航栏下面的分割线（hair line）。在iOS 11+上可以单独使用该属性，而且考虑shadowImage的大小。而iOS 10以及以下必须和setBackgroundImage:forBarMetrics:方法同时使用才能生效，需要自定义backgroundImage，而且忽略shadowImage的大小，总是1px高度。

