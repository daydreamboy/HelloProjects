# CoreGraphics

[TOC]

## 1、CGGeometry[^1]

CGGeometry指2D几何（2D Geometry）中的各种结构体和相关函数。



### （1）CGRectDivide

`CGRectDivide`函数作用是将一个矩形切成两个矩形。函数签名，如下

```objective-c
void CGRectDivide (CGRect rect, CGRect *slice, CGRect *remainder, CGFloat amount, CGRectEdge edge);
```

* rect，源矩形
* slice，切出的矩形。不允许传NULL。
* remainder，剩余的矩形。不允许传NULL。
* amount，离edge的距离
* edge，指定的edge，用于确定amout距离从哪个边开始。`CGRectEdge`是枚举类型，枚举值有**CGRectMinXEdge**、**CGRectMinYEdge**、**CGRectMaxXEdge**和**CGRectMaxYEdge**

示意图[^2]，如下

![](images/CGRectDivide.png)

说明

> 示意图中，edge指定的值为CGRectMinXEdge



### （2）CGRectStandardize

​        `CGRectStandardize`函数的作用是将矩形标准化，这里的标准化，实际上，是指不改矩形位置和大小的情况下，将负的width或者负的height都变成正的。

> Returns a rectangle with a positive width and height.

​       CGSize的width和height允许负数，因此CGRect的width和height也允许负数，因此基于origin点允许有正方向的width或height，也允许负方向的width或height。

举个例子，如下

```objective-c
rect = CGRectMake(1, 2, -4, -3);
output = CGRectStandardize(rect);
XCTAssertTrue(CGRectEqualToRect(output, CGRectFromString(@"{{-3, -1}, {4, 3}}")));
```



说明

> CGSize的width和height允许负数，常用于表示向量。实际上，在iOS 7+以后可以使用`CGVector`类型表示，语义上更加容易理解。



### （3）CGRectIntegral

​        `CGRectIntegral`函数的作用将矩形的origin以及width和height整数化，即origin的x和y都向下取整（使用`floor`函数），width和height向上取整（使用`ceil`函数）。返回的矩形包含源矩形。

举个例子，如下

```objective-c
rect = CGRectMake(0.1, 0.5, 3.3, 2.7);
output = CGRectIntegral(rect);
XCTAssertTrue(CGRectEqualToRect(output, CGRectFromString(@"{{0, 0}, {4, 4}}")));
```



### （4）CGRectOffset

`CGRectOffset`函数的作用将矩形进行偏移，即修改origin但不改变width和height。



### （5）CGRectInset

​        `CGRectInset`函数的作用是将矩形收缩（Contracting）或伸展（Expanding），即在矩形的水平方向或垂直方向添加间距（padding）。

举个例子，如下

```objective-c
// Case 1
rect = CGRectMake(1, 2, 4, 3);
output = CGRectInset(rect, 1.0, 0.0);
XCTAssertTrue(CGRectEqualToRect(output, CGRectFromString(@"{{2, 2}, {2, 3}}")));

// Case 2
rect = CGRectMake(1, 2, 4, 3);
output = CGRectInset(rect, -1.0, 0.0);
XCTAssertTrue(CGRectEqualToRect(output, CGRectFromString(@"{{0, 2}, {6, 3}}")));

// Case 3
rect = CGRectMake(1, 2, 4, 3);
output = CGRectInset(rect, 0.5, 0.0);
XCTAssertTrue(CGRectEqualToRect(output, CGRectFromString(@"{{1.5, 2}, {3, 3}}")));
```



### （6）CGRectIntersection

`CGRectIntersection`函数的作用是获取两个矩形的相交区域。如果没有返回CGRectNull。



### （7）CGRectUnion

`CGRectUnion`函数的作用是获取最小的矩形，同时包含两个矩形。



### （8）CGRect的特殊值

| 值             | 含义                  |
| -------------- | --------------------- |
| CGRectZero     | {x 0 y 0 w 0 h 0}     |
| CGRectNull     | {x +∞ y +∞ w 0 h 0}   |
| CGRectInfinite | {x -∞ y -∞ w +∞ h +∞} |



说明

> CGRectInfinite比较特殊，它包含任意点或矩形、和任意矩形都相交、和任意矩形union后都是CGRectInfinite。Swift代码，如下
>
> ```swift
> CGRect.infinite.contains(any point) // true
> CGRect.infinite.intersects(any other rectangle) // true
> CGRect.infinite.union(any other rectangle) // CGRect.infinite
> CGRect.infinite.isInfinite // true
> ```









## References

[^1]: <https://nshipster.com/cggeometry/>
[^2]:<https://www.infragistics.com/community/blogs/b/torrey-betts/posts/quick-tip-dividing-a-cgrect-using-cgrectdivide-objective-c>