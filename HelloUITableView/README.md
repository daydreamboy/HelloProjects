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
