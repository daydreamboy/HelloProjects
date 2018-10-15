# UIView

[TOC]

---

### 1、Transparent, Transluncent and Opaque 

* transparent，指的是完全透明的，光穿过物体没有多少损失。
* translucent，指的是部分透明，光穿过物体有一部分损失，而且看起来像毛玻璃的效果
* opaque，指的是完全不透明，光无法穿过物体。



### 2、UIView指定某个圆角

基本原理：UIView的CALayer有mask属性，支持指定一个mask layer用于对CALayer进行遮罩。mask layer的形状、大小和alpha决定CALayer如何显示。

以只有左上角和右上角的圆角的UIView为例，基本步骤，如下

第一步，使用UIBezierPath确定一个封闭矩形，而且左上角和右上角是圆角。

```
UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(30, 30)];
```
>
矩形大小应该和对应的UIView大小一致。

第二步，使用CAShapeLayer创建mask layer

```
CAShapeLayer *maskLayer = [CAShapeLayer layer];
maskLayer.frame = view.bounds;
maskLayer.path = maskPath.CGPath;
maskLayer.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2].CGColor;
```
>
mask layer虽然指定path，但是这个path不会截取layer的矩形形状，因此CAShapeLayer分为了两个区域：path区域和非path区域（path以外的部分）。
>
* path区域（opaque部分）没有指定颜色，所以是黑色不透明alpha=0
* 非path区域（translucent部分）则指定了backgroundColor而且alpha=0.2，这里指定red颜色没有关系，但是一定要指定alpha（0<= alpha < 1）

第三步，将mask layer赋值到mask属性

```
UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 100, 100)];
view.backgroundColor = [UIColor greenColor];
view.layer.mask = maskLayer;
```

mask属性决定如何将layer和mask layer进行合成

1. mask layer在layer中的位置和大小，如果超过layer部分，则被截取掉
2. mask layer中opaque部分（即上面的path区域），layer使用自己的backgroundColor填充；mask layer中translucent部分（即上面的非path区域），layer使用mask layer的alpha值，结合自己backgroundColor，进行填充。如果alpha值是0，则这部分是透明的

参考代码：`ViewWithTwoCornersViewController`



### 3、WCViewTool

检测UIView的frame被修改的事件



### 4、UIView处理是否处理touch事件

UIView提供`- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;`方法给子类实现。

如果touch点落在view的父视图，而且父视图没有设置userInteractionEnabled为NO。touch事件会向子视图传递，子视图的pointInside:withEvent:方法会被调用（当然子视图的userInteractionEnabled为NO，则该方法也不会被调用）。如果touch点落在子视图上，则子视图的pointInside:withEvent:方法返回YES，否则返回NO。

通过在pointInside:withEvent:方法中，进一步判断touch点是否落在特定区域，决定是否返回YES或者NO，让子视图的pointInside:withEvent:方法是否被调用。

示例见，TouchThroughPartRegionViewController。黄色区域（overlay）在红色框按钮前面，蓝色框按钮在overlay中。overlay需要处理落在蓝色框的touch点让蓝色框按钮响应，而落在红色框的touch点让红色框按钮响应。



### 5、关于UIView的-convertRect:toView:和-convertRect:fromView:方法

基本转换关系，如下

```
[sourceView convertRect:<someRect> toView:targetView];
[targetView convertRect:<someRect> fromView:sourceView];
```

以[sourceView convertRect:<someRect> toView:targetView]为例

将someRect视为在sourceView中的坐标，然后将someRect映射到在targetView中的坐标。



### 6、关于AVMakeRectWithAspectRatioInsideRect

AVMakeRectWithAspectRatioInsideRect是AVFoundation.framework提供的函数，用于计算在特定rect中缩放view后的rect。这里的缩放实际是按比例尺缩放的。

#### （1）用途

一般用于缩放UIImageView或者AVPlayerLayer（图片或者视频），举个例子

```
CGSize screenSize = [[UIScreen mainScreen] bounds].size;

// bounding view
UIView *view = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - BoundingSize.width) / 2.0, y, BoundingSize.width, BoundingSize.height)];

// 根据实际image的size按比例尺缩放
UIImage *image = UIImageInResourceBundle(imageName, @"");
CGRect aspectScaledRect = AVMakeRectWithAspectRatioInsideRect(image.size, view.bounds);

UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
// 设置缩放后的imageView
imageView.frame = aspectScaledRect;

[view addSubview:imageView];
```



#### （2）安全使用AVMakeRectWithAspectRatioInsideRect

```
CGRect AVMakeRectWithAspectRatioInsideRect(CGSize aspectRatio, CGRect boundingRect);
```

AVMakeRectWithAspectRatioInsideRect的第一个参数aspectRatio，如果是CGSizeZero，则返回的是(NaN, NaN, NaN, NaN)，把这个值赋值给UIView的frame会导致Crash。

```
Terminating app due to uncaught exception 'CALayerInvalidGeometry', reason: 'CALayer position contains NaN: [nan 300]'
```



* 可以对AVMakeRectWithAspectRatioInsideRect进行保护，详见`+[WCViewTool safeAVMakeAspectRatioRectWithContentSize:insideBoundingRect:]`
* 为了避免只使用一个函数，而引入AVFoundation.framework，可以自己实现AVMakeRectWithAspectRatioInsideRect。详见`+[WCViewTool makeAspectRatioRectWithContentSize:insideBoundingRect:]`



