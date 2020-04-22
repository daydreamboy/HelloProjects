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
#import "WCFitHTMLContentWKWebView.h"

@interface LoadHTMLStringViewController () <UITextViewDelegate, WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WCFitHTMLContentWKWebView *webView;
@property (nonatomic, strong) UITextView *textViewHTMLString;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation LoadHTMLStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.textViewHTMLString];
    
    //[self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
    
    self.textViewHTMLString.text = STR_OF_JSON(
   <div style="min-width:180px;max-width:100px;background:#fff;margin:0;font-size:12px;line-height:16px;font-family:arial;">
       <a href="http://taoquan.taobao.com/coupon/unify_apply.htm?sellerId=263662065&activityId=4f63298a460c45cabf0553ab8ae49316" target="_blank" style="position:relative;display:block;padding:9px;background:#f2aa18;color:#fff;text-decoration:none;">
           <div style="text-align:center;font-size:12pt;margin-bottom:10px;">店铺优惠券</div>
           <div style="text-align:center;color:rgba(255,255,255,0.8);font-size:10pt;position:relative">
               <div style="position:absolute;top:7px;left:0;width:100%;height:1px;background:rgba(255,255,255,0.8);"></div>
               <span style="position:relative;padding:0 3px;background:#f2aa18;">2020.03.20 - 2020.04.30</span></div>
           <div style="display:-webkit-box;margin-top:20px;">
               <div style="-webkit-box-flex:1;">
                   <div style="font-size:12pt;">&#65509;<span style="font-size:24pt;">1</span></div>
                   <div style="font-size:10pt;margin-top:5px;">满2元使用</div>
               </div>
               <div style="width:64px;height:25px;border:1px solid #fef7ef;border-radius:3px;line-height:26px;text-align:center;font-size:10pt;margin-top:10px;">去领取</div>
           </div>
           <div style="position:absolute;width:5px;height:100%;background:url(https://img.alicdn.com/tps/TB1aPdPIVXXXXaMXFXXXXXXXXXX.png) repeat-y 0 0;top:3px;left:-2px;background-size:100%"></div>
           <div style="position:absolute;width:5px;height:100%;background:url(https://img.alicdn.com/tps/TB1aPdPIVXXXXaMXFXXXXXXXXXX.png) repeat-y 0 0;top:3px;right:-2px;background-size:100%"></div>
       </a>
   </div>
    );
    
    UIBarButtonItem *loadItem = [[UIBarButtonItem alloc] initWithTitle:@"Load" style:UIBarButtonItemStylePlain target:self action:@selector(loadItemClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[loadItem];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //self.webView.frame = FrameSetSize(self.webView.frame, NAN, CGRectGetHeight(self.view.bounds) - 200 - 44);
}

#pragma mark - Getter

- (WCFitHTMLContentWKWebView *)webView {
    if (!_webView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 3;
        CGRect frame = CGRectMake(marginH, CGRectGetHeight(self.textViewHTMLString.frame) + 5, 400/*screenSize.width - 2 * marginH*/, 1000);
        
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        WCFitHTMLContentWKWebView *webView = [[WCFitHTMLContentWKWebView alloc] initWithFrame:frame configuration:configuration];
        webView.UIDelegate = self;
//        webView.navigationDelegate = self;
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

#pragma mark - WKUIDelegate

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
    
    // @see https://stackoverflow.com/a/45674575
    [self.webView evaluateJavaScript:@"document.readyState" completionHandler:^(NSString *_Nullable readyState, NSError * _Nullable error) {
        if ([readyState isKindOfClass:[NSString class]] && [readyState isEqualToString:@"complete"]) {
            NSString *script = IOS13_OR_LATER ? @"document.documentElement.scrollHeight" : @"document.body.scrollHeight";
            [self.webView evaluateJavaScript:script completionHandler:^(NSNumber *_Nullable scrollHeight, NSError * _Nullable error) {
                if ([scrollHeight isKindOfClass:[NSNumber class]]) {
                    NSLog(@"scrollHeight: %@", scrollHeight);
//                    self.webView.frame = FrameSetSize(self.webView.frame, NAN, [scrollHeight doubleValue]);
                }
            }];
        }
    }];
}

#pragma mark - Action

- (void)loadItemClicked:(id)sender {
    if (self.textViewHTMLString.text.length) {
        //self.webView.frame = FrameSetSize(self.webView.frame, NAN, 0);
        [self.webView loadHTMLString:self.textViewHTMLString.text baseURL:nil];
    }
}

@end
