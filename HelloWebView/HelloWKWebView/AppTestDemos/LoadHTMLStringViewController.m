//
//  LoadHTMLStringViewController.m
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/4/21.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "LoadHTMLStringViewController.h"
#import <WebKit/WebKit.h>
#import "WCMacroTool.h"
#import "WCWebViewTool.h"

@interface LoadHTMLStringViewController () <UITextViewDelegate, WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UITextView *textViewHTMLString;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation LoadHTMLStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"coupon.html";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.textViewHTMLString];
    
    self.textViewHTMLString.text = STR_OF_FILE(@"HTMLTestList/coupon.html");
    
    UIBarButtonItem *loadItem = [[UIBarButtonItem alloc] initWithTitle:@"Load" style:UIBarButtonItemStylePlain target:self action:@selector(loadItemClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[loadItem];
}

#pragma mark - Getter

- (WKWebView *)webView {
    if (!_webView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 3;
        CGRect frame = CGRectMake(marginH, CGRectGetHeight(self.textViewHTMLString.frame) + 5, screenSize.width - 2 * marginH, 0);
        
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        webView.layer.borderColor = [UIColor orangeColor].CGColor;
        webView.layer.borderWidth = 1;
        
        [WCWebViewTool addViewportScriptWithWKWebView:webView];
        
        _webView = webView;
    }
    
    return _webView;
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

#pragma mark - Action

- (void)loadItemClicked:(id)sender {
    if (self.textViewHTMLString.text.length) {
        [self.webView loadHTMLString:self.textViewHTMLString.text baseURL:nil];
    }
}

#pragma mark - WKUIDelegate

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // @see https://stackoverflow.com/a/45674575
    [self.webView evaluateJavaScript:@"document.readyState" completionHandler:^(NSString *_Nullable readyState, NSError * _Nullable error) {
        if ([readyState isKindOfClass:[NSString class]] && [readyState isEqualToString:@"complete"]) {
            
            NSString *script = IOS13_OR_LATER ? @"document.documentElement.scrollHeight" : @"document.body.scrollHeight";
            [self.webView evaluateJavaScript:script completionHandler:^(NSNumber *_Nullable scrollHeight, NSError * _Nullable error) {
                if ([scrollHeight isKindOfClass:[NSNumber class]]) {
                    NSLog(@"scrollHeight: %@", scrollHeight);
                    self.webView.scrollView.contentSize = CGSizeMake(self.webView.scrollView.contentSize.width, [scrollHeight doubleValue]);
                    self.webView.frame = FrameSetSize(self.webView.frame, NAN, [scrollHeight doubleValue]);
                }
            }];
        }
    }];
}

@end
