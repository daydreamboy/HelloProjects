# 关于UIResponder

[TOC]

## 1、UIResponderStandardEditActions协议

UIResponder实现UIResponderStandardEditActions协议，该协议描述系统的context menu中一些菜单行为，例如剪切、复制、粘贴等。

UIView的特定子类(UITextField、UITextView)，可以实现UIResponderStandardEditActions协议中的方法，用于控制特定菜单行为。举个例子，如下

```objective-c
- (void)paste:(id)sender {
//    [super paste:sender];
    NSLog(@"%@ PASTE!!", self);
}
```

示例代码见**GetContextMenuClickEventViewController**

说明

> 不调用super方法，可以禁止菜单点击后的行为



## 2、使用UIMenuController

​        UIMenuController用于显示上下文菜单，上下文菜单可以通过两种方式配置

* 实现UIResponderStandardEditActions协议的UIResponder类，显示系统默认的菜单
* 自定义UIMenuItem，并设置UIMenuController的`menuItems`属性，显示自定义菜单

UIMenuController是一个共享的单例，通过`+[UIMenuController sharedMenuController]`类方法获取。由于是一个单例，UIMenuController显示的菜单（UIMenuItem）总是和特定的UIResponder对象关联，实际上，UIMenuController按照事件响应链的顺序，去查找该显示哪个对象的上下文菜单。



### （1）设置UIMenuController显示

`-[UIMenuController setTargetRect:inView:]`方法，设置菜单的位置。

> 1. 一般来说，菜单的箭头总是指向targetRect的中间，但是targetRect没有设置width和height时，则指向这个点。
> 2. targetView和上面提到的显示上下文菜单的UIResponder对象，可以不是同一个对象

`-[UIMenuController setMenuVisible:animated:]`方法，用于显示菜单。

> 一般对于普通UIView，调用上面方法，并不显示上下文菜单。需要做下面三个步骤[^1]
>
> 1. 调用`-[UIMenuController setMenuVisile:animated:]`方法前，要必须先调用`-[UIResponder becomeFirstResponder]`。示例代码见**UseUIMenuControllerViewController**
> 2. UIView或者UIViewController，需要实现`- [UIResponder canBecomeFirstResponder]`并返回YES。UITextField/UITextView都默认返回YES。
> 3. UIView或者UIViewController，需要实现`- [UIResponder canPerformAction:withSender:]`，用于控制哪些菜单可以显示



### （2）设置UIMenuController的响应者

UIMenuController的响应者，是按照事件响应链的顺序，去查找该显示哪个响应者的上下文菜单。例如常见的UITextField，调用`-[UIResponder becomeFirstResponder]`方法，再次长按松开时，才会显示上下文菜单。如果要重新设置UITextField的上下文菜单，只需要完成下面两个步骤

> 1. 实现`- [UIResponder canPerformAction:withSender:]`方法，控制哪些菜单显示
> 2. 添加自定义的UIMenuItem，以及实现对应的selector方法

但是普通的UIView，除了上面两个步骤，还需要实现`- [UIResponder canBecomeFirstResponder]`并返回YES。

注意的是，普通的UIView调用`-[UIResponder becomeFirstResponder]`，不会唤起键盘，这就导致显示上下文菜单时，让UITextField失去焦点，对应的键盘也收起。SO上有人提出这个[问题](https://stackoverflow.com/questions/13601643/uimenucontroller-hides-the-keyboard)[^2]，解决思路是

存在两个响应链，而且UITextField和UILabel都需要调用`-[UIResponder becomeFirstResponder]`方法。

```
UITextField <- UIView <- ... <- UIWindow <- UIApplication
UILabel <- UIView <- ... <- UIWindow <- UIApplication
```

但是显示上下文菜单，是对应的是UILabel上设置的，而不是UITextField上设置的。因此，通过重写UITextField的`-[UIResponder nextResponder]`方法，将nextResponder设置为UILabel，形成下面这样一个响应链

```
UITextField <- UILabel <- UIView <- ... <- UIWindow <- UIApplication
```

这样键盘不会收起，但是如果UITextField自身提供了上下文菜单，则显示的上下文菜单对应的是UITextField。因此还需要重写UITextField的`- [UIResponder canBecomeFirstResponder]`方法，当存在上面的响应链，`- [UIResponder canBecomeFirstResponder]`方法返回NO，让事件传递给UILabel。

示例代码见**UIMenuControllerKeepKeyboardShowViewController**



3、UITableViewCell的上下文菜单

UITableViewCell的上下文菜单可以用两种方式实现

* 实现UITableViewDelegate下面三个方法，并且自定义UITableViewCell实现menu action方法（示例代码见**TableViewCellShowCustomContextMenuViewController**）

  >  \- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath;
  >
  >  \- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender;
  >
  >  \- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender;

* UITableViewCell按照上面普通UIView的方式，然后UITableViewCell自己添加长按手势，并显示UIMenuController



## 3、使用WCMenuItem

WCMenuItem支持block方式，获取firstResponder的UIView中无侵入写处理action的代码。

示例代码，见



## References

[^1]: https://stackoverflow.com/a/3673790
[^2]: https://stackoverflow.com/questions/13601643/uimenucontroller-hides-the-keyboard







