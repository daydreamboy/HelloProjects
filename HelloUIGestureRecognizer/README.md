## HelloUIGestureRecognizer

[TOC]

---

### 1、UIGestureRecognizer vs. UIControlEvents

UIGestureRecognizer和UIControlEvents都可以用于处理某个控件的事件响应，但是两者有一定区别。

简单分析如下

| 区分点               | UIGestureRecognizer                                          | UIControlEvents                                           | 说明                                                         |
| -------------------- | ------------------------------------------------------------ | --------------------------------------------------------- | ------------------------------------------------------------ |
| 产生事件的对象不同   | UIView对象的事件                                             | UIControl对象的事件                                       | UIControl继承自UIView                                        |
| 事件回调的优先级     | 高                                                           | 低                                                        | 同一个控件的UIGestureRecognizer回调方法早于UIControlEvents事件回调方法 |
| 是否经过touchEnd方法 | UIGestureRecognizer内部判断是否是该手势并直接触发对应的回调方法 | UIControl在touchEnd方法中判断事件类型并触发对应的回调方法 |                                                              |



UIGestureRecognizer的回调方法，调用栈如下

![](images/UIGestureRecognizer回调方法的调用栈.png)



UIControlEvents事件的回调方法，调用栈如下

![](images/UIControlEvents事件回调方法的调用栈.png)

示例代码见**GestureRecognizerVSControlEventsViewController**



### 2、UIGestureRecognizer常用属性分析

#### （1）cancelsTouchesInView

`cancelsTouchesInView`属性默认值是YES。官方文档释义，如下

* 设置YES并手势被识别，pending中的touch事件不再发送给UIView，并且发送`touchesCancelled:withEvent:`消息给UIView。

* 设置NO或者手势不识别时，touch事件都会发送给UIView



> 这里touch事件指的是UIView的四个touch方法，touchesBegan/touchesMoved/touchesEnded/touchesCancalled



举个UIControl控件例子

​       UIButton有UIControlEventTouchUpInside事件，如果再添加一个UITapGestureRecognizer，由于UITapGestureRecognizer优先级高于UIControlEventTouchUpInside，并且`cancelsTouchesInView`默认为YES，则UIControlEventTouchUpInside事件的回调方法不触发，只触发UITapGestureRecognizer的回调方法。

​       如果将`cancelsTouchesInView`设置为NO，则UIControlEventTouchUpInside事件的回调方法和UITapGestureRecognizer的回调方法都触发，但还是先触发后者的回调方法。

示例代码见**GestureRecognizerVSControlEventsViewController**



举个自定义UIView的例子

当`cancelsTouchesInView`为YES，手势识别成功后，自定义UIView的touchesCancelled:withEvent:会被调用

当`cancelsTouchesInView`为NO，手势识别成功后，自定义UIView的touchesEnd:withEvent:会被调用

示例代码见**UseCancelsTouchesInViewViewController**



### 3、父子视图都添加UITapGesture

当父子视图都添加UITapGesture，点击子视图，触发子视图的回调；点击父视图，触发父视图的回调。

如果父视图需要知道子视图的点击事件，则可以用下面两种方式：

* 父视图的手势，实现delegate的gestureRecognizerShouldBegin:方法
* 父视图实现touchBegin/.../touchEnd方法，自己判断touchUpInside事件





