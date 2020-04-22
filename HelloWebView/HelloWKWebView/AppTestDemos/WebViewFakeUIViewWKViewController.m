//
//  WebViewFakeUIViewWKViewController.m
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/4/22.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WebViewFakeUIViewWKViewController.h"
#import <WebKit/WebKit.h>
#import "WCMacroTool.h"
#import "WCWebViewTool.h"

#define WebViewHeight 150

@interface WebViewFakeUIViewWKViewController () <WKUIDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) WKWebView *webViewOriginal;
@property (nonatomic, strong) WKWebView *webViewFakeByJS;
@property (nonatomic, strong) WKWebView *webViewFakeByHook;
@property (nonatomic, strong) NSString *HTMLString;
@end

@implementation WebViewFakeUIViewWKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"div_selection.html";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webViewOriginal];
    [self.view addSubview:self.webViewFakeByJS];
    [self.view addSubview:self.webViewFakeByHook];
    
    self.HTMLString = STR_OF_FILE(@"HTMLTestList/coupon.html");
    
    UIBarButtonItem *loadItem = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStylePlain target:self action:@selector(loadItemClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[loadItem];
    
    [self loadItemClicked:loadItem];
}

#pragma mark - Getter

- (WKWebView *)webViewOriginal {
    if (!_webViewOriginal) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 3;
        CGRect frame = CGRectMake(marginH, 5, screenSize.width - 2 * marginH, WebViewHeight);
        
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        webView.layer.borderColor = [UIColor orangeColor].CGColor;
        webView.layer.borderWidth = 1;
        webView.scrollView.scrollEnabled = NO;
        
        [WCWebViewTool addViewportScriptWithWKWebView:webView];
        
        _webViewOriginal = webView;
    }
    
    return _webViewOriginal;
}

- (WKWebView *)webViewFakeByJS {
    if (!_webViewFakeByJS) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 3;
        CGRect frame = CGRectMake(marginH, CGRectGetMaxY(_webViewOriginal.frame) + 5, screenSize.width - 2 * marginH, WebViewHeight);
        
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        webView.layer.borderColor = [UIColor orangeColor].CGColor;
        webView.layer.borderWidth = 1;
        webView.scrollView.scrollEnabled = NO;
        
        [WCWebViewTool addViewportScriptWithWKWebView:webView];
        [WCWebViewTool addDisableUserSelectUserScriptWithWKWebView:webView];
        [WCWebViewTool addDisableTouchCalloutUserScriptWithWKWebView:webView];
        // Note: no need to turn off allowLinkPreview
        //[WCWebViewTool toggleLinkPreviewWithWKWebView:webView enabled:NO];
        
        _webViewFakeByJS = webView;
    }
    
    return _webViewFakeByJS;
}

- (WKWebView *)webViewFakeByHook {
    if (!_webViewFakeByHook) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 3;
        CGRect frame = CGRectMake(marginH, CGRectGetMaxY(_webViewFakeByJS.frame) + 5, screenSize.width - 2 * marginH, WebViewHeight);
        
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        webView.layer.borderColor = [UIColor orangeColor].CGColor;
        webView.layer.borderWidth = 1;
        webView.scrollView.scrollEnabled = NO;
        
        if (!IOS13_OR_LATER) {
            // @see https://blog.csdn.net/timtian008/article/details/71634545
            // @see https://stackoverflow.com/a/32873667
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:nil];
            longPress.delegate = self;
            longPress.minimumPressDuration = 0.2;
            [webView addGestureRecognizer:longPress];
        }

        [WCWebViewTool addViewportScriptWithWKWebView:webView];
        [WCWebViewTool addDisableUserSelectUserScriptWithWKWebView:webView];
        [WCWebViewTool toggleLinkPreviewWithWKWebView:webView enabled:NO];
        
        _webViewFakeByHook = webView;
    }
    
    return _webViewFakeByHook;
}

#pragma mark - WKUIDelegate

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    if (webView == self.webViewFakeByHook) {
        [WCWebViewTool disableLongPressWithWKWebView:webView];
    }
    
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    SHOW_ALERT(@"123", @"test", @"Ok", nil);
}

#pragma mark - Action

- (void)loadItemClicked:(id)sender {
    if (self.HTMLString.length) {
        [self.webViewOriginal loadHTMLString:self.HTMLString baseURL:nil];
        [self.webViewFakeByJS loadHTMLString:self.HTMLString baseURL:nil];
        [self.webViewFakeByHook loadHTMLString:self.HTMLString baseURL:nil];
    }
}

#pragma mark - GestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

@end
