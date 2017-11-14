# HelloCoreText
--

TOC

## 1. Conception

#### CTM

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;CTM (Current Transformation Matrix)[^1]代表当前画布Context的坐标系的矩阵。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`UIGraphicsGetCurrentContext`方法取到的context，坐标系默认是左下角原点，up for x轴，right for y轴。这种数学上的坐标系和iOS CoreGraphics的左上角坐标系不一样，所以在context上画图形之前，需要修改context的坐标系。

```
CGContextRef context = UIGraphicsGetCurrentContext();
// Note: move origin to upward based on bottom-left coordinate
CGContextTranslateCTM(context, 0, self.bounds.size.height);
// Note: flip y axis from upward to downward
CGContextScaleCTM(context, 1, -1);
```

注意：
>
`UIGraphicsGetCurrentContext`只有在特定的方法中才能取到context，例如UIView的`drawRect:`方法中。



Reference
--

[^1]: https://stackoverflow.com/questions/30756907/ctm-transforms-vs-affine-transforms-in-ios-for-translate-rotate-scale



