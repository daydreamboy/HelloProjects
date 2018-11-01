## HelloUITableView

[TOC]

### 1、关于contentInset

#### （1）contentInset被系统自动设置

官方文档，描述如下

> By default, UIKit automatically adjusts the content inset to account for overlapping bars. 

在viewDidAppear可以检查系统调整后的contentInset值。

根据上面描述，推测UIKit内部会计算UITableView和nav bar是否遮挡等，来决定是否调整contentInset。

举个例子，UITableView所在UIViewController嵌入在UINavigationViewController中，UITableView的contentInset，在iOS 10-和iOS 11+的区分，如下

| iOS 10-                                 | iOS 11+                                    |
| --------------------------------------- | ------------------------------------------ |
| 系统自动contentInset调整为{64, 0, 0, 0} | 系统不调整，contentInset默认为{0, 0, 0, 0} |

iOS 7+UIViewController有`automaticallyAdjustsScrollViewInsets`属性，可以设置为NO，将contentInset设置为{0, 0, 0, 0}，这样保证iOS 10-和iOS 11+行为一致。

> `automaticallyAdjustsScrollViewInsets`属性，在iOS 11+不起作用，而且是Deprecated。取代的是UIScrollView的`contentInsetAdjustmentBehavior`属性，可以设置为UIScrollViewContentInsetAdjustmentNever[^2]，效果和`automaticallyAdjustsScrollViewInsets = NO`是一样的。
>
> 由于`contentInsetAdjustmentBehavior`属性仅在iOS 11+，正确设置的方式是
>
> ```objective-c
> if (IOS11_OR_LATER) {
> #pragma GCC diagnostic push
> #pragma GCC diagnostic ignored "-Wunguarded-availability-new"
>     tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
> #pragma GCC diagnostic pop
> }
> ```
>
> 这样保证编译无警告和运行时无crash。



#### （2）设置contentInset会触发scrollViewDidScroll:方法[^3]

iOS 8+上，当UIScrollView或者UITableView设置过delegate，然后再设置contentInset会立即触发scrollViewDidScroll:方法。这个可能会导致一些问题，举个例子，如下

```objective-c
- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGRect frame = self.view.bounds;
        frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];

        tableView.delegate = self;
        tableView.dataSource = self;
        // Note: 这里会立即触发调用scrollViewDidScroll:
		tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);        
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Note: 这里self.tableView导致重新进入tableView方法，走到tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);，从而导致死循环
    CGPoint contentOffset = self.tableView.contentOffset;
    NSLog(@"contentOffset: %@", NSStringFromCGPoint(contentOffset));
}
```

解决这里的问题，有几个方法

方法一：设置contentInset在设置delegate之前。

方法二：scrollViewDidScroll:方法中，使用_tableView，但有可能是nil。

方法三：设置contentInset不要在tableView方法中，可以在viewDidLoad中，调用self.tableView.contentInset来设置。







| No. | iOS 10- | iOS 11+ |
|-----|---------|---------|
| 1 |  |  |
| 2 | tableView:viewForHeaderInSection:不需要tableView:viewForHeaderInSection:提供view，可以直接设置section header高度 | 需要tableView:viewForHeaderInSection:提供view，tableView:viewForHeaderInSection:设置才生效 |
| 3 | tableView:viewForFooterInSection:不需要tableView:viewForFooterInSection:提供view，可以直接设置section footer高度 | 需要tableView: viewForFooterInSection:提供view，tableView: viewForFooterInSection:设置才生效 |

解决方法

1\. 使用`self.automaticallyAdjustsScrollViewInsets = NO`（iOS 7+），将contentInset设置为{0, 0, 0, 0}

2&3\. iOS 11+提供`tableView:viewForHeaderInSection:`和`tableView:viewForFooterInSection:`方法，返回空的view


说明
>viewDidAppear可以打印contentInset检查
## UITableView Tips

1\. Plain Table的数据没有显示超出屏幕时，去除下面多余的分隔线

```
tableView.tableFooterView = [UIView new];
```
Grouped Table不存在上面问题，即使没有显示全部屏幕，也没有多余的分隔线

2\. table header view添加扩展view，用于解决table view header下拉时空白

```
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    CGRect frame = self.bounds;
    frame.origin.y = -frame.size.height;
    UIView *extendedView = [[UIView alloc] initWithFrame:frame];
    extendedView.backgroundColor = self.tableHeaderView.backgroundColor;
    [self addSubview:extendedView];
}
```

3\. 将Plain Table的section设置成不浮动的，类似Grouped Table[^1]

```
CGFloat dummyViewHeight = 40;
UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, dummyViewHeight)];
self.tableView.tableHeaderView = dummyView;
self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
```



References
--

[^1]: https://stackoverflow.com/questions/1074006/is-it-possible-to-disable-floating-headers-in-uitableview-with-uitableviewstylep

[^2]: https://stackoverflow.com/a/45242206 
[^3]: https://stackoverflow.com/questions/29364287/changing-uiscrollview-content-inset-triggers-scrollviewdidscroll

