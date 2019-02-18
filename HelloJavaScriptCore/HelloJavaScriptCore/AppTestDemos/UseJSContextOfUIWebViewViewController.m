//
//  UseJSContextOfUIWebViewViewController.m
//  HelloJavaScriptCore
//
//  Created by wesley_chen on 2019/2/18.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseJSContextOfUIWebViewViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <AudioToolbox/AudioToolbox.h>

@interface UseJSContextOfUIWebViewViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation UseJSContextOfUIWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    NSURL *htmlPageURL = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:htmlPageURL];
    [self.webView loadRequest:request];
}

- (UIWebView *)webView {
    if (!_webView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height - startY)];
        webView.delegate = self;
        webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _webView = webView;
    }
    
    return _webView;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [context evaluateScript:@"var arr = [3, 4, 'abc'];"];
    
    [self addScanWithContext:context];
    
    [self addLocationWithContext:context];
    
    [self addSetBGColorWithContext:context];
    
    [self addShareWithContext:context];
    
    [self addPayActionWithContext:context];
    
    [self addShakeActionWithContext:context];
    
    [self addGoBackWithContext:context];
}

#pragma mark - JavaScript Handler Injection

- (void)addScanWithContext:(JSContext *)context {
    context[@"scan"] = ^() {
        NSLog(@"扫一扫啦");
    };
}

- (void)addLocationWithContext:(JSContext *)context {
    context[@"getLocation"] = ^() {
        // 获取位置信息
        
        // 将结果返回给js
        NSString *jsStr = [NSString stringWithFormat:@"setLocation('%@')",@"广东省深圳市南山区学府路XXXX号"];
        [[JSContext currentContext] evaluateScript:jsStr];
    };
}

- (void)addShareWithContext:(JSContext *)context {
    context[@"share"] = ^() {
        NSArray *args = [JSContext currentArguments];
        
        if (args.count < 3) {
            return ;
        }
        
        NSString *title = [args[0] toString];
        NSString *content = [args[1] toString];
        NSString *url = [args[2] toString];
        // 在这里执行分享的操作
        
        // 将分享结果返回给js
        NSString *jsStr = [NSString stringWithFormat:@"shareResult('%@','%@','%@')",title,content,url];
        [[JSContext currentContext] evaluateScript:jsStr];
    };
}

- (void)addSetBGColorWithContext:(JSContext *)context {
    __weak typeof(self) weakSelf = self;
    context[@"setColor"] = ^() {
        NSArray *args = [JSContext currentArguments];
        
        if (args.count < 4) {
            return ;
        }
        
        CGFloat r = [[args[0] toNumber] floatValue];
        CGFloat g = [[args[1] toNumber] floatValue];
        CGFloat b = [[args[2] toNumber] floatValue];
        CGFloat a = [[args[3] toNumber] floatValue];
        
        // 注意 现在执行JS是在WebThread的子线程（以前是在主线程），操作UI需要回到主线程。
        dispatch_async(dispatch_get_main_queue(), ^{
            // 这里是操作UI的操作
            weakSelf.webView.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
        });
    };
}

- (void)addPayActionWithContext:(JSContext *)context {
    context[@"payAction"] = ^() {
        NSArray *args = [JSContext currentArguments];
        
        if (args.count < 4) {
            return ;
        }
        
        NSString *orderNo = [args[0] toString];
        NSString *channel = [args[1] toString];
        long long amount = [[args[2] toNumber] longLongValue];
        NSString *subject = [args[3] toString];
        
        // 支付操作
        NSLog(@"orderNo:%@---channel:%@---amount:%lld---subject:%@",orderNo,channel,amount,subject);
        
        // 将支付结果返回给js
        //        NSString *jsStr = [NSString stringWithFormat:@"payResult('%@')",@"支付成功"];
        //        [[JSContext currentContext] evaluateScript:jsStr];
        [[JSContext currentContext][@"payResult"] callWithArguments:@[@"支付成功"]];
    };
}

- (void)addShakeActionWithContext:(JSContext *)context {
    context[@"shake"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        });
    };
}

- (void)addGoBackWithContext:(JSContext *)context {
    __weak typeof(self) weakSelf = self;
    context[@"goBack"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.webView goBack];
        });
    };
}

@end
