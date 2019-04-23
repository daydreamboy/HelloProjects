# CoreText
[TOC]

## 1、Conception

### （1）CTM

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



### （2）CoreText常见Opaque类型



| Opaque Type   | Data Type        | 含义                                                      | 说明 |
| ------------- | ---------------- | --------------------------------------------------------- | ---- |
| CTFramesetter | CTFramesetterRef | CoreText layout engine上根对象，用于产生一个或多个CTFrame |      |
| CTFrame       | CTFrameRef       | 一个CTFrame包含文本的多行(CTLine)，类似文本的段落         |      |
| CTLine        | CTLineRef        | 一个CTLine包含多个CTRun，类似文本的一行                   |      |
|               |                  |                                                           |      |





CTTypesetterRef

CTFrame

CTLine

CTRun



CTFont，包含特定字体信息，

CTFontDescriptor可以完全从属性字典描述一种字体并创建该字体

> provide a mechanism for describing a font completely from a dictionary of attributes, and an easy-to-use font-matching facility for building new fonts.

CTFontCollection



#### 1. CTFramesetter

CTFramesetter根据CFAttributedString创建数据对象（CTFramesetterRef），可以使用下面函数创建

```c
CTFramesetterRef CTFramesetterCreateWithAttributedString(CFAttributedStringRef string);
```

当创建好CTFramesetter对象后，可以使用`CTFramesetterCreateFrame`函数创建CTFrame对象。



#### 2. CTFrame

CTFrame代表文本的段落，它依赖CTFramesetter创建出来，`CTFrameDraw`函数将段落在当前画布中绘制出来。

示例代码见**LayingOutAParagraphView**





Reference
--

[^1]: https://stackoverflow.com/questions/30756907/ctm-transforms-vs-affine-transforms-in-ios-for-translate-rotate-scale



