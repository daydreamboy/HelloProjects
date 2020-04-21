//
//  HTMLCodePreviewUIViewController.m
//  HelloUIWebView
//
//  Created by wesley_chen on 2020/4/21.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "HTMLCodePreviewUIViewController.h"
#import "WCMacroTool.h"
#import "YWHybridWebView.h"

static float sStart;
static float sEnd;

@interface HTMLCodePreviewUIViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *HTMLString;
@end

@implementation HTMLCodePreviewUIViewController

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

- (UIWebView *)webView {
    if (!_webView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 3;
        CGRect frame = CGRectMake(marginH, 0, screenSize.width - 2 * marginH, 60);
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
        webView.delegate = self;
        webView.layer.borderColor = [UIColor orangeColor].CGColor;
        webView.layer.borderWidth = 1;
        webView.opaque = NO;
        webView.backgroundColor = [UIColor clearColor];
        
        _webView = webView;
    }
    
    return _webView;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    sStart = CACurrentMediaTime();
    NSLog(@"start: %f", sStart);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    sEnd = CACurrentMediaTime();
    NSLog(@"end: %f", sEnd);
    NSLog(@"duration: %f", sEnd - sStart);
    
    NSString *readyState = [self.webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    NSString *scrollHeight = [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];

    NSLog(@"scrollHeight: %@", scrollHeight);
    self.webView.frame = FrameSetSize(self.webView.frame, NAN, [scrollHeight doubleValue]);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    SHOW_ALERT(@"An error occurred", [error description], @"I'll check", nil);
}

#pragma mark - KVO

#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if( [keyPath isEqualToString:@"contentSize"] ) {
        NSValue *newValue = change[NSKeyValueChangeNewKey];
        NSValue *oldValue = change[NSKeyValueChangeOldKey];
        
        CGSize newContentSize = [newValue CGSizeValue];
        CGSize oldContentSize = [oldValue CGSizeValue];
        
        NSLog(@"newContentSize: %@, oldContentSize: %@", NSStringFromCGSize(newContentSize), NSStringFromCGSize(oldContentSize));
        
        if (newContentSize.height > 0 && !CGSizeEqualToSize(newContentSize, oldContentSize)) {
        }
    }
}

@end
