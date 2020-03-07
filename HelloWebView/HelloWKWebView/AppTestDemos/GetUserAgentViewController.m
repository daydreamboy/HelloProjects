//
//  GetUserAgentViewController.m
//  HelloUIWebView
//
//  Created by wesley_chen on 2020/3/5.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "GetUserAgentViewController.h"
#import "WCWebViewTool.h"
#import <WebKit/WebKit.h>

@interface GetUserAgentViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation GetUserAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
}

#pragma mark - Getter

- (UILabel *)label {
    if (!_label) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) configuration:configuration];
        
        [WCWebViewTool userAgentWithWKWebView:webView completion:^(NSString * _Nonnull userAgent) {
            label.text = userAgent;
        }];
        
        _label = label;
    }
    
    return _label;
}

@end
