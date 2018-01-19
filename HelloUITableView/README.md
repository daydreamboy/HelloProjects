## HelloUITableView

1\. UITableView（Grouped、Plain）嵌入在UINavigationViewController中，iOS 10及以下自动调整了顶部的edgeInset（64 points），iOS 11+没有自动调整

默认UITableView，不做任何设置，区别如下

| No. | iOS 10- | iOS 11+ |
|-----|---------|---------|
| 1 | 系统自动contentInset调整为{64, 0, 0, 0} | contentInset默认为{0, 0, 0, 0} |
| 2 | tableView:viewForHeaderInSection:不需要tableView:viewForHeaderInSection:提供view，可以直接设置section header高度 | 需要tableView:viewForHeaderInSection:提供view，tableView:viewForHeaderInSection:设置才生效 |
| 3 | tableView:viewForFooterInSection:不需要tableView:viewForFooterInSection:提供view，可以直接设置section footer高度 | 需要tableView: viewForFooterInSection:提供view，tableView: viewForFooterInSection:设置才生效 |

解决方法

1\. 使用`self.automaticallyAdjustsScrollViewInsets = NO`（iOS 7+），contentInset设置{0, 0, 0, 0}

2&3\. iOS 11+提供`tableView:viewForHeaderInSection:`和`tableView:viewForFooterInSection:`方法，返回空的view


说明
>
1. viewDidAppear可以打印contentInset检查

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



