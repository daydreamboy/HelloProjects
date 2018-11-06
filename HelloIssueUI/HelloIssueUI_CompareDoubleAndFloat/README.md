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

解决方法：

不管参数是float，还是double，都转成float类型，然后用下面方式比较。这样在float类型的精度上能保证判断两个浮点数是否是相等的。

```objective-c
#define FLOAT_COMPARE_EQUAL(f1, f2) (fabs((float)(f1) - (float)(f2)) < FLT_EPSILON)
```






