# 关于UITableView

[TOC]

## 1、UITableView常用属性介绍



### （1）contentInset

#### a. contentInset被系统自动设置

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



#### b. 设置contentInset会触发scrollViewDidScroll:方法[^3]

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



### （2）Cell selection

​     UITableView提供4种关于selection的属性，用于控制cell的点击高亮和选中，如下

| 属性                                 | 默认值 | 说明                       |
| ------------------------------------ | ------ | -------------------------- |
| allowsSelection                      | YES    | 非编辑模式下，是否允许单选 |
| allowsMultipleSelection              | NO     | 非编辑模式下，是否允许多选 |
| allowsSelectionDuringEditing         | NO     | 编辑模式下，是否允许单选   |
| allowsMultipleSelectionDuringEditing | NO     | 编辑模式下，是否允许多选   |



* 非编辑模式下，allowsMultipleSelection优先于allowsSelection，即同时设置YES，实际是允许多选，而不是单选
* 编辑模式下，allowsMultipleSelectionDuringEditing优先于allowsSelectionDuringEditing，即同时设置YES，实际是允许多选，而不是单选



#### a. Cell选中背景色有三种方式设置

（1）cell的`selectionStyle`属性，如下

```objective-c
UITableViewCellSelectionStyleNone,
UITableViewCellSelectionStyleBlue,
UITableViewCellSelectionStyleGray,
UITableViewCellSelectionStyleDefault 
```

​       当设置非UITableViewCellSelectionStyleNone类型时，cell在`setSelected:animated:`和`setHighlighted:animated:`方法中自动修改cell所有subview的背景色[^5]

​       避免系统的修改，可以下面几种方法

* 设置UITableViewCellSelectionStyleNone，系统不会调整高亮或选中的背景色。但是存在一个问题：UITableView处于编辑模式（单选或多选），左侧显示出来的checkmark总是不能被选中
* 在`setSelected:animated:`和`setHighlighted:animated:`方法，在调用super方法后恢复cell所有subview的背景色，或者不调用super方法。

示例代码如下

```objective-c
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        // Recover backgroundColor of subviews.
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        // Recover backgroundColor of subviews.
    }
}
```



（2）cell的`selectedBackgroundView`属性

​        当设置非UITableViewCellSelectionStyleNone类型时，可以通过`selectedBackgroundView`属性赋值一个自定义view来设置选中和高亮的背景色



注意

> 设置Cell为UITableViewCellSelectionStyleNone，自定义selectedBackgroundView不会生效



（3）自定义cell

​        自定义cell，可以将`selectionStyle`属性设置为UITableViewCellSelectionStyleNone，防止显示系统样式和自动修改UI的行为，然后提供等价的配置方式。






## 2、UITableView Tips

### （1）Plain Table的数据没有显示超出屏幕时，去除下面多余的分隔线

```objective-c
tableView.tableFooterView = [UIView new];
```
Grouped Table不存在上面问题，即使没有显示全部屏幕，也没有多余的分隔线

示例代码见**PlainTableViewRemoveRedundantSeparatorsViewController**



### （2）Table header view添加扩展view，用于解决Table view header下拉时空白

```objective-c
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

```objective-c
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

> 1. 实现三个方法，可以简单显示系统默认的context menu。如果需要自定义菜单，则使用UIMenuController，示例代码参考HelloUIResponder工程。
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



### （6）UITableView首屏初始化cell个数

UITableView首屏初始化cell个数，指UITableView首次渲染，系统会初始化多少个cell。这个也和cell高度有关。

在tableView:cellForRowAtIndexPath:方法中输出日志，观察如下

| 系统版本 | 模拟器设备类型    | 首屏初始化cell个数                                           |
| -------- | ----------------- | ------------------------------------------------------------ |
| 10.3.1   | 与设备无关        | 按显示需要初始化个数。即cell高度越大，初始化cell的个数越少。 |
| 11.1     | iPhone 6s         | （1）cell高度比默认cell高度（不指定高度）小，按显示需要初始化个数；（2）否则，初始化固定数量14个 |
| 11.1     | iPhone 6s Plus    | （1）cell高度比默认cell高度（不指定高度）小，按显示需要初始化个数；（2）否则，初始化固定数量16个 |
| 12.2     | iPhone 7          | （1）cell高度比默认cell高度（不指定高度）小，按显示需要初始化个数；（2）否则，初始化固定数量14个 |
| 12.2     | iPhone 7 Plus     | （1）cell高度比默认cell高度（不指定高度）小，按显示需要初始化个数；（2）否则，初始化固定数量16个 |
| 12.2     | iPhone X          | （1）cell高度比默认cell高度（不指定高度）小，按显示需要初始化个数；（2）否则，初始化固定数量17个 |
| 13.1     | iPhone 11         | （1）cell高度比默认cell高度（不指定高度）小，按显示需要初始化个数；（2）否则，初始化固定数量19个 |
| 13.1     | iPhone 11 Pro Max | （1）cell高度比默认cell高度（不指定高度）小，按显示需要初始化个数；（2）否则，初始化固定数量19个 |
| 13.3     | iPhone 11         | （1）cell高度比默认cell高度（不指定高度）小，按显示需要初始化个数；（2）否则，初始化固定数量19个 |
| 13.3     | iPhone 11 Pro Max | （1）cell高度比默认cell高度（不指定高度）小，按显示需要初始化个数；（2）否则，初始化固定数量19个 |

可以得出下面结论

* 10.3.1上，和设备无关，按照显示需要初始化cell个数
* 12上，至少初始化N个cell，N和设备有关
* 13上，至少初始化N个cell，N和设备无关

> 示例代码，见CheckNumberOfCellOnFirstRenderViewController



### （7）UITableViewCell上屏和离屏事件

在分析Cell上屏和离屏事件之前，先了解下面3个方法

* tableView:cellForRowAtIndexPath:方法
* tableView:willDisplayCell:forRowAtIndexPath:方法
* tableView:didEndDisplayingCell:forRowAtIndexPath:方法



#### tableView:cellForRowAtIndexPath:方法

创建和配置cell在此方法中，但是获取cell不能通过此方法，而是tableView的cellForRowAtIndexPath:方法、

> In your implementation, create and configure an appropriate cell for the given index path. Create your cell using the table view's [`dequeueReusableCellWithIdentifier:forIndexPath:`](dash-apple-api://load?topic_id=1614878&language=occ) method, which recycles or creates the cell for you. After creating the cell, update the properties of the cell with appropriate data values.
>
> Never call this method yourself. If you want to retrieve cells from your table, call the table view's [`cellForRowAtIndexPath:`](dash-apple-api://load?topic_id=1614983&language=occ) method instead.



#### tableView:willDisplayCell:forRowAtIndexPath:方法

此方法在cell显示之前，让delegate做最后的配置cell显示。在此方法返回后，系统仅设置alpha和frame，并完成需要的动画。

> A table view sends this message to its delegate just before it uses `cell` to draw a row, thereby permitting the delegate to customize the cell object before it is displayed. This method gives the delegate a chance to override state-based properties set earlier by the table view, such as selection and background color. After the delegate returns, the table view sets only the alpha and frame properties, and then only when animating rows as they slide in or out.



#### tableView:didEndDisplayingCell:forRowAtIndexPath:方法

此方法用于检查cell从table view移除的事件，和检测cell是否显示是不同的。

> Use this method to detect when a cell is removed from a table view, as opposed to monitoring the view itself to see when it appears or disappears.



​        从官方文档上看，cellForRowAtIndexPath:方法不适合用于cell上屏时机。而其他两个方法，无明确说明，能用于上屏和离屏时机。



#### cell离屏时机

##### a. 首次渲染的情况

​       根据“UITableView首屏初始化cell个数”这一节，可以知道在iOS 11+后，cell初始化个数不再是按照显示需要，而是固定的个数。因此，首次渲染的情况，存在所有固定个数的cell都掉调用了willDisplayCell方法，然后不在屏幕上的cell再调用didEndDisplayingCell方法。输出日志，如下

```shell
cellForRow: row: 0, section: 0
onscreen: row: 0, section: 0
cellForRow: row: 1, section: 0
onscreen: row: 1, section: 0
cellForRow: row: 2, section: 0
onscreen: row: 2, section: 0
cellForRow: row: 3, section: 0
onscreen: row: 3, section: 0
cellForRow: row: 4, section: 0
onscreen: row: 4, section: 0
cellForRow: row: 5, section: 0
onscreen: row: 5, section: 0
cellForRow: row: 6, section: 0
onscreen: row: 6, section: 0
cellForRow: row: 7, section: 0
onscreen: row: 7, section: 0
cellForRow: row: 8, section: 0
onscreen: row: 8, section: 0
cellForRow: row: 9, section: 0
onscreen: row: 9, section: 0
cellForRow: row: 10, section: 0
onscreen: row: 10, section: 0
cellForRow: row: 11, section: 0
onscreen: row: 11, section: 0
cellForRow: row: 12, section: 0
onscreen: row: 12, section: 0
cellForRow: row: 13, section: 0
onscreen: row: 13, section: 0
cellForRow: row: 14, section: 0
onscreen: row: 14, section: 0
cellForRow: row: 15, section: 0
onscreen: row: 15, section: 0
cellForRow: row: 16, section: 0
onscreen: row: 16, section: 0
offscreen: row: 3, section: 0
offscreen: row: 4, section: 0
offscreen: row: 5, section: 0
offscreen: row: 6, section: 0
offscreen: row: 7, section: 0
offscreen: row: 8, section: 0
offscreen: row: 9, section: 0
offscreen: row: 10, section: 0
offscreen: row: 11, section: 0
offscreen: row: 12, section: 0
offscreen: row: 13, section: 0
offscreen: row: 14, section: 0
offscreen: row: 15, section: 0
offscreen: row: 16, section: 0
```



##### b. cell被刷新的情况

​      UITableViewDelegate提供`-tableView:didEndDisplayingCell:forRowAtIndexPath:`方法用于检测cell移除UITableView的事件。但是当某个cell被reload或者replace时，该方法会被调用，因此需要修正这种情况。

示例代码，如下

```objective-c
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.indexPathsForVisibleRows indexOfObject:indexPath] == NSNotFound) {
        // This indeed is an indexPath no longer visible
        // Do something to this non-visible cell...
    }
}
```



#### cell上屏时机

```objective-c
- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([tableView.indexPathsForVisibleRows indexOfObject:indexPath] != NSNotFound) {
        NSLog(@"onscreen: %@", NSStringFromIndexPath(indexPath));
    }
}
```

​      当table view首次渲染时，iOS 11+后，初始化固定个数的cell都会调用此方法，因此需要增加if判断过滤这种情况。



### （8）修改cell的系统checkmark颜色

当table view处于编辑状态时，允许多选，在cell左侧会出现圆形checkmark图标，这个不同于设置cell的editingAccessoryType为UITableViewCellAccessoryCheckmark。

这个checkmark图标，对应的是UITableViewCellEditControl。可以通过修改它的tintColor来改变图标的颜色。

注意：

> UITableViewCellEditControl并不总是存在的，仅当处于编辑状态，UITableViewCellEditControl才实例化出来。

> 示例代码，见TintSystemCheckmarkCellViewController



## 3、UITableView常见问题



### （1）selectRowAtIndexPath方法不触发didSelectRowAtIndexPath方法

​       `selectRowAtIndexPath:indexPath:`调用不会触发`didSelectRowAtIndexPath:index:`[^4]，如果要触发，需要手动调用一下。

```objective-c
[[tableView delegate] tableView:tableView didSelectRowAtIndexPath:index];
```

官方文档描述，如下

> Calling this method does not cause the delegate to receive a [`tableView:willSelectRowAtIndexPath:`](dash-apple-api://load?topic_id=1614943&language=occ) or [`tableView:didSelectRowAtIndexPath:`](dash-apple-api://load?topic_id=1614877&language=occ) message, nor does it send [`UITableViewSelectionDidChangeNotification`](dash-apple-api://load?request_key=hc8FRRfKne#dash_1614958) notifications to observers.



### （2）viewDidLayoutSubviews和viewDidAppear中获取contentSize不一样

​      iOS 11上，UITableView引入高度估算的能力，默认是开启。contentSize的初始值是估算的值，不是最终的值，把每个cell的高度计算，放在UITableView滑动的时候。Apple Forum的回答，如下

> In iOS 11, table views use estimated heights by default. This means that the contentSize is just as estimated value initially. If you need to use the contentSize, you’ll want to disable estimated heights by setting the 3 estimated height properties to zero: tableView.estimatedRowHeight = 0 tableView.estimatedSectionHeaderHeight = 0 tableView.estimatedSectionFooterHeight = 0



### （3）iOS 11+上调用tableView:cellForRowAtIndexPath:之后，系统修改cell高度为44

​        iOS 11+上面，系统调用tableView:cellForRowAtIndexPath:后，会将cell高度修改为44，即使cell初始化有自定义的高度，也会被修改。因此，在tableView:heightForRowAtIndexPath:方法中，不能以cell的frame高度作为返回值。

> 示例代码，见StaticCellHeightAboveiOS11IssuesViewController



### （4）reloadRowsAtIndexPaths:withRowAnimation:方法抛出异常的问题

​       UITableView调用reloadRowsAtIndexPaths:withRowAnimation:方法，当indexPaths参数，和dataSource已存在的数据不一致的时候，会抛出下面的异常，如下

```shell
2020-09-03 23:44:01.245799+0800 HelloUITableView[7952:125161] *** Assertion failure in -[UITableView _endCellAnimationsWithContext:], /BuildRoot/Library/Caches/com.apple.xbs/Sources/UIKit_Sim/UIKit-3698.21.8/UITableView.m:1683
2020-09-03 23:44:01.250828+0800 HelloUITableView[7952:125161] *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'attempt to delete row 0 from section 0, but there are only 0 sections before the update'
*** First throw call stack:
(
	0   CoreFoundation                      0x0000000106af51ab __exceptionPreprocess + 171
	1   libobjc.A.dylib                     0x000000010618af41 objc_exception_throw + 48
	2   CoreFoundation                      0x0000000106afa372 +[NSException raise:format:arguments:] + 98
	3   Foundation                          0x0000000105c2f089 -[NSAssertionHandler handleFailureInMethod:object:file:lineNumber:description:] + 193
	4   UIKit                               0x0000000107a3909a -[UITableView _endCellAnimationsWithContext:] + 5558
	5   UIKit                               0x0000000107a582e4 -[UITableView _updateRowsAtIndexPaths:withUpdateAction:rowAnimation:usingPresentationValues:] + 1342
	6   UIKit                               0x0000000107a5869d -[UITableView reloadRowsAtIndexPaths:withRowAnimation:] + 133
...
)
libc++abi.dylib: terminating with uncaught exception of type NSException
```



解决方法，是检查indexPaths参数中所有indexPath的section和row，是否在dataSource的section和row的范围内，如果不在范围内，则不能调用reloadRowsAtIndexPaths:withRowAnimation:方法。

> 1. 参考+[WCTableViewTool checkWithTableView:canReloadRowsAtIndexPaths:]工具方法
> 2. 示例代码，见ReloadRowsWithEmptyListViewController



### （5）UITableViewHeaderFooterView去掉默认背景颜色

UITableViewHeaderFooterView用于section的header或者footer。设置backgroundView为[UIView new]，可以将UITableViewHeaderFooterView去掉默认背景颜色。



### （6）iOS 14+上UITableViewCell/UICollectionViewCell的subview不能接收点击事件

​        iOS 14+上Cell (UITableViewCell/UICollectionViewCell)的contentView，层级发生变化，contentView会直接覆盖cell.subview之上。而iOS 13-之前，cell.subview是覆盖contentView之上。

​       下面这种写法[^8]，将在iOS14+不能使用。

```swift
cell.addSubview(textField)
```

注意

> 如果用Xcode 12之前的版本打包，则上面的代码可以安全运行在iOS 14+，但是用Xcode 12打包，则会出现上面的问题。目前没有弄明白，Xcode 12版本和iOS系统版本之间的联系。



解决方法一：使用contentView来放置subview

解决方法二[^9]：iOS 14+，将contentViewuserInteractionEnabled设置为NO。

> 示例代码，见CellContentIssueAboveiOS14ViewController



### （7）UITableView首次设置tableHeaderView的问题

​       UITableView首次设置tableHeaderView，会调用一次numberOfSectionsInTableView:方法。如果UITableView和numberOfSectionsInTableView:方法，是下面的代码结构，会导致循环调用，最终会crash。

```objective-c
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init...];
        // !!!: Firstly set tableHeaderView will call numberOfSectionsInTableView: method
        tableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 30)];
            view.backgroundColor = [UIColor yellowColor];
            view;
        });
        _tableView = tableView;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {    
    self.tableView.backgroundView = nil;
    return 1;
}
```



> 示例代码，见TableViewHeaderIssueCircularCallViewController



### （8）UITableView的beginUpdates和endUpdates没有配对使用

​      如果UITableView的beginUpdates和endUpdates没有配对使用的话，UITableView不会出现crash，但是UITableView在滚动时不再调用UITableViewDataSource的相关方法，比如tableView:cellForRowAtIndexPath:方法，导致列表上下没有cell显示而出现空白。



iOS  11开始，提供新的API，如下

```objective-c
- (void)performBatchUpdates:(void (^)(void))updates completion:(void (^)(BOOL finished))completion;
```



> 示例代码，见TableViewBeginEndUpdatesNotPairedViewController



## 4、UITableView Internals

（1）_subviewCache

UITableView内部使用UIView的私有实例变量`_subviewCache`，来存储屏幕上的UITableViewCell。`_subviewCache`是数组类型，值得注意的是，`_subviewCache`数组从0开始，cell是从下自上排列的。



## 5、iOS 11上Drag & Drop[^6]

Drag & Drop是iOS 11上引入的新特性，支持item从一个app拖拽到另一个app上。

注意：iPad支持多个app之间的Drag & Drop，而iPhone上仅支持单个app内的Drag & Drop

> All drag and drop features are available on iPad. On iPhone, drag and drop is available only within an app.



## 6、UITableView局部刷新



| 刷新方式                       | 说明                              |
| ------------------------------ | --------------------------------- |
| 全局刷新（调用reloadData方法） | UITableView使用reloadData方法，将 |
|                                |                                   |













References
--

[^1]: https://stackoverflow.com/questions/1074006/is-it-possible-to-disable-floating-headers-in-uitableview-with-uitableviewstylep

[^2]: https://stackoverflow.com/a/45242206 
[^3]: https://stackoverflow.com/questions/29364287/changing-uiscrollview-content-inset-triggers-scrollviewdidscroll

[^4]: https://stackoverflow.com/questions/2305781/iphone-didselectrowatindexpath-not-invoked
[^5]: https://stackoverflow.com/questions/14468449/the-selectedbackgroundview-modifies-the-contentview-subviews

[^6]:https://developer.apple.com/documentation/uikit/drag_and_drop

[^7]:https://stackoverflow.com/questions/63960541/can-no-longer-interact-with-content-within-uicollectionviewcell-or-uitableviewce
[^8]:https://stackoverflow.com/questions/63947042/since-updating-to-xcode-12-i-am-not-able-to-place-any-uicontrol-inside-uitablevi
[^9]:https://stackoverflow.com/a/63967596



