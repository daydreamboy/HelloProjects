## CGXXXRelease不正确释放问题

### 测试环境
* iPhone 8 Plus, iOS 11.4
* Xcode 9

### 复现过程

Case 1：

```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageViewOriginal];
    [self.view addSubview:self.imageViewScaledToSmaller];
//    [self.view addSubview:self.imageViewScaledToBigger];
}
```

进入ScaleImageViewController，然后退出，再次进入，Crash。



Case 2：

```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageViewOriginal];
    [self.view addSubview:self.imageViewScaledToSmaller];
    [self.view addSubview:self.imageViewScaledToBigger];
}
```

进入ScaleImageViewController，然后退出，Crash。



### 分析总结

原因：[UIImage imageNamed:@"10"]创建的对象，它的CGImage，被`CGImageRelease(imageRef);`释放了。实际上，这个CGImage被系统持有的，自己释放会产生难以排查的问题。



解决方法：

不是Create函数创建CG对象。不要使用CGXXXRelease释放。

