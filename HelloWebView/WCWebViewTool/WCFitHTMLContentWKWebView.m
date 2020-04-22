//
//  WCFitHTMLContentWKWebView.m
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/4/21.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCFitHTMLContentWKWebView.h"
#import "WCMacroTool.h"

@interface WCFitHTMLContentWKWebView () <WKNavigationDelegate>
@end

@implementation WCFitHTMLContentWKWebView

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    frame.size.height = 0;
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
        self.scrollView.scrollEnabled = NO;
        [super setNavigationDelegate:self];
    }
    
    return self;
}

#pragma mark -

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // @see https://stackoverflow.com/a/45674575
    [self evaluateJavaScript:@"document.readyState" completionHandler:^(NSString *_Nullable readyState, NSError * _Nullable error) {
        if ([readyState isKindOfClass:[NSString class]] && [readyState isEqualToString:@"complete"]) {
            
            NSString *script = IOS13_OR_LATER ? @"document.documentElement.scrollHeight" : @"document.body.scrollHeight";
            [self evaluateJavaScript:script completionHandler:^(NSNumber *_Nullable scrollHeight, NSError * _Nullable error) {
                if ([scrollHeight isKindOfClass:[NSNumber class]]) {
                    NSLog(@"scrollHeight: %@", scrollHeight);
                    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, [scrollHeight doubleValue]);
                    self.frame = FrameSetSize(self.frame, NAN, [scrollHeight doubleValue]);
                }
            }];
        }
    }];
}

@end
