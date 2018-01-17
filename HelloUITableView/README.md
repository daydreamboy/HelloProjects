## HelloUITableView

1\. UITableView（Grouped、Plain）嵌入在UINavigationViewController中，iOS 10及以下自动调整了顶部的edgeInset（64 points），iOS 11+没有自动调整

默认UITableView，不做任何设置，区别如下

| iOS 10- | iOS 11+ |
|---------|---------|
| 系统自动contentInset调整为{64, 0, 0, 0} | contentInset默认为{0, 0, 0, 0} |
| | |

说明
>
1. viewDidAppear可以打印contentInset检查
2. 
