//
//  TestViewController.m
//  HelloUIWebView
//
//  Created by wesley_chen on 2018/10/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *htmlString;
@end

@implementation TestViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _htmlString = sHtmlCode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.webView loadHTMLString:self.htmlString baseURL:nil];
    [self.view addSubview:self.webView];
}

#pragma mark - Getters

- (UIWebView *)webView {
    if (!_webView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGRect frame = CGRectMake(0, 80, 310, 96);
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
//        webView.backgroundColor = [UIColor whiteColor];
        webView.delegate = self;
        
        _webView = webView;
    }
    
    return _webView;
}

#define STR_OF_HTML(...) @#__VA_ARGS__
static NSString *sHtmlCode = STR_OF_HTML(
<div style="max-width:300px;min-width:180px;background:#fff;margin:0;font-size:14px;line-height:16px;font-family:arial;">
    <a href="http://item.taobao.com/item.htm?id=567639595256&scm=20140619.rec.2256639331.567639595256" target="_blank" style="text-decoration:none;display:-webkit-box;">
        <img src="https://img.alicdn.com/bao/uploaded/i2/2256639331/TB16eIGk21TBuNjy0FjXXajyXXa_!!0-item_pic.jpg" style="width:60px;margin-right:10px;max-height:80px;" />
        <div style="-webkit-box-flex:1;color:#333;padding:0;margin:0;">
            <div style="overflow:hidden;word-wrap: break-word;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;text-overflow:ellipsis;">测试宝贝请不要拍</div>
            <div style="padding:5px 0;color:#f60;font-size:16px;">&#165;0.12</div>
        </div>
    </a>
</div>
);

@end
