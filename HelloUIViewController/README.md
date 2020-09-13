# UIViewController

[TOC]

## 1、介绍UIViewController

官方文档，对View Controller的作用，如下

> Manage your interface using view controllers and facilitate navigation around your app's content.

简单来说，是使用View Controller来管理UI界面，以及在多个内容（界面）之间进行导航更加容易



每个app的main window至少需要一个View Controller。如果屏幕有多个内容，则需要多个View Controller对应的内容。

> Every app has at least one view controller whose content fills the main window. If your app has more content than can fit onscreen at once, use multiple view controllers to manage different parts of that content.







## 2、UIViewController分类

### （1）分类总表

根据UIViewController的用途，可以有下面分类[^2]

| 类型                       | 举例                                                         | 说明                  |
| -------------------------- | ------------------------------------------------------------ | --------------------- |
| Content View Controllers   | [`UIViewController`](https://developer.apple.com/documentation/uikit/uiviewcontroller?language=objc)<br/>[`UITableViewController`](https://developer.apple.com/documentation/uikit/uitableviewcontroller?language=objc)<br/>[`UICollectionViewController`](https://developer.apple.com/documentation/uikit/uicollectionviewcontroller?language=objc) | 内容型View Controller |
| Container View Controllers | [`UISplitViewController`](https://developer.apple.com/documentation/uikit/uisplitviewcontroller?language=objc)<br/>[`UINavigationController`](https://developer.apple.com/documentation/uikit/uinavigationcontroller?language=objc)<br/>[`UITabBarController`](https://developer.apple.com/documentation/uikit/uitabbarcontroller?language=objc)<br/>[`UIPageViewController`](https://developer.apple.com/documentation/uikit/uipageviewcontroller?language=objc) | 容器型View Controller |
| Presentation               | [`UIPresentationController`](https://developer.apple.com/documentation/uikit/uipresentationcontroller?language=objc) |                       |
| Search Interface           | [`UISearchContainerViewController`](https://developer.apple.com/documentation/uikit/uisearchcontainerviewcontroller?language=objc)<br/>[`UISearchController`](https://developer.apple.com/documentation/uikit/uisearchcontroller?language=objc) |                       |
| Images and Video           | [`UIImagePickerController`](https://developer.apple.com/documentation/uikit/uiimagepickercontroller?language=objc)<br/>[`UIVideoEditorController`](https://developer.apple.com/documentation/uikit/uivideoeditorcontroller?language=objc) |                       |
| Documents and Directories  | [`UIDocumentBrowserViewController`](https://developer.apple.com/documentation/uikit/uidocumentbrowserviewcontroller?language=objc)<br/>[`UIDocumentPickerViewController`](https://developer.apple.com/documentation/uikit/uidocumentpickerviewcontroller?language=objc)<br/>[`UIDocumentInteractionController`](https://developer.apple.com/documentation/uikit/uidocumentinteractioncontroller?language=objc) |                       |
| iCloud Sharing             | [`UICloudSharingController`](https://developer.apple.com/documentation/uikit/uicloudsharingcontroller?language=objc) |                       |
| Activities Interface       | [`UIActivityViewController`](https://developer.apple.com/documentation/uikit/uiactivityviewcontroller?language=objc) |                       |
| Font Picker                | [`UIFontPickerViewController`](https://developer.apple.com/documentation/uikit/uifontpickerviewcontroller?language=objc) |                       |
| Color Picker               | [`UIColorPickerViewController`](https://developer.apple.com/documentation/uikit/uicolorpickerviewcontroller?language=objc) | iOS 14+               |
| Word Lookup                | [`UIReferenceLibraryViewController`](https://developer.apple.com/documentation/uikit/uireferencelibraryviewcontroller?language=objc) |                       |
| Printer Picker             | [`UIPrinterPickerController`](https://developer.apple.com/documentation/uikit/uiprinterpickercontroller?language=objc) |                       |







### （2）Container View Controller

根据UIViewController是否容器型，可以有下面分类

| 类型                      | 作用                          | 说明                       |
| ------------------------- | ----------------------------- | -------------------------- |
| Container View Controller | 管理多个Child View Controller | 例如UINavigationController |
| Child View Controller     | 普通的View Controller         |                            |



UIKit提供一些通用的Container View Controller，它实现了特定导航模型（Navigation Model）[^1]，如下

<img src="images/Nagivation Model.png" style="zoom:50%;" />

#### UINavigationController (*navigation interface*)

​       管理Child View Controller的栈，通过Push新的View Controller来替换栈顶上之前的View Controller，通过Pop栈顶上的View Controller来显示它下面的View Controller。

> [`UINavigationController`](https://developer.apple.com/documentation/uikit/uinavigationcontroller?language=objc) manages a stack of child view controllers in a *navigation interface*. Pushing a new view controller onto the stack replaces the previous view controller. Popping a view controller reveals the view controller underneath.



#### UISplitViewController (*split-view interface*)

​        如果空间足够，并排放置两个Child View Controller（如果空间不够，则采用Navigation方式（Navigation Interface））。这种方式也称为primary-detail界面

> [`UISplitViewController`](https://developer.apple.com/documentation/uikit/uisplitviewcontroller?language=objc) manages two child view controllers side-by-side (when space is available) in a *split-view interface*. (When space is constrained, the system displays those view controllers in a navigation interface.) This type of interface is also known as a primary-detail interface.



#### UITabBarController (*tab-bar interface*)

显示一组按钮，当选中某个按钮，界面显示和这个按钮关联的Child View Controller

> [`UITabBarController`](https://developer.apple.com/documentation/uikit/uitabbarcontroller?language=objc) displays a row of buttons along the bottom of a *tab-bar interface*. Selecting a button displays the child view controller associated with that button.



#### UIPageViewController (*paged interface*)

关联一组有序的Child  View Controller，一次显示1个或2个View Controller。通过轻扫或点击，在Child  View Controller之间导航。

> [`UIPageViewController`](https://developer.apple.com/documentation/uikit/uipageviewcontroller?language=objc) manages an ordered sequence of child view controllers, presenting only one or two at a time, in a *paged interface*. The user navigates between those view controllers by swiping or tapping.



上面几种导航模型，可以自由组合。例如UISplitViewController可以管理UINavigationController和UIViewController，如下

<img src="images/Navigation Model Combination.png" style="zoom:50%;" />





### （3）Root View Controller

Root View Controller是指UIWindow上的根View Controller，它和UIWindow的关系，如下



<img src="images/Root View Controller.png" style="zoom:50%;" />



如果Root View Controller是Container View Controller，则决定了该window的导航模型。

> The root view controller defines the initial navigation model of your window. For a scene-based app, the root view controller is the initial view controller of your scene's storyboard file. If you create your windows programmatically, assign a value to the [`rootViewController`](https://developer.apple.com/documentation/uikit/uiwindow/1621581-rootviewcontroller?language=objc) property of the window before showing the window.





















## References

[^1]:https://developer.apple.com/documentation/uikit/view_controllers/managing_content_in_your_app_s_windows?language=objc
[^2]:https://developer.apple.com/documentation/uikit/view_controllers?language=objc







