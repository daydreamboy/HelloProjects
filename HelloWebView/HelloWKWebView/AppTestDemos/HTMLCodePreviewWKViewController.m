//
//  HTMLCodePreviewWKViewController.m
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/4/21.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "HTMLCodePreviewWKViewController.h"
#import "WCMacroTool.h"
#import <WebKit/WebKit.h>
#import "WCWebViewTool.h"

static NSTimeInterval sStart;
static NSTimeInterval sEnd;

@interface HTMLCodePreviewWKViewController () <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *HTMLString;
@property (nonatomic, copy) NSString *fileName;
@end

@implementation HTMLCodePreviewWKViewController

- (instancetype)initWithHTMLString:(NSString *)HTMLString fileName:(NSString *)fileName {
    self = [super init];
    if (self) {
        _HTMLString = HTMLString;
        _fileName = fileName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.fileName;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    [self.webView loadHTMLString:self.HTMLString baseURL:nil];
}

#pragma mark - Getters

- (WKWebView *)webView {
    if (!_webView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 3;
        CGRect frame = CGRectMake(marginH, 0, screenSize.width - 2 * marginH, 600);
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        webView.layer.borderColor = [UIColor orangeColor].CGColor;
        webView.layer.borderWidth = 1;
        webView.opaque = NO;
//        webView.allowsLinkPreview = NO;
        webView.backgroundColor = [UIColor clearColor];
        [WCWebViewTool addViewportScriptWithWKWebView:webView];
        
        _webView = webView;
    }
    
    return _webView;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    sStart = CACurrentMediaTime();
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    sEnd = CACurrentMediaTime();
    NSLog(@"end: %f", sEnd);
    NSLog(@"duration: %f", sEnd - sStart);
}

@end
