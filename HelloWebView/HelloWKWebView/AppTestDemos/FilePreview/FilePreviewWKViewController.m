//
//  FilePreviewWKViewController.m
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/9/11.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "FilePreviewWKViewController.h"
#import <WebKit/WebKit.h>

@interface FilePreviewWKViewController () <WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation FilePreviewWKViewController

- (instancetype)initWithFilePath:(NSString *)filePath {
    self = [super init];
    if (self) {
        _filePath = filePath;
        
        self.title = [filePath lastPathComponent];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    NSURL *fileURL = [NSURL fileURLWithPath:self.filePath];
    if (@available(iOS 9.0, *)) {
        [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    }
    else {
        // Fallback on earlier versions
    }
    
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
        CGRect frame = CGRectMake(0, 0, screenSize.width, screenSize.height - 44);
        
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        
        _webView = webView;
    }
    
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIProgressView *view = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        view.frame = CGRectMake(0, 0, screenSize.width, 5);
        view.progressTintColor = [UIColor orangeColor];
        
        _progressView = view;
    }
    
    return _progressView;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

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
