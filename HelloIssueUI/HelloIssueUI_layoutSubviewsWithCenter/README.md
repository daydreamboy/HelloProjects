## layoutSubviews不调用问题

### 测试环境
* iPhone 8 Plus, iOS 11.2
* Xcode 9.2

### 复现过程

```
- (void)test_issue_of_layoutSubview_with_setCenter {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    // Note: those init are all NOT Ok
    //  - [[Subview alloc] init]
    //  - [[Subview alloc] initWithFrame:CGRectZero]
    //  - [[Subview alloc] initWithFrame:CGRectMake(0, 0, 0, 0)]
    //  - [[Subview alloc] initWithFrame:CGRectMake(10, 10, 0, 0)]
    Subview *view = [[Subview alloc] init];
    
    // Note: setCenter will cause `layoutSubviews` NOT called
    view.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    [self.view addSubview:view];
    view.backgroundColor = [UIColor yellowColor];
}
```

如果初始化view时，不设置width或者height，同时设置center，这时center的值和origin值是一样的。

另外，addSubview:不会触发view的layoutSubviews方法。本来的意图是，在layoutSubviews中自适应contentView的大小，来调整self.frame。

### 分析总结

解决方法：

初始化view必须指定size，可以使临时的size


