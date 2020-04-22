//
//  DisableUserSelectWKViewController.m
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/4/22.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "DisableUserSelectWKViewController.h"
#import <WebKit/WebKit.h>
#import "WCMacroTool.h"
#import "WCWebViewTool.h"

#define WebViewHeight 150

@interface DisableUserSelectWKViewController () <WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webViewOriginal;
@property (nonatomic, strong) WKWebView *webViewDisableByJS;
@property (nonatomic, strong) NSString *HTMLString;
@end

@implementation DisableUserSelectWKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"div_selection.html";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webViewOriginal];
    [self.view addSubview:self.webViewDisableByJS];
    
    self.HTMLString = STR_OF_FILE(@"HTMLTestList/div_selection.html");
    
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

- (WKWebView *)webViewDisableByJS {
    if (!_webViewDisableByJS) {
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
        
        _webViewDisableByJS = webView;
    }
    
    return _webViewDisableByJS;
}

#pragma mark - WKUIDelegate

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
    
    // @see https://stackoverflow.com/a/45674575
    [self.webViewOriginal evaluateJavaScript:@"document.readyState" completionHandler:^(NSString *_Nullable readyState, NSError * _Nullable error) {
        if ([readyState isKindOfClass:[NSString class]] && [readyState isEqualToString:@"complete"]) {
            NSString *script = IOS13_OR_LATER ? @"document.documentElement.scrollHeight" : @"document.body.scrollHeight";
            [self.webViewOriginal evaluateJavaScript:script completionHandler:^(NSNumber *_Nullable scrollHeight, NSError * _Nullable error) {
                if ([scrollHeight isKindOfClass:[NSNumber class]]) {
                    NSLog(@"scrollHeight: %@", scrollHeight);
//                    self.webView.frame = FrameSetSize(self.webView.frame, NAN, [scrollHeight doubleValue]);
                }
            }];
        }
    }];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

        // Note: 禁用UIWebView的长按手势，避免导致长按变成单击跳转
        NSArray *subviews = [webView subviews];
        //NSString *classNameToCheck = [@[ @"W", @"K", @"S", @"c", @"r", @"o", @"l", @"l", @"V", @"i", @"e", @"w" ] componentsJoinedByString:@""];
        
        NSString *classNameToCheck = [@[ @"W", @"K", @"C", @"o", @"n", @"t", @"e", @"n", @"t", @"V", @"i", @"e", @"w" ] componentsJoinedByString:@""];
//        for (UIView *subview in subviews) {
//            if ([subview isKindOfClass:[UIView class]] && [NSStringFromClass([subview class]) isEqualToString:classNameToCheck]) {
//                for (UIGestureRecognizer *recognizer in subview.gestureRecognizers) {
//                    if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
//                        recognizer.enabled = NO;
//                    }
//                }
//                break;
//            }
//        }
        
        for (UIView *subview in subviews) {
            if ([subview isKindOfClass:[UIView class]]) {
                for (UIView *subview2 in [subview subviews]) {
                    if ([subview2 isKindOfClass:[UIView class]] && [NSStringFromClass([subview2 class]) isEqualToString:classNameToCheck]) {
                        for (UIGestureRecognizer *recognizer in subview2.gestureRecognizers) {
                            if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                                recognizer.enabled = NO;
                            }
                        }
                        break;
                    }
                }
            }
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
        [self.webViewDisableByJS loadHTMLString:self.HTMLString baseURL:nil];
    }
}

@end
