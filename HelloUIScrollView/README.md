# 关于UIScrollView

[TOC]

## 1、检测用户拖拽事件

​      用户开始拖拽UIScrollView和结束拖拽UIScrollView的事件，可以通过下面2个UIScrollView的delegate方法得到，如下

```objective-c
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
```



## 2、检测滚动事件



UIScrollView滚动触发，目前有三种方式

* 方式1：用户拖拽触发
* 方式2：代码使用`setContentOffset:animated:`方法或者`scrollRectToVisible:animated:`方法
* 方式3：单击状态栏两次



| delegate方法                       | 触发方式 | 触发事件                                                     |
| ---------------------------------- | -------- | ------------------------------------------------------------ |
| scrollViewWillBeginDragging        | 1        | 用户开始拖拽                                                 |
| scrollViewDidEndDragging           | 1        | 用户结束拖拽                                                 |
| scrollViewWillBeginDecelerating    | 1        | 用户结束拖拽后，开始减速滚动                                 |
| scrollViewDidEndDecelerating       | 1        | 用户结束拖拽后，减速滚动结束                                 |
| scrollViewDidEndScrollingAnimation | 2        | `setContentOffset:animated:`方法或者`scrollRectToVisible:animated:`方法的animated参数为YES，才触发 |
| scrollViewDidScroll                | 1/2/3    | 滚动一直触发，调用间隔0.2s左右                               |



根据上表，可知方式1和方式2触发的滚动结束事件，会触发不同的方法，分别是

```objective-c
scrollViewDidEndDecelerating // 用户结束拖拽后，减速滚动结束
scrollViewDidEndScrollingAnimation // 执行滚动动画结束
```



而方式3目前没有公开API，得到滚动结束的事件，但是通过监听最后一次调用scrollViewDidScroll方法的方式，得知事件通知[^1]。示例代码，如下

```objective-c
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll: %f", scrollView.contentOffset.y);
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    // Note: ensure that the end of scroll is fired.
    [self performSelector:@selector(scrollViewDidEndScrolling:) withObject:_tableView afterDelay:0.3];
}

- (void)scrollViewDidEndScrolling:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollViewDidEndScrollingAnimation:) object:_tableView];
    
    NSLog(@"ScrollView end scrolling");
}
```

​      在scrollViewDidScroll方法中一直取消和建立scrollViewDidEndScrolling:方法的延迟调用，一直到最后一次调用scrollViewDidScroll:方法，不再取消scrollViewDidEndScrolling:方法的延迟调用，这样scrollViewDidEndScrolling:方法总是在最后一次调用scrollViewDidScroll:方法后触发。缺点：有一定时间延迟，上面代码是0.3秒，这个间隔太小有可能导致scrollViewDidEndScrolling:方法被触发多次，而是不一定是在最后一次调用scrollViewDidScroll:方法后触发，因此需要慎重设置。





## 3、禁止UIScrollView首次渲染自动调用scrollViewDidScroll方法[^2]



```objective-c
- (void)viewDidLayoutSubviews {
    // add table view delegate after the views have been laid out to prevent scrollViewDidScroll
    // from firing automaticly when the view is adjusted on load, which makes the tab bar disappear 
    self.tableView.delegate = self;
} 
```



## Reference

[^1]:https://stackoverflow.com/a/1857162
[^2]:https://stackoverflow.com/a/27784207



