//
//  MixRenderWKViewController.m
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/8/30.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "MixRenderWKViewController.h"
#import "WCMacroTool.h"
#import "WCWebViewTool.h"
#import "WCViewTool.h"
#import <WebKit/WebKit.h>

#define WebViewHeight 150

@interface MixRenderWKViewController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *HTMLString;
@property (nonatomic, strong) NSString *fileName;
@end

@implementation MixRenderWKViewController

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
        
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    UIBarButtonItem *loadItem = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStylePlain target:self action:@selector(loadItemClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[loadItem];
    
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self loadItemClicked:loadItem];
}

- (void)dealloc {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark - Getter

- (WKWebView *)webView {
    if (!_webView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat marginH = 3;
        CGRect frame = CGRectMake(marginH, 5, screenSize.width - 2 * marginH, WebViewHeight);
                
        WKUserContentController *userContentController = [WKUserContentController new];
        
        NSString *JSCode = @"window.webkit.messageHandlers.loadFinished.postMessage({msg: 'load document finished'});";
        WKUserScript *script = [[WKUserScript alloc] initWithSource:JSCode injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        [userContentController addUserScript:script];
        [userContentController addScriptMessageHandler:self name:@"loadFinished"];
        
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        configuration.userContentController = userContentController;
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        webView.layer.borderColor = [UIColor orangeColor].CGColor;
        webView.layer.borderWidth = 1;
        webView.scrollView.scrollEnabled = NO;
        
        [WCWebViewTool addViewportScriptWithWKWebView:webView];
        
        _webView = webView;
    }
    
    return _webView;
}

#pragma mark - Action

- (void)loadItemClicked:(id)sender {
    if (self.HTMLString.length) {
        [self.webView loadHTMLString:self.HTMLString baseURL:nil];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@", message);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.webView.scrollView && [keyPath isEqualToString:@"contentSize"]) {
        NSValue *new = change[NSKeyValueChangeNewKey];
        NSValue *old = change[NSKeyValueChangeOldKey];
        NSLog(@"_cmd: %@", change);
        
        if (CGSizeEqualToSize([new CGSizeValue], [old CGSizeValue])) {
            [self startNativeRendering];
        }
    }
}

#pragma mark -

- (UIView *)find_native_view {
    __block UIView *viewToFind = nil;
    
    [WCViewTool enumerateSubviewsInView:self.webView enumerateIncludeView:NO usingBlock:^(UIView * _Nonnull subview, BOOL * _Nonnull stop) {
        if ([@"WKCompositingView" isEqualToString:NSStringFromClass([subview class])]) {
            if ([subview.layer.name isEqualToString:@" <div> id='native_view'"]) {
                viewToFind = subview;
                *stop = YES;
            }
        }
    }];
    
    return viewToFind;
}

- (void)startNativeRendering {
    UIView *view = [self find_native_view];
    NSLog(@"%@", view);
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    
    label.text = @"Hello, world";
    label.numberOfLines = 0;
    label.textColor = [UIColor yellowColor];
    label.backgroundColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:17];
    
    [view addSubview:label];
}

@end
