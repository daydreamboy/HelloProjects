## HelloUIGestureRecognizer

[TOC]

---

### 1、比较TapGesture和UIButton的UIControlEventTouchUpInside事件

TapGesture的响应事件要比UIButton的UIControlEventTouchUpInside优先级要高一些。

参考例子：TapGestureVSButtonClickViewController



### 2、父子视图都添加UITapGesture

当父子视图都添加UITapGesture，点击子视图，触发子视图的回调；点击父视图，触发父视图的回调。

如果父视图需要知道子视图的点击事件，则可以用下面两种方式：

* 父视图的手势，实现delegate的gestureRecognizerShouldBegin:方法
* 父视图实现touchBegin/.../touchEnd方法，自己判断touchUpInside事件





