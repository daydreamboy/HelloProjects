# 关于UITableView

[TOC]

## 1、关于contentInset

### （1）contentInset被系统自动设置

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



### （2）设置contentInset会触发scrollViewDidScroll:方法[^3]

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


## 2、UITableView Tips

### （1）Plain Table的数据没有显示超出屏幕时，去除下面多余的分隔线

```
tableView.tableFooterView = [UIView new];
```
Grouped Table不存在上面问题，即使没有显示全部屏幕，也没有多余的分隔线

示例代码见**PlainTableViewRemoveRedundantSeparatorsViewController**



### （2）Table header view添加扩展view，用于解决Table view header下拉时空白

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

示例代码见**TableViewHeaderWithExtendedViewViewController**



### （3）将Plain Table的section设置成不浮动的，类似Grouped Table[^1]

```
CGFloat dummyViewHeight = 40;
UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, dummyViewHeight)];
self.tableView.tableHeaderView = dummyView;
self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
```

示例代码见**PlainTableViewWithNonFloatSectionViewController**



### （4）TableView的cell添加上下文菜单

TableViewDelegate提供下面三个方法，用于提供cell的上下文菜单，而且

```objective-c
 - (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath; // 用于是否显示context menu
 - (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender; // 用于是否显示context menu中特定菜单
 - (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender; // 响应context menu中特定菜单的点击
```

说明

> 1. 实现三个方法，可以简单显示系统默认的context menu。如果需要自定义菜单，则使用UIMenuController，示例代码参考HelloUITableViewCell
> 2. 上面三个方法的action参数，如果是以下划线开头的，则是系统私有方法，需要额外注意。例如action为@selector(_share:)，在canPerformAction:方法中，可以控制share菜单是否显示，但是share菜单的点击并不会回调到performAction:方法中。



### （5）UITableView的编辑模式

​        当设置UITableView的editing属性或者通过`-[UITableView setEditing:animated:]`方法设置为YES时，UITableView进入编辑模式。

​        UITableView的delegate方法`-[UITableViewDelegate tableView:editingStyleForRowAtIndexPath:]`方法，用于控制编辑模式下显示样式，这个方法默认返回UITableViewCellEditingStyleDelete。

​        UITableViewCellEditingStyle枚举值，如下

```objective-c
typedef NS_ENUM(NSInteger, UITableViewCellEditingStyle) {
    UITableViewCellEditingStyleNone, // 多选
    UITableViewCellEditingStyleDelete, // 删除
    UITableViewCellEditingStyleInsert // 插入
};
```

​        除了上面三种枚举类型（多选、删除、插入），UITableView的编辑模式还是支持移动，不过移动枚举值没有定义在UITableViewCellEditingStyle中，而是通过实现下面两个方法来支持移动方式，如下

```objective-c
-[UITableViewDelegate tableView:moveRowAtIndexPath:toIndexPath:] // 通知数据变更
-[UITableViewDelegate tableView:canMoveRowAtIndexPath:] // 控制哪些indexPath可以移动
```

> 示例代码，见MoveMeViewController

​        因此，UITableView的编辑模式，实际上支持四种方式：**多选**、**删除**、**插入**和**移动**。另外，前三种方式可以额外组合一个移动方式，即**多选 + 移动**、**删除 + 移动**、**插入 + 移动**。

> 示例代码，见SelectMeViewController、DeleteMeViewController、InsertMeViewController



​      当UITableView处于编辑模式，UITableViewCell对应在编辑模式下属性也会生效，例如editingAccessoryType、editingAccessoryView和shouldIndentWhileEditing。







References
--

[^1]: https://stackoverflow.com/questions/1074006/is-it-possible-to-disable-floating-headers-in-uitableview-with-uitableviewstylep

[^2]: https://stackoverflow.com/a/45242206 
[^3]: https://stackoverflow.com/questions/29364287/changing-uiscrollview-content-inset-triggers-scrollviewdidscroll

