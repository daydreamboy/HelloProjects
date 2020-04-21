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

static float sStart;
static float sEnd;

@interface HTMLCodePreviewWKViewController () <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *HTMLString;
@end

@implementation HTMLCodePreviewWKViewController

- (instancetype)initWithHTMLString:(NSString *)HTMLString {
    self = [super init];
    if (self) {
        _HTMLString = HTMLString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.webView];
    
//    for (UIView *view in self.webView.subviews) {
//        if ([view isKindOfClass:[UIScrollView class]]) {
//            UIScrollView *scroll = (UIScrollView *)view;
//            scroll.alwaysBounceHorizontal = YES;
//            scroll.alwaysBounceVertical = NO;
//            break;
//        }
//    }
    
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self.webView loadHTMLString:self.HTMLString baseURL:nil];
}

#pragma mark - Getters

- (WKWebView *)webView {
    if (!_webView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 3;
        CGRect frame = CGRectMake(marginH, 0, screenSize.width - 2 * marginH, 60);
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        webView.layer.borderColor = [UIColor orangeColor].CGColor;
        webView.layer.borderWidth = 1;
        webView.opaque = NO;
        webView.backgroundColor = [UIColor clearColor];
        
        _webView = webView;
    }
    
    return _webView;
}

#pragma mark - WKNavigationDelegate

@end
