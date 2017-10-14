## 内存泄漏问题

### 测试环境
* iPhone 6S, iOS 10.3.2
* Xcode 9

### 复现过程

AppDelegate的root view controller是`LoginViewController`，`LoginViewController` present modal view controler `ModalViewController`，然后将AppDelegate的root view controller切换成`HomeViewController`，同时将`LoginViewController`设置为nil。这时`ModalViewController`和`LoginViewController`不会释放。

### 检查方法

点击按钮“结束登录”之前和之后，使用`Debug Memory Graph`对比view controller实例

### 分析总结

* `presentViewController:animated:completion:`和`dismissViewControllerAnimated:completion:`必须配对使用，这样系统才可能正确处理内存问题
* 手动将实例变量置为nil，不总是可以释放这个对象的

