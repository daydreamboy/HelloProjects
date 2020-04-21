//
//  UseWKNavigationDelegateViewController.m
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/4/20.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseWKNavigationDelegateViewController.h"
#import <WebKit/WebKit.h>
#import "WCMacroTool.h"

@interface UseWKNavigationDelegateViewController () <UITextFieldDelegate, WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UITextField *textFieldInputUrl;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation UseWKNavigationDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.textFieldInputUrl];
    [self.view addSubview:self.progressView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]];
    [self.webView loadRequest:request];
    
    //[self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark - Getter

- (WKWebView *)webView {
    if (!_webView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGRect frame = CGRectMake(0, 44, screenSize.width, screenSize.height - 44);
        
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        
        _webView = webView;
    }
    
    return _webView;
}

- (UITextField *)textFieldInputUrl {
    if (!_textFieldInputUrl) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 44)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.keyboardType = UIKeyboardTypeWebSearch;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.delegate = self;
        
        _textFieldInputUrl = textField;
    }
    
    return _textFieldInputUrl;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIProgressView *view = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        view.frame = CGRectMake(0, 44, screenSize.width, 5);
        view.progressTintColor = [UIColor orangeColor];
        
        _progressView = view;
    }
    
    return _progressView;
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
        [self.webView loadRequest:request];
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - WKUIDelegate


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
    completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, challenge.proposedCredential);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"_cmd: %@, error: %@", NSStringFromSelector(_cmd), error);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"_cmd: %@, %@", NSStringFromSelector(_cmd), [self NSStringFromWKNavigationType:navigationAction.navigationType]);
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (NSString *)NSStringFromWKNavigationType:(WKNavigationType)type {
    NSString *typeString = @"Unknown";
    switch (type) {
        case WKNavigationTypeLinkActivated:
            typeString = @"WKNavigationTypeLinkActivated";
            break;
        case WKNavigationTypeFormSubmitted:
            typeString = @"WKNavigationTypeFormSubmitted";
            break;
        case WKNavigationTypeBackForward:
            typeString = @"WKNavigationTypeBackForward";
            break;
        case WKNavigationTypeReload:
            typeString = @"WKNavigationTypeReload";
            break;
        case WKNavigationTypeFormResubmitted:
            typeString = @"WKNavigationTypeFormResubmitted";
            break;
        case WKNavigationTypeOther:
            typeString = @"WKNavigationTypeOther";
            break;
        default:
            break;
    }
    
    return typeString;
}

@end
