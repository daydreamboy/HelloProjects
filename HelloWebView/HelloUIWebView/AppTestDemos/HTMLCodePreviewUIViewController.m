//
//  HTMLCodePreviewUIViewController.m
//  HelloUIWebView
//
//  Created by wesley_chen on 2020/4/21.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "HTMLCodePreviewUIViewController.h"
#import "WCMacroTool.h"

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
    
    [self.webView loadHTMLString:self.HTMLString baseURL:nil];
    [self.view addSubview:self.webView];
}

#pragma mark - Getters

- (UIWebView *)webView {
    if (!_webView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 3;
        CGRect frame = CGRectMake(marginH, 0, screenSize.width - 2 * marginH, screenSize.height - 44 - 64);
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
        webView.backgroundColor = [UIColor whiteColor];
        webView.delegate = self;
        webView.layer.borderColor = [UIColor orangeColor].CGColor;
        webView.layer.borderWidth = 1;
        
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
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    SHOW_ALERT(@"An error occurred", [error description], @"I'll check", nil);
}

@end
