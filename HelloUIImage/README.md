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



### 3、UIImage常见问题

#### （1）+[UIImage imageWithContentsOfFile:]方法懒加载图片文件

​        `+[UIImage imageWithContentsOfFile:]`方法在调用时并不直接读文件，而是在渲染时才读取文件。如果在渲染之前删除UIImage对应的图片，则渲染失败显示一块黑色。

示例代码，如下

```objective-c
NSData *data;

NSString *newFilePath = [[self.class appDocumentsDirectory] stringByAppendingPathComponent:@"test.png"];
NSString *filePath = [[NSBundle mainBundle] pathForResource:@"fake" ofType:@"png"];
[[NSFileManager defaultManager] copyItemAtPath:filePath toPath:newFilePath error:nil];

if ([[NSFileManager defaultManager] fileExistsAtPath:newFilePath]) {
    UIImage *image = [UIImage imageWithContentsOfFile:newFilePath]; // ISSUE: the image file maybe delete afterward
    data = UIImagePNGRepresentation(image);
    XCTAssertNotNil(data);

    [[NSFileManager defaultManager] removeItemAtPath:newFilePath error:nil];

    XCTAssertNotNil(image);
    data = UIImagePNGRepresentation(image);
    XCTAssertNil(data);
}
```

解决方法：`+[NSData dataWithContentsOfFile:]`方法提前将图片读取到内存。代码见**Tests_UIImage.m**



#### （2）计算UIImage所持有图片的内存大小

​        UIImage对象封装图片的信息，但是它自身的内存大小并不代表图片在内存的大小。另外，网上有人说使用`UIImageJPEGRepresentation`和`UIImagePNGRepresentation`方法来获取NSData对象来判断UIImage所持有图片的内存，显然这种方法不对，两个方法得出来NSData的length是不一样，因为采用不同图片编码压缩方式，得出来NSData大小就是不一样的。而且这个NSData并不是图片非压缩的大小。图片非压缩的大小，是指图片解码（反解JPEG、PNG等编码方式）展开成像素矩形（width * height），对于RGBA图片，每个像素用4 bytes来描述，因此RGBA图片的内存大小是`width * height * 4` bytes。

​       SO有人[^2]用Instruments的Allocations工具来确定图片的内存大小，自己实践确实可行。先给出几个实践后结论：

* 避免使用`imageNamed:`等系列方法，使用这个方法，系统有缓存，每次测试图片内存大小得每次杀掉app，比较麻烦。改用`[UIImage imageWithContentsOfFile:]`方法。

* 图片仅在UIImageView在屏幕上渲染，才会触发图片加载到内存（同“+[UIImage imageWithContentsOfFile:]方法懒加载图片文件”一节）。
* 图片类型不同，系统加载图片的代码调用栈也不同，Allocations工具的Generations统计的分类显示也不同。举几个例子，如下

| 图片类型      | Category统计          | 示例                                            |
| ------------- | --------------------- | ----------------------------------------------- |
| Grayscale图片 | VM: CoreAnimation     | ![](images/Grayscale_image_memory_size.png)     |
| TIFF图片      | VM: Image IO          | ![](images/TIFF_image_memory_size.png)          |
| JPEG图片      | VM: ImageIO_jpeg_Data | <img src="images/JPEG_image_memory_size.png" /> |
| PNG图片       | VM: ImageIO_PNG_Data  | ![](images/PNG_image_memory_size.png)           |



计算图片在内存大小，示例代码[^3]如下

```objective-c
+ (NSUInteger)memoryBytesWithImage:(UIImage *)image {
    if (![image isKindOfClass:[UIImage class]]) {
        return 0;
    }
    
    NSUInteger bytes = 0;
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGColorSpaceModel model = CGColorSpaceGetModel(colorSpace);

    if (model == kCGColorSpaceModelMonochrome) {
        bytes = CGImageGetHeight(image.CGImage) * CGImageGetBytesPerRow(image.CGImage);
    }
    else {
        NSUInteger height = (NSUInteger)ceil(image.size.height) * image.scale;
        NSUInteger width = (NSUInteger)ceil(image.size.width) * image.scale;
        
        NSUInteger bytesPerRow = 4 * width;
        if (bytesPerRow % 16)
            bytesPerRow = ((bytesPerRow / 16) + 1) * 16;
        bytes = height * bytesPerRow;
    }

    return bytes;
}
```



* 灰度图片，使用CGImageGetHeight和CGImageGetBytesPerRow方法来计算
* 其他图片，使用RGBA的计算方式。值得注意的是，image的尺寸是dp，需要转成px来获取图片在内存中实际的尺寸



> 示例代码，见CheckImageMemorySizeViewController



#### （3）+[UIImage imageWithContentsOfFile:]方法的获取图片不对的问题

​        当同时存在xxx.png和xxx@2x.png时，使用imageWithContentsOfFile:方法，指定路径到xxx.png，该方法读取出的图片对象UIImage，居然是xxx@2x.png。

示例代码，如下

```objective-c
- (void)test_imageWithContentsOfFile_issue_load_wrong_image {
    NSString *filePath;
    UIImage *image;
    
    // Case 1
    NSString *filename = @"fake.png";
    filePath = [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:[filename pathExtension]];
    image = [UIImage imageWithContentsOfFile:filePath];
    
    NSLog(@"filePath1: %@", filePath);
    NSLog(@"image1: %@", image);
    
    // Case 2
    filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"fake.png"];
    UIImage *image2 = [UIImage imageWithContentsOfFile:filePath];
    
    NSLog(@"filePath2: %@", filePath);
    NSLog(@"image2: %@", image2);
}
```

推测imageWithContentsOfFile:方法内部优先使用当前设备scale对应的同名图片。可以删掉xxx@2x.png图片，仅保留xxx.png，发现imageWithContentsOfFile:方法可以获取到正确的图片。



> 示例代码，见test_imageWithContentsOfFile_issue_load_wrong_image



## References

[^1]: https://developer.apple.com/documentation/uikit/drawing
[^2]:https://stackoverflow.com/a/29212494
[^3]:https://stackoverflow.com/a/1298043

