## UI显示问题

### 测试环境
* iPhone 6S, iOS 10.3.2
* Xcode 9

### 复现过程

点击按钮“Send SMS”。原因：系统view controller的`canBecomeFirstResponder`方法被hook，然后修改了原有逻辑

### 检查方法

点击按钮“Send SMS”，检查键盘是否弹出，有一定概率键盘不会被弹出来

### 分析总结

* `UIViewController`中的方法不能随便hook，即使hook也需要谨慎修改被hook的方法的行为，因为系统的一些view controller也会被影响。
* 如果确实需要hook，可以加白名单机制，对自己的类才进行处理

