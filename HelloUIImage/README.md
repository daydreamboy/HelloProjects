## iOS Drawing

[TOC]

---

### 1、几种绘图方式

iOS中有几种方式可以绘图，UIKit、CoreGraphics（Quartz 2D）、OpenGL ES，其中

* UIKit提供一套绘图函数[^1]，e.g. `UIGraphicsBeginImageContextWithOptions`。这些UI开头函数可以看成是对CoreGraphics函数的便利封装，可以和CG开头的函数混合使用。



### 2、UIKit绘图

#### （1）创建绘图环境

创建一个绘图环境，可以用UIKit提供的`UIGraphicsBeginImageContextWithOptions`或`UIGraphicsBeginImageContext`函数。函数原型分别是

```objective-c
void UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale);
void UIGraphicsBeginImageContext(CGSize size);
```

上面的函数，实际上，在创建一个画布对象并将它放在栈上。

`UIGraphicsBeginImageContextWithOptions`和`UIGraphicsBeginImageContext`函数的区别，如下

* `UIGraphicsBeginImageContext`，创建的画布分辨率总是1，UIGraphicsGetImageFromCurrentImageContext取出的image的scale也总是1。而且当rect指定size小于1 point，生成的image总是{1,1}

* `UIGraphicsBeginImageContextWithOptions`，创建的画布分辨率可以指定分辨率，如果指定0.0f，则采用设备的分辨率，这样UIGraphicsGetImageFromCurrentImageContext取出image的scale和设备分辨率保持一致，而且image的size可以设置小于1 point，但不能低于1 px。



注意：用`UIGraphicsBeginImageContextWithOptions`或`UIGraphicsBeginImageContext`函数创建绘图环境后，需要用`UIGraphicsEndImageContext`函数做清理。（参考UIGraphicsBeginImageContextWithOptions的文档）



#### （2）显示1px高度的UImage

​        使用CoreGraphics画图时，不同分辨率scale的画布，对应1px高度是不一样的。例如scale=1（@1x），则对应高度是1pt；scale=2（@2x）对应的高度是1.0/2pt；scale=3（@3x）对应的高度是1.0/3pt。当高度小于这个值，UIGraphicsGetImageFromCurrentImageContext方法，总是返回1.0/scale pt = （1px）高度的UIImage。

```objective-c
+ (UIImage *)imageWithColor:(UIColor *)color {
    // Note: change size {1, 0.5f} to test
    CGRect rect = CGRectMake(0, 0, 1, 0.5f);
    // Note: use UIGraphicsBeginImageContextWithOptions instead of UIGraphicsBeginImageContext
    // @see https://stackoverflow.com/questions/4965036/uigraphicsgetimagefromcurrentimagecontext-retina-resolution
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
```



## References

[^1]: https://developer.apple.com/documentation/uikit/drawing