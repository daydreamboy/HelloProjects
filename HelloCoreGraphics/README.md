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



## References

[^1]: <https://nshipster.com/cggeometry/>
[^2]:<https://www.infragistics.com/community/blogs/b/torrey-betts/posts/quick-tip-dividing-a-cgrect-using-cgrectdivide-objective-c>