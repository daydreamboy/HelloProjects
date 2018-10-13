## CALayer的position设置NaN导致Crash问题

### 测试环境
* iPhone 8, iOS 11.4
* Xcode 9.4.1

### 复现过程

```
- (void)test_CALayer_position_with_divide_zero3 {
    // Note: Center the layer in self.view
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    // Note: - CGRectGetWidth(self.view.bounds) / 0 wil get +Inf
    //       - 0 / 0.0 wil get NaN
    CGSize size = CGSizeMake(0 / 0.0, CGRectGetHeight(self.view.bounds) / 0);
    layer.position = CGPointMake(size.width, size.height);
    
    [self.view.layer addSublayer:layer];
}
```



* 0.0浮点数当成除数，即x/0.0会导致产生NaN。CALayer的position中的x或y不接受NaN，会出现下面crash

  ```
  Terminating app due to uncaught exception 'CALayerInvalidGeometry', reason: 'CALayer position contains NaN: [nan 300]'
  ```


* 0整型当成除数，即x/0会导致产生+Inf。但是CALayer的position中的x或y可以接受+Inf。

```
- (void)test_CALayer_position_with_divide_zero {
    // Note: Center the layer in self.view
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    // Ok, not crash
    // Note: CGRectGetWidth(self.view.bounds) / 0 wil get +Inf
    layer.position = CGPointMake(CGRectGetWidth(self.view.bounds) / 0, CGRectGetHeight(self.view.bounds) / 0);
    
    [self.view.layer addSublayer:layer];
}
```



### 分析总结

解决方法：

在除以某个变量（int或者float）时，都应判断下是否为0。对除数为0的情况，做特殊处理，以免出现不可预知的问题。


