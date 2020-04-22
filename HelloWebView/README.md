# WebView

[TOC]

## 1、WKWebView vs. UIWebView



### Structure

| UIWebView                       | WKWebView                                      |
| ------------------------------- | ---------------------------------------------- |
| UIScrollView *scrollView        | UIScrollView *scrollView                       |
|                                 | WKWebViewConfiguration *configuration          |
| id\<UIWebViewDelegate> delegate | id\<WKNavigationDelegate> navigationDelegate   |
|                                 | id\<WKUIDelegate> UIDelegate                   |
|                                 | var backForwardList: WKBackForwardList { get } |



Loading

| UIWebView                                                    | WKWebView                                                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| func loadRequest(request: URLRequest)                        | `func load(_ request: URLRequest) -> WKNavigation?`          |
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



History

| UIWebView | WKWebView                                                    |
| --------- | ------------------------------------------------------------ |
|           | func goToBackForwardListItem(item: WKBackForwardListItem) -> WKNavigation? |
|           |                                                              |







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



## 4、Web页面前端

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





## References

[^1]:https://learnappmaking.com/wkwebview-how-to/

[^2]:https://developer.mozilla.org/en-US/docs/Mozilla/Mobile/Viewport_meta_tag
[^3]:https://www.htmlgoodies.com/beyond/webmaster/toolbox/article.php/3889591/Detect-and-Set-the-iPhone--iPads-Viewport-Orientation-Using-JavaScript-CSS-and-Meta-Tags.htm
[^4]:https://juejin.im/entry/5940f449fe88c2006a48cb8d



