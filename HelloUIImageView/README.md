# UIImageView

[TOC]



## 1、图片遮罩技术(Masking)

​      图片遮罩技术(后简称Masking技术)，实际是一些图像处理软件（例如Photoshop），常见应用的方式之一[^1]。一般来说，Masking技术的用途有下面几个方面[^2]

* 不破坏原图，修改原图的显示效果，例如替换背景，常见应用如证件照替换背景颜色
* 遮罩显示，原图透过某个蒙层显示出来。例如背景是图片，透过文字显示出来。
* 图像拼接（Making Collage Images），将几个扣取来的图像进行组合，形成好像是一起画出或拍照的效果



iOS中CALayer的mask属性，提供遮罩显示的能力。看看官方文档对mask属性的描述，如下

> The layer’s alpha channel determines how much of the layer’s content and background shows through. Fully or partially opaque pixels allow the underlying content to show through, but fully transparent pixels block that content.
>
> The default value of this property is `nil`. When configuring a mask, remember to set the size and position of the mask layer to ensure it is aligned properly with the layer it masks.



​        mask属性的值也是CALayer（后面称mask layer），而且必须和被遮罩的CALayer（后面称content layer）保持一致的位置和大小对应。mask layer的分为两个部分：全透明或者不透明/半透明。全透明部分，会阻挡content layer对应像素点的透出，而不透明/半透明部分，则让content layer对应像素点显示出来。

因此，content layer哪些部分透出，取决于mask layer不透明的部分。

一般来说设置mask layer，有下面几种方式

* mask layer自身背景色 (backgroundColor)和大小
  * mask layer的背景色默认是透明的，而且如果mask layer小于content layer的大小，content layer的超出部分也是不显示的
* mask layer的contents，一般设置一个部分带全透明的UIImage（后面称遮罩图片）。
* mask layer是CATextLayer



使用mask属性的例子[^5]，如下

```objective-c
CALayer *mask = [CALayer layer];
mask.contents = (id)[[UIImage imageNamed:@"mask.png"] CGImage];
mask.frame = CGRectMake(0, 0, <img_width>, <img_height>);
yourImageView.layer.mask = mask;
yourImageView.layer.masksToBounds = YES;
```



### （1）遮罩图片拉伸masking

遮罩图片不一定和content图片是一样大小，比如遮罩图片需要拉伸，这时有两种方式来创建mask layer

* 使用-[UIImage resizableImageWithCapInsets:resizingMode:]方法，将图像拉伸后，重新绘制一个拉伸后的UIImage，然后用这个UIImage的mask layer进行masking
* 使用CALayer自身拉伸图片的能力（contentsCenter和contentsScale），创建一个mask layer，然后进行masking

第一方式的代码，如下

```objective-c
+ (BOOL)setImageView:(UIImageView *)imageView maskImage:(UIImage *)maskImage contentImage:(UIImage *)contentImage capInsets:(UIEdgeInsets)capInsets {
    if (![imageView isKindOfClass:[UIImageView class]] ||
        ![maskImage isKindOfClass:[UIImage class]] ||
        ![contentImage isKindOfClass:[UIImage class]]) {
        return NO;
    }
    
    CGSize imageViewSize = imageView.bounds.size;
    
    UIImage *finalMaskImage = maskImage;
    
    if (!UIEdgeInsetsEqualToEdgeInsets(capInsets, UIEdgeInsetsZero)) {
        UIImage *resizableMaskImage = [maskImage resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
        
        UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewSize.width, imageViewSize.height)];
        maskImageView.image = resizableMaskImage;
        
        UIGraphicsBeginImageContextWithOptions(imageViewSize, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [maskImageView.layer renderInContext:context];
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        finalMaskImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        UIGraphicsEndImageContext();
    }
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (id)[finalMaskImage CGImage];
    maskLayer.frame = CGRectMake(0, 0, imageViewSize.width, imageViewSize.height);
    imageView.layer.mask = maskLayer;
    imageView.layer.masksToBounds = YES;
    imageView.image = contentImage;
    
    return YES;
}
```



第二种方式的代码，如下

```objective-c
+ (UIImageView *)maskedImageViewWithFrame:(CGRect)frame maskImage:(UIImage *)maskImage contentImage:(UIImage *)contentImage capInsets:(UIEdgeInsets)capInsets {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    maskLayer.contents = (id)maskImage.CGImage;
    
    if (!UIEdgeInsetsEqualToEdgeInsets(capInsets, UIEdgeInsetsZero)) {
        maskLayer.contentsScale = maskImage.scale;
        
        CGFloat y = capInsets.top / maskImage.size.height;
        CGFloat x = capInsets.left / maskImage.size.width;
        CGFloat width = (maskImage.size.width - capInsets.left - capInsets.right) / maskImage.size.width;
        CGFloat height = (maskImage.size.height - capInsets.top - capInsets.bottom) / maskImage.size.height;
        
        x = MIN(MAX(0, x), 1.0);
        y = MIN(MAX(0, y), 1.0);
        width = MIN(MAX(0, width), 1.0);
        height = MIN(MAX(0, height), 1.0);
        
        maskLayer.contentsCenter = CGRectMake(x, y, width, height);
    }

    imageView.layer.mask = maskLayer;
    imageView.layer.masksToBounds = YES;
    imageView.image = contentImage;
    
    return imageView;
}
```



### （2）文字masking

除了mask layer的contents可以用masking，CATextLayer也可以进行masking[^3]

```objective-c
UIImage *contentImage = [UIImage imageNamed:@"colour_gradient.jpeg"];

CGSize imageViewSize = CGSizeMake(300, 100);
CGRect frame = CGRectMake(10, CGRectGetMaxY(_demo4MaskingWithResizaleImageByLayer.frame) + 10, imageViewSize.width, imageViewSize.height);

CATextLayer *textLayer = [CATextLayer layer];

textLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
textLayer.rasterizationScale = [UIScreen mainScreen].scale;
textLayer.contentsScale = [UIScreen mainScreen].scale;
textLayer.alignmentMode = kCAAlignmentCenter;
textLayer.fontSize = 42.0;
textLayer.font = (__bridge CFTypeRef _Nullable)([UIFont fontWithName:@"TrebuchetMS-Bold" size:42.0]);
textLayer.wrapped = YES;
textLayer.truncationMode = kCATruncationEnd;
textLayer.string = @"Hello, world!";

UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
imageView.image = contentImage;
imageView.layer.mask = textLayer;
```

除了直接使用CATextLayer，也可以换成UILabel.layer进行masking[^4]



### （3）masking添加动画

除了使用静态的mask layer，还可以向mask layer添加动画，达到动态masking的效果，比如歌词渐变显示。

以这篇文章[^6]提供的实现歌词渐变显示介绍masking添加动画的应用。

主要有2个技术要点

* 创建2个UILabel，一前一后，形成2种不同颜色的歌词
* 在最前面的UILabel，进行遮罩，透出部分表示已唱部分，不透出部分表示未唱部分。对mask layer的宽度进行动画

```objective-c
CGSize screenSize = [[UIScreen mainScreen] bounds].size;

NSString *text = @"你说如果雨停了我们就在一起";
UIFont *font = [UIFont systemFontOfSize:20];

UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_demo5MaskingWithTextLayer.frame) + 10, screenSize.width, 40)];
view.backgroundColor = [UIColor blackColor];

UILabel *backgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(view.bounds) - 2 * 10, 40)];
backgroundLabel.font = font;
backgroundLabel.textColor = [UIColor whiteColor];
backgroundLabel.text = text;

UILabel *frontLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(view.bounds) - 2 * 10, 40)];
frontLabel.font = font;
frontLabel.textColor = [UIColor greenColor];
frontLabel.text = text;

CALayer *maskLayer = [CALayer layer];
// Note: anchored at middle point of left edge
maskLayer.anchorPoint = CGPointMake(0, 0.5);
// Note: place the anchor point
maskLayer.position = CGPointMake(0, CGRectGetHeight(frontLabel.bounds) / 2.0);
maskLayer.bounds = CGRectMake(0, 0, 0, CGRectGetHeight(frontLabel.bounds));
maskLayer.backgroundColor = [UIColor whiteColor].CGColor;

CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size.width"];
animation.values = @[@0, @(CGRectGetWidth(frontLabel.bounds))];
animation.keyTimes = @[@0, @1];
animation.duration = 5;
animation.calculationMode = kCAAnimationLinear;
animation.repeatCount = HUGE_VALF;

[maskLayer addAnimation:animation forKey:@"mask"];
frontLabel.layer.mask = maskLayer;

[view addSubview:backgroundLabel];
[view addSubview:frontLabel];
```

值得说明的是，这里使用mask layer的背景色和大小来进行遮罩





## 2、UIImageView常见问题

### （1）iOS 13上的issue

UIImageView的frame没有设置或者CGRectZero，通过CALayer的frame来布局，则在iOS 13上image显示不出来。

> 示例代码见LayerFrameIssueOniOS13ViewController





## References

[^1]:https://www.offshoreclippingpath.com/the-various-types-of-image-masking/
[^2]:https://www.colorexpertsbd.com/blog/what-is-image-masking
[^3]:https://littlebitesofcocoa.com/245-masking-views-with-text-using-catextlayer
[^4]:https://riptutorial.com/ios/example/6731/uiimage-masked-with-label
[^5]:https://stackoverflow.com/questions/5757386/how-can-i-mask-a-uiimageview
[^6]:https://blog.csdn.net/hangApple/article/details/51395434







