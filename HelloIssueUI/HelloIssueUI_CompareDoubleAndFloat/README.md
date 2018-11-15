## 比较double和float是否相等的问题

### 测试环境
* iPhone 8 Plus, iOS 11.4
* Xcode 9.4.1

### 复现过程

```objective-c
- (void)test_compare_double_and_float {
    CGSize size = CGSizeZero;
    
    float width = kImageMsgPreviewMinShowWidth;
    float height = kImageMsgPreviewMinShowHeight;
    
    size = CGSizeMake(width, height);
    XCTAssertFalse(size.width == kImageMsgPreviewMinShowWidth);
    XCTAssertFalse(size.height == kImageMsgPreviewMinShowHeight);
    
    NSLog(@"%f", size.width);
    NSLog(@"%f", kImageMsgPreviewMinShowWidth);
}
```



### 分析总结

比较double和float，应该是不准确的。但是相同浮点类型，是可以用==比较的，因为一些常用函数已经这么使用了。例如CGPointEqualToPoint和CGSizeEqualToSize（见CGGeometry.h）。

```objective-c
CG_INLINE bool
__CGPointEqualToPoint(CGPoint point1, CGPoint point2)
{
  return point1.x == point2.x && point1.y == point2.y;
}
#define CGPointEqualToPoint __CGPointEqualToPoint

CG_INLINE bool
__CGSizeEqualToSize(CGSize size1, CGSize size2)
{
  return size1.width == size2.width && size1.height == size2.height;
}

#define CGSizeEqualToSize __CGSizeEqualToSize
```



解决方法：

* 如果是相同类型的比较，float和float或者double和double，用`==`是安全的
* 如果是float和double比较，需要将double转成float（高精度转成低精度），然后用下面方式比较。这样在float类型的精度上能保证判断两个浮点数是否是相等的。

```objective-c
#define FLOAT_COMPARE_EQUAL(f1, f2) (fabs((float)(f1) - (float)(f2)) < FLT_EPSILON)
```

但是不能将float转成double，然后两个double之间比较，这样差值会变大，导致`(fabs((double)(f1) - (double)(f2)) < DBL_EPSILON)`判断不准。




