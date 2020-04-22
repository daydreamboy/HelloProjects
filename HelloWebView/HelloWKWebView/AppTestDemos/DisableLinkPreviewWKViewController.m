//
//  DisableLinkPreviewWKViewController.m
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/4/22.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "DisableLinkPreviewWKViewController.h"
#import <WebKit/WebKit.h>
#import "WCMacroTool.h"
#import "WCWebViewTool.h"

@interface DisableLinkPreviewWKViewController () <UITextViewDelegate, WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webViewOriginal;
@property (nonatomic, strong) WKWebView *webViewDisableByNative;
@property (nonatomic, strong) WKWebView *webViewDisableByJS;
@property (nonatomic, strong) UITextView *textViewHTMLString;
@end

@implementation DisableLinkPreviewWKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"coupon.html";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webViewOriginal];
    //[self.view addSubview:self.textViewHTMLString];
    
    self.textViewHTMLString.text = STR_OF_FILE(@"HTMLTestList/coupon.html");
    
    UIBarButtonItem *loadItem = [[UIBarButtonItem alloc] initWithTitle:@"Load" style:UIBarButtonItemStylePlain target:self action:@selector(loadItemClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[loadItem];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - Getter

- (WKWebView *)webViewOriginal {
    if (!_webViewOriginal) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 3;
        CGRect frame = CGRectMake(marginH, CGRectGetHeight(self.textViewHTMLString.frame) + 5, 400/*screenSize.width - 2 * marginH*/, 400);
        
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        webView.layer.borderColor = [UIColor orangeColor].CGColor;
        webView.layer.borderWidth = 1;
        webView.scrollView.scrollEnabled = NO;
        
//        [WCWebViewTool toggleLinkPreviewWithWKWebView:webViewOriginal enabled:NO];
        [WCWebViewTool addViewportScriptWithWKWebView:webView];
        
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
        
        _webViewOriginal = webView;
    }
    
    return _webViewOriginal;
}

- (UITextView *)textViewHTMLString {
    if (!_textViewHTMLString) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 3;
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(marginH, 0, screenSize.width - 2 * marginH, 200)];
        textView.keyboardType = UIKeyboardTypeWebSearch;
        textView.autocorrectionType = UITextAutocorrectionTypeNo;
        textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textView.delegate = self;
        textView.layer.borderColor = [UIColor grayColor].CGColor;
        textView.layer.borderWidth = 1;
        
        _textViewHTMLString = textView;
    }
    
    return _textViewHTMLString;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *url;
    if (STR_TRIM_IF_NOT_EMPTY(textField.text)) {
        if ([textField.text hasPrefix:@"http://"] || [textField.text hasPrefix:@"https://"]) {
            url = textField.text;
        }
        else {
            url = [NSString stringWithFormat:@"https://%@", textField.text];
        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webViewOriginal loadRequest:request];
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - WKUIDelegate

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
    
    // Disable user selection
//    webView.stringByEvaluatingJavaScriptFromString("document.documentElement.style.webkitUserSelect='none'")!
//    // Disable callout
//    webView.stringByEvaluatingJavaScriptFromString("document.documentElement.style.webkitTouchCallout='none'")!
//
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
            
            // @see https://stackoverflow.com/a/12694403
            [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
            [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
            [webView evaluateJavaScript:@"document.body.style.webkitUserSelect='none';" completionHandler:nil];
            [webView evaluateJavaScript:@"document.body.style.webkitTouchCallout='none';" completionHandler:nil];
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
    if (self.textViewHTMLString.text.length) {
        //self.webView.frame = FrameSetSize(self.webView.frame, NAN, 0);
        [self.webViewOriginal loadHTMLString:self.textViewHTMLString.text baseURL:nil];
    }
}

@end
