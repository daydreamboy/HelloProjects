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
@end

@implementation FilePreviewWKViewController

- (instancetype)initWithFilePath:(NSString *)filePath {
    self = [super init];
    if (self) {
        _filePath = filePath;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    
    NSURL *fileURL = [NSURL fileURLWithPath:self.filePath];
    if (@available(iOS 9.0, *)) {
        [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    } else {
        // Fallback on earlier versions
    }
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

@end
