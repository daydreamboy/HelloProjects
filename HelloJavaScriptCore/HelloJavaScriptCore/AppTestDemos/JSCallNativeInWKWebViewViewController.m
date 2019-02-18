//
//  JSCallNativeInWKWebViewViewController.m
//  HelloJavaScriptCore
//
//  Created by wesley_chen on 2019/2/18.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "JSCallNativeInWKWebViewViewController.h"
#import <WebKit/WebKit.h>

#define ALERT_TIP(title, msg, cancel, dismissCompletion) \
\
do { \
    if ([UIAlertController class]) { \
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:(title) message:(msg) preferredStyle:UIAlertControllerStyleAlert]; \
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:(cancel) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { \
            dismissCompletion; \
        }]; \
        [alert addAction:cancelAction]; \
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil]; \
    } \
} while (0)

@interface JSCallNativeInWKWebViewViewController () <WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation JSCallNativeInWKWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    NSURL *htmlPageURL = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:htmlPageURL];
    [self.webView loadRequest:request];
}

#pragma mark - Getters

- (WKWebView *)webView {
    if (!_webView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        CGRect frame = CGRectMake(0, 0, screenSize.width, screenSize.height - startY);
        
        WKUserContentController *userContentController = [WKUserContentController new];
        
        // https://stackoverflow.com/a/26583062
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [userContentController addUserScript:wkUScript];
        
        NSString *JSSourceCode = @"window.webkit.messageHandlers.welcome.postMessage({msg: 'Welcome to use WKWebView'});";
        WKUserScript *JSCode = [[WKUserScript alloc] initWithSource:JSSourceCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        
        [userContentController addUserScript:JSCode];
        [userContentController addScriptMessageHandler:self name:@"buttonClicked"];
        [userContentController addScriptMessageHandler:self name:@"welcome"];
        
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        configuration.userContentController = userContentController;
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        _webView = webView;
    }
    
    return _webView;
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message          {
    if ([message.name isEqualToString:@"buttonClicked"]) {
        // JS objects are automatically mapped to ObjC objects
        id messageBody = message.body;
        if ([messageBody isKindOfClass:[NSDictionary class]]) {
            NSLog(@"messageBody: %@", messageBody);
            NSString *msg = [NSString stringWithFormat:@"messageBody: %@", messageBody];
            ALERT_TIP(@"JavaScript触发`buttonClicked`消息", msg, @"Ok", nil);
        }
    }
    else if ([message.name isEqualToString:@"welcome"]) {
        id messageBody = message.body;
        if ([messageBody isKindOfClass:[NSDictionary class]]) {
            NSLog(@"messageBody: %@", messageBody);
            NSString *msg = ((NSDictionary *)messageBody)[@"msg"];
            ALERT_TIP(@"JavaScript触发`welcome`消息", msg, @"Ok", nil);
        }
    }
}

@end
