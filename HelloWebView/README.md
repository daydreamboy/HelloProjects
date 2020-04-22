# WebView

[TOC]

## 1、WKWebView vs. UIWebView



### Structure

| UIWebView                       | WKWebView                                    |
| ------------------------------- | -------------------------------------------- |
| UIScrollView *scrollView        | UIScrollView *scrollView                     |
|                                 | WKWebViewConfiguration *configuration        |
| id\<UIWebViewDelegate> delegate | id\<WKNavigationDelegate> navigationDelegate |
|                                 | id\<WKUIDelegate> UIDelegate                 |









## 2、WKWebView

和UIWebView的delegate不同，WKWebView有两个类型的delegate，分别是WKUIDelegate和WKNavigationDelegate。



### （1）WKUIDelegate





### （2）WKNavigationDelegate

#### 页面加载周期[^1]



WebView决定是否处理URL请求

```objective-c
-[WKNavigationDelegate webView:decidePolicyForNavigationAction:decisionHandler:]
```



WebView的URL请求已发送到服务端，但没有收到数据回来。

```objective-c
-[WKNavigationDelegate webView:didStartProvisionalNavigation:]
```



WebView的URL请求已发送到服务端，并开始收到页面数据

```objective-c
-[WKNavigationDelegate webView:didCommitNavigation:]
```



WebView的URL请求已发送到服务端，并完成页面上的所有数据

```objective-c
-[WKNavigationDelegate webView:didFinishNavigation:]
```



WebView的URL请求未收到服务端的响应，例如127.0.0.1:8080的本地服务端没有开启。

```objective-c
-[WKNavigationDelegate webView:didFailProvisionalNavigation:withError:]
```







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

### （1）Web页面设置

viewport

https://developer.mozilla.org/en-US/docs/Mozilla/Mobile/Viewport_meta_tag



### （2）CSS长度单位和Native长度单位换算

html元素的style设置width为100px，对应在WebView中的渲染实际是width为100pt。

> 见div.html





## References

[^1]:https://learnappmaking.com/wkwebview-how-to/



