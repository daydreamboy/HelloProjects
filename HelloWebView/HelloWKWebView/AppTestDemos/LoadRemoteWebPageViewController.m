//
//  LoadRemoteWebPageViewController.m
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/1/9.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "LoadRemoteWebPageViewController.h"
#import "WCMacroTool.h"
#import <WebKit/WebKit.h>

@interface LoadRemoteWebPageViewController () <UITextFieldDelegate, WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UITextField *textFieldInputUrl;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation LoadRemoteWebPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.textFieldInputUrl];
    [self.view addSubview:self.progressView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]];
    [self.webView loadRequest:request];
    
    [self setUpObserversWithWebView:self.webView];
}

- (void)dealloc {
    [self tearDownObserversWithWebView:_webView];
    // dealloc 中要正确释放 WebView。
    _webView = nil;
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

#pragma mark - KVO

- (void)setUpObserversWithWebView:(WKWebView *)webView {
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)tearDownObserversWithWebView:(WKWebView *)webView {
    [webView removeObserver:self forKeyPath:@"title"];
    [webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"title"]) {
        self.navigationItem.title = change[NSKeyValueChangeNewKey]; // 就是新的页面标题。
    }
    else if ([keyPath isEqual:@"estimatedProgress"]) {
        double progress = [change[NSKeyValueChangeNewKey] doubleValue]; //就是新的加载进度，范围是 0.0~1.0。
        // 注意加载进度可能在非主线程触发，如果有 UI 操作注意切换线程。
        if ([[NSThread currentThread] isMainThread]) {
            [self.progressView setProgress:progress animated:YES];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressView setProgress:progress animated:YES];
            });
        }
    }
}

@end
