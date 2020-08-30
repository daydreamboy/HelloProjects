# WebView

[TOC]

## 1、WKWebView vs. UIWebView

WKWebView是iOS 8+开始引入的，用于取代UIWebView。

NSHipster的这篇比较详细的比较了WKWebView和UIWebView。本文做一些简单归纳。



### Structure

| UIWebView                       | WKWebView                                      |
| ------------------------------- | ---------------------------------------------- |
| UIScrollView *scrollView        | UIScrollView *scrollView                       |
|                                 | WKWebViewConfiguration *configuration          |
| id\<UIWebViewDelegate> delegate | id\<WKNavigationDelegate> navigationDelegate   |
|                                 | id\<WKUIDelegate> UIDelegate                   |
|                                 | var backForwardList: WKBackForwardList { get } |

WKWebView多出了Configuration概念，以及将导航和UI拆分为2个delegate。



### Loading

| UIWebView                                                    | WKWebView                                                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| func loadRequest(request: URLRequest)                        | func load(_ request: URLRequest) -> WKNavigation?            |
| func loadHTMLString(string: String, baseURL: URL?)           | func loadHTMLString(_: String, baseURL: URL?) -> WKNavigation? |
| func loadData(_ data: Data, mimeType: String, characterEncodingName: String, baseURL: URL) -> WKNavigation? |                                                              |
|                                                              | var estimatedProgress: Double { get }                        |
|                                                              | var hasOnlySecureContent: Bool { get }                       |
| func reload()                                                | func reload() -> WKNavigation?                               |
|                                                              | func reloadFromOrigin(Any?) -> WKNavigation?                 |
| func stopLoading()                                           | func stopLoading()                                           |
| var request: URLRequest? { get }                             |                                                              |
|                                                              | var URL: URL? { get }                                        |
|                                                              | var title: String? { get }                                   |



### History

| UIWebView                      | WKWebView                                                    |
| ------------------------------ | ------------------------------------------------------------ |
|                                | func goToBackForwardListItem(item: WKBackForwardListItem) -> WKNavigation? |
| func goBack()                  | func goBack() -> WKNavigation?                               |
| func goForward()               | func goForward() -> WKNavigation?                            |
| var canGoBack: Bool { get }    | `var canGoBack: Bool { get }`                                |
| var canGoForward: Bool { get } | var canGoForward: Bool { get }                               |
| var loading: Bool { get }      | var loading: Bool { get }                                    |



### Javascript Evaluation

| UIWebView                                                    | WKWebView                                                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| func stringByEvaluatingJavaScriptFromString(script: String) -> String |                                                              |
|                                                              | func evaluateJavaScript(_ javaScriptString: String, completionHandler: ((AnyObject?, NSError?) -> Void)?) |

WKWebView执行JavaScript代码，不再是同步方法，改成异步的方式。



### Miscellaneous

| UIWebView                                   | WKWebView                                     |
| ------------------------------------------- | --------------------------------------------- |
| var keyboardDisplayRequiresUserAction: Bool |                                               |
| var scalesPageToFit: Bool                   |                                               |
|                                             | var allowsBackForwardNavigationGestures: Bool |



### Pagination

| UIWebView | WKWebView                                               |
| --------- | ------------------------------------------------------- |
|           | var paginationMode: UIWebPaginationMode                 |
|           | var paginationBreakingMode: UIWebPaginationBreakingMode |
|           | var pageLength: CGFloat                                 |
|           | var gapBetweenPages: CGFloat                            |
|           | var pageCount: Int { get }                              |



## 2、WKWebView

和UIWebView的delegate不同，WKWebView有两个类型的delegate，分别是WKUIDelegate和WKNavigationDelegate。



### （1）WKUIDelegate





### （2）WKNavigationDelegate

#### 页面加载周期[^1]

```objective-c
// 页面开始加载时调用（请求已发送到服务端，但没有收到数据回来）
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;
// 当内容开始返回时调用（请求已发送到服务端，并开始收到页面数据）
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation;
// 页面加载完成之后调用（请求已发送到服务端，并完成页面上的所有数据）
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;
// 页面加载失败时调用，例如未收到服务端的响应，127.0.0.1:8080的本地服务端没有开启。
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation;
```



#### 页面跳转拦截[^4]

```objective-c
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation;
// 在收到服务端响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
```

注意：decisionHandler只能调用一次，不能多次调用，否则会出现异常`*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Completion handler passed to -[xxx webView:decidePolicyForNavigationAction:decisionHandler:] was called more than once'***`





### （3）WKUserContentController

创建WKWebView时，使用WKUserContentController管理用户的脚本。



### （4）WKWebViewConfiguration



### （5）常见问题

#### WKWebView设置allowsLinkPreview为NO后，长按变成单击

问题：WKWebView设置allowsLinkPreview为NO后，长按变成单击。即使长按拖出区域，还是单击效果。

解决方法：不要设置设置allowsLinkPreview为NO，还是默认YES，使用下面JS代码设置用户不能选中内容，如下

```javascript
// iOS 13+
document.documentElement.style.webkitUserSelect='none';
// iOS 12-
document.body.style.webkitUserSelect='none';
```



#### WKWebView变成普通UIView

WKWebView默认有些行为，使得它和普通UIView不一样。主要有下面特性

| 特性         | 禁用方式                                                     |
| ------------ | ------------------------------------------------------------ |
| 长按可以预览 | allowsLinkPreview=YES或者iOS13上设置document.documentElement.style.webkitTouchCallout='none'; |
| 可以选中内容 | document.documentElement.style.webkitUserSelect='none';<br/>document.body.style.webkitUserSelect='none'; |
| 长按有放大镜 | WebView添加小于0.5的长按手势，iOS 13上无放大镜               |



iOS 13上有两种方法可以解决长按预览和选中内容：

1. JS代码禁用UserSelect和TouchCallout
2. Native代码设置allowsLinkPreview为YES（效果和禁用TouchCallout一样），但是存在长按变单击问题，因此需要Hook WKWebView的长按手势，使其不能生效，但是Hook成功后，会出现可以选中内容的情况，还需要禁用UserSelect。最后解决方案是：allowsLinkPreview设置为YES + Hook长按手势 + 禁用UserSelect

比较而言，第一种方法要好一些。



说明

> 1. 示例代码，见WebViewFakeUIViewWKViewController
> 2. Hook WKWebView的长按手势，见disableLongPressWithWKWebView方法。注意：初始化WebView时不能调用该方法，因为WKWebView还没有手势。
> 3. iOS 12之前版本使用Hook方式，JS的document.body.style.webkitTouchCallout='none';不起作用。





## 3、UIWebView



```objective-c
typedef NS_ENUM(NSInteger, UIWebViewNavigationType) {
    UIWebViewNavigationTypeLinkClicked,
    UIWebViewNavigationTypeFormSubmitted,
    UIWebViewNavigationTypeBackForward,
    UIWebViewNavigationTypeReload,
    UIWebViewNavigationTypeFormResubmitted,
    UIWebViewNavigationTypeOther
} API_UNAVAILABLE(tvos);
```



## 4、配置Mobile Web页面

### （1）设置viewport[^2]

viewport是页面的可视区域，并不是整个页面，因为页面还有滚动条等。

viewport是head标签的一个meta标签。如下

```html
<meta name="viewport" content="<property list>">
```

content是用`;`或`,`或空格分隔的属性列表。

有下面的属性[^3]，如下

| Property      | Default Value         | Minimum Value | Maximum Value | 说明                                 |
| ------------- | --------------------- | ------------- | ------------- | ------------------------------------ |
| width         | 980                   | 200           | 10000         | 特殊值：device-width，WebView的宽度  |
| height        | based on aspect ratio | 223           | 10000         | 特殊值：device-height，WebView的高度 |
| initial-scale | fit to screen         | minimum-scale | maximum-scale |                                      |
| user-scalable | yes                   | no            | yes           |                                      |
| minimum-scale | 0.25                  | > 0           | 10            |                                      |
| maximum-scale | 1.6                   | >0            | 10            |                                      |



### （2）CSS长度单位和Native长度单位换算

html元素的style设置width为100px，对应在WebView中的渲染实际是width为100pt。

> 见div.html



## 5、同层渲染技术

同层渲染技术，最早开始在微信小程序中应用，这篇文章[^5]介绍了同层渲染的基本原理。

本文简单描述下同层渲染的基本过程。

​        同层渲染实际是WKWebView和NativeView组合一起显示，可以想到的做法是一层是WKWebView，上面一层是NativeView，但是这种方式非常有局限性，例如WKWebView中列表滚动，上面NativeView这一层，有个播放器也需要跟着滚动，这个实现起来非常困难。

​       同层渲染的“同层”概念，是将NativeView也放在WKWebView层级中，这样是同一层，WKWebView中标签view和NativeView可以自然实现遮挡、滚动等功能。能在WKWebView中插入NativeView的原因是，WKWebView渲染是有一些WKCompositingView组合渲染而成，因此如果能强行让某个html标签变成WKCompositingView，在native中识别出这个WKCompositingView，这样就可以插入任意的native view。

说明

> 由于UIWebView是直接绘制在UIWebBrowserView上，因此无法实现同层渲染。



根据上面思路，有两种方式

* 设置标签的CSS样式，让WKWebView自动生成对应的WKCompositingView
* 修改WebKit渲染过程，识别特定标签，生成对应的WKCompositingView

说明

> 第二方式比较复杂，只介绍流程，如下
>
> ```
>                                 （强制<object>标签分层）                             (Insert NativeView)
> HTML => HTML Parser => DOM Tree ======================> Render Tree => Render Tree ====================> Paint
> ```
>
> 



### 设置CSS样式强制对应WKCompositingView

文章[^5]提到设置下面的CSS样式`overflow: scroll; -webkit-overflow-scrolling: touc`，可以强制生成对应的WKChildScrollView

```html
<div id="native_view" style="font-size: 50px; overflow: scroll; -webkit-overflow-scrolling: touch">
  Hello, world!(Not work)
</div>
```

实际上，实验并没有效果。



文章[^6]提到设置`position: fixed`，可以强制分层，生成对应WKCompositingView

```html
<div id="native_view" style="position: fixed; font-size: 20px; width: 100; height: 40;">
  Hello, world!(Work)
</div>
```



当标签可以独立成一个View后，可以通过监听WKWebView渲染完成的事件，来遍历WKWebView，找到对应的View。

遍历代码如下

```objective-c
- (UIView *)find_native_view {
    __block UIView *viewToFind = nil;
    
    [WCViewTool enumerateSubviewsInView:self.webView enumerateIncludeView:NO usingBlock:^(UIView * _Nonnull subview, BOOL * _Nonnull stop) {
        if ([@"WKCompositingView" isEqualToString:NSStringFromClass([subview class])]) {
            if ([subview.layer.name isEqualToString:@" <div> id='native_view'"]) {
                viewToFind = subview;
                *stop = YES;
            }
        }
    }];
    
    return viewToFind;
}
```

> 示例代码，见MixRenderWKViewController



说明

> WKWebView渲染完成的事件，官方文档并没有提供API。目前页面加载的事件有
>
> * 监听isLoading属性
> * -[WKNavigationDelegate webView:didFinishNavigation:]方法
> * 监听WKWebView.scrollView的contentSize变化
>
> 前2个方式，当WKWebView渲染并未完成，就已经调用[^7]。而第3种方式，contentSize变化的可能会调用多次，需要判断old和new是否一样，contentSize不再变化时，判断出WKWebView渲染完成







## References

[^1]:https://learnappmaking.com/wkwebview-how-to/

[^2]:https://developer.mozilla.org/en-US/docs/Mozilla/Mobile/Viewport_meta_tag
[^3]:https://www.htmlgoodies.com/beyond/webmaster/toolbox/article.php/3889591/Detect-and-Set-the-iPhone--iPads-Viewport-Orientation-Using-JavaScript-CSS-and-Meta-Tags.htm
[^4]:https://juejin.im/entry/5940f449fe88c2006a48cb8d

[^5]:https://developers.weixin.qq.com/community/develop/article/doc/000c4e433707c072c1793e56f5c813
[^6]:https://blog.z6z8.cn/2020/01/13/%E5%B0%8F%E7%A8%8B%E5%BA%8F%E5%90%8C%E5%B1%82%E6%B8%B2%E6%9F%93-ios-wkwebview%E5%AE%9E%E7%8E%B0/
[^7]:https://stackoverflow.com/questions/30291534/wkwebview-didnt-finish-loading-when-didfinishnavigation-is-called-bug-in-wkw

