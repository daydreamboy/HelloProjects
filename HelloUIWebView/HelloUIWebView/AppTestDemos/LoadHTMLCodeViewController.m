//
//  LoadHTMLCodeViewController.m
//  HelloUIWebView
//
//  Created by wesley_chen on 2018/9/2.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "LoadHTMLCodeViewController.h"

@interface LoadHTMLCodeViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *htmlString;
@end

@implementation LoadHTMLCodeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _htmlString = sHtmlCode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightTopItem = [[UIBarButtonItem alloc] initWithTitle:@"Show/Hide" style:UIBarButtonItemStyleDone target:self action:@selector(captureItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightTopItem;
    
    [self.webView loadHTMLString:self.htmlString baseURL:nil];
    [self.view addSubview:self.webView];
}

#pragma mark - Actions

- (void)captureItemClicked:(id)sender {
    self.webView.hidden = !self.webView.hidden;
}

#pragma mark - Getters

- (UIWebView *)webView {
    if (!_webView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGRect frame = CGRectMake(0, 0, screenSize.width, 300);
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
        webView.backgroundColor = [UIColor whiteColor];
        webView.hidden = YES;
        webView.delegate = self;
        
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
    NSLog(@"start: %f", sEnd);
    NSLog(@"duration: %f", sEnd - sStart);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

#pragma mark -

static float sStart;
static float sEnd;

static NSString *sHtmlCode = @"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, user-scalable=no\"/>\r\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, user-scalable=no\"/>\r\n<meta name=\"format-detection\" content=\"telephone=no\" />\r\n                     <div class=\"_adr_item\">\r\n            <div class=\"_adr_in_item\">\r\n                <input class=\"_adr_input\" type=\"radio\" name=\"addr\"  value=\"wangxs://multiaction/and?multi=%5B%22wangx%3A%2F%2Fp2sconversation%2Fpackage%3FserviceType%3Dcloud_auto_reply%26bizType%3D3%26bot_action%3DAddressSelectorAction%26fromId%3Dcntaobao小小吉%26toId%3Dcntaobao良品铺子旗舰店:服务助手%26bizOrderId%3D210583658830214925%26uuid%3D210583658830214925%26mainAccountId%3D619123122%26deliverAddressId%3D1858204878%26originalAddressId%3D7313517579%26triggerType%3Dautomatic%22%2C%22wangx%3A%2F%2Fmenu%2Fdismiss%3Fmenuname%3DMenuNameForShowType%26container%3Ddialog%26conversationId%3Dcntaobao良品铺子旗舰店:服务助手%26strategy%3Dtransient%22%5D\" id=\"addr1\">\r\n                <label class=\"_adr_label\" for=\"addr1\">\r\n                    <div class=\"_adr_t\">\r\n                            <span>柯南</span>\r\n                            <span class=\"_adr_fr\">15688888888 </span>\r\n                    </div>\r\n                    <div class=\"_adr_b\">\r\n                             北京北京市北京市朝阳区 清水街街道 清水街6号院（科技城 宇宙中心）2号楼 100000\r\n                    </div>\r\n                </label>\r\n            </div>\r\n            <div class=\"_adr_line\"></div>\r\n        </div>\r\n                                 <div class=\"_adr_item\">\r\n            <div class=\"_adr_in_item\">\r\n                <input class=\"_adr_input\" type=\"radio\" name=\"addr\"  value=\"wangxs://multiaction/and?multi=%5B%22wangx%3A%2F%2Fp2sconversation%2Fpackage%3FserviceType%3Dcloud_auto_reply%26bizType%3D3%26bot_action%3DAddressSelectorAction%26fromId%3Dcntaobao小小吉%26toId%3Dcntaobao良品铺子旗舰店:服务助手%26bizOrderId%3D210583658830214925%26uuid%3D210583658830214925%26mainAccountId%3D619123122%26deliverAddressId%3D6001464528%26originalAddressId%3D7313517579%26triggerType%3Dautomatic%22%2C%22wangx%3A%2F%2Fmenu%2Fdismiss%3Fmenuname%3DMenuNameForShowType%26container%3Ddialog%26conversationId%3Dcntaobao良品铺子旗舰店:服务助手%26strategy%3Dtransient%22%5D\" id=\"addr2\">\r\n                <label class=\"_adr_label\" for=\"addr2\">\r\n                    <div class=\"_adr_t\">\r\n                            <span>柯南</span>\r\n                            <span class=\"_adr_fr\">15688888888 </span>\r\n                    </div>\r\n                    <div class=\"_adr_b\">\r\n                             北京北京市北京市云谷区 清河路 云谷区南方路白云谷B区1号楼 000000\r\n                    </div>\r\n                </label>\r\n            </div>\r\n            <div class=\"_adr_line\"></div>\r\n        </div>\r\n                                 <div class=\"_adr_item\">\r\n            <div class=\"_adr_in_item\">\r\n                <input class=\"_adr_input\" type=\"radio\" name=\"addr\"  value=\"wangxs://multiaction/and?multi=%5B%22wangx%3A%2F%2Fp2sconversation%2Fpackage%3FserviceType%3Dcloud_auto_reply%26bizType%3D3%26bot_action%3DAddressSelectorAction%26fromId%3Dcntaobao小小吉%26toId%3Dcntaobao良品铺子旗舰店:服务助手%26bizOrderId%3D210583658830214925%26uuid%3D210583658830214925%26mainAccountId%3D619123122%26deliverAddressId%3D7034689232%26originalAddressId%3D7313517579%26triggerType%3Dautomatic%22%2C%22wangx%3A%2F%2Fmenu%2Fdismiss%3Fmenuname%3DMenuNameForShowType%26container%3Ddialog%26conversationId%3Dcntaobao良品铺子旗舰店:服务助手%26strategy%3Dtransient%22%5D\" id=\"addr3\">\r\n                <label class=\"_adr_label\" for=\"addr3\">\r\n                    <div class=\"_adr_t\">\r\n                            <span>柯南</span>\r\n                            <span class=\"_adr_fr\">15688888888 </span>\r\n                    </div>\r\n                    <div class=\"_adr_b\">\r\n                             北京北京市北京市云谷区 西南径 云谷区流星东路10号院东区2号楼心心小区 000000\r\n                    </div>\r\n                </label>\r\n            </div>\r\n            <div class=\"_adr_line\"></div>\r\n        </div>\r\n                                     <div class=\"_adr_item\">\r\n            <div class=\"_adr_in_item\">\r\n                <input class=\"_adr_input\" type=\"radio\" name=\"addr\"  checked  value=\"wangxs://multiaction/and?multi=%5B%22wangx%3A%2F%2Fp2sconversation%2Fpackage%3FserviceType%3Dcloud_auto_reply%26bizType%3D3%26bot_action%3DAddressSelectorAction%26fromId%3Dcntaobao小小吉%26toId%3Dcntaobao良品铺子旗舰店:服务助手%26bizOrderId%3D210583658830214925%26uuid%3D210583658830214925%26mainAccountId%3D619123122%26deliverAddressId%3D7313517579%26originalAddressId%3D7313517579%26triggerType%3Dautomatic%22%2C%22wangx%3A%2F%2Fmenu%2Fdismiss%3Fmenuname%3DMenuNameForShowType%26container%3Ddialog%26conversationId%3Dcntaobao良品铺子旗舰店:服务助手%26strategy%3Dtransient%22%5D\" id=\"addr4\">\r\n                <label class=\"_adr_label\" for=\"addr4\">\r\n                    <div class=\"_adr_t\">\r\n                            <span>哆啦A梦</span>\r\n                            <span class=\"_adr_fr\">15688888888 </span>\r\n                    </div>\r\n                    <div class=\"_adr_b\">\r\n                            <span>[默认地址]</span> 浙江省杭州市杭州市蓝水区 行人街道 文化山路818号1号楼 小邮局 000000\r\n                    </div>\r\n                </label>\r\n            </div>\r\n            <div class=\"_adr_line\"></div>\r\n        </div>\r\n                            <div class=\"_adr_item _adr_item_lst\" style=\"margin-bottom:90px;\">\r\n            <div class=\"_adr_in_item\">\r\n                <input class=\"_adr_input\" type=\"radio\" name=\"addr\"  value=\"wangxs://multiaction/and?multi=%5B%22wangx%3A%2F%2Fp2sconversation%2Fpackage%3FserviceType%3Dcloud_auto_reply%26bizType%3D3%26bot_action%3DAddressSelectorAction%26fromId%3Dcntaobao小小吉%26toId%3Dcntaobao良品铺子旗舰店:服务助手%26bizOrderId%3D210583658830214925%26uuid%3D210583658830214925%26mainAccountId%3D619123122%26deliverAddressId%3D6993002005%26originalAddressId%3D7313517579%26triggerType%3Dautomatic%22%2C%22wangx%3A%2F%2Fmenu%2Fdismiss%3Fmenuname%3DMenuNameForShowType%26container%3Ddialog%26conversationId%3Dcntaobao良品铺子旗舰店:服务助手%26strategy%3Dtransient%22%5D\" id=\"addr5\">\r\n                <label class=\"_adr_label\" for=\"addr5\">\r\n                    <div class=\"_adr_t\">\r\n                            <span>柯南</span>\r\n                            <span class=\"_adr_fr\">15688888888 </span>\r\n                    </div>\r\n                    <div class=\"_adr_b\">\r\n                             北京北京市北京市云谷区 清河路 云谷区南方路白云谷B区1号楼 000000\r\n                    </div>\r\n                </label>\r\n            </div>\r\n            <div class=\"_adr_line _adr_line_lst\"></div>\r\n        </div>\r\n    <div style=\"width:100%;margin:0;padding:0;position:fixed;bottom:0;left:0;\">\r\n    <a href=\"wangxs://multiaction/and?multi=%5B%22wangx%3A%2F%2Fp2sconversation%2Fpackage%3FserviceType%3Dcloud_auto_reply%26bizType%3D3%26bot_action%3DAddressSelectorAction%26fromId%3Dcntaobao小小吉%26toId%3Dcntaobao良品铺子旗舰店:服务助手%26bizOrderId%3D210583658830214925%26uuid%3D210583658830214925%26mainAccountId%3D619123122%26deliverAddressId%3D7313517579%26originalAddressId%3D7313517579%26triggerType%3Dautomatic%22%2C%22wangx%3A%2F%2Fmenu%2Fdismiss%3Fmenuname%3DMenuNameForShowType%26container%3Ddialog%26conversationId%3Dcntaobao良品铺子旗舰店:服务助手%26strategy%3Dtransient%22%5D\" id=\"J_button\" style=\"display:block;width:100%;height:48px;background:#3089DC;color:#fff;text-align:center;line-height:48px;text-decoration:none;font-size:12px;\">确定</a>\r\n</div>\r\n<style>html,body{margin:0;padding:0;width:100%;}input[type=\"radio\"]{-webkit-appearance:none;outline:none;content:\"\";display:inline-block;width:16px;height:16px;border-radius:100%;background:#fff;border:1px solid #999;}input[type=\"radio\"]:checked{position:relative;content:\"\";display:inline-block;width:16px;height:16px;border-radius:100%;background:#3089DC;border:1px solid #3089DC;}input[type=\"radio\"]:checked:after{position:absolute;content:\"\";width:8px;height:8px;left:3px;top:5px;background:url(https://gw.alicdn.com/tfs/TB10efjSFXXXXXDXVXXXXXXXXXX-9-6.png) no-repeat;}._adr_item{color:#3d4145;position:relative;overflow:hidden;}._adr_item_lst{margin-bottom:60px;}._adr_in_item{padding:8px 20px;display:-webkit-flex;}._adr_item_lst ._adr_in_item{color:#5f646e;margin-bottom:8px;}._adr_input{-webkit-align-self:center;margin-right:10px;}._adr_label{-webkit-flex:1;}._adr_t{font-size:14px;color:#5f646e;margin-bottom:8px;}._adr_b{font-size:12px;line-height:16px;}._adr_b span{color:#FFA033;}._adr_fr{float:right;}._adr_line{width:100%;height:1px;background:#DCDEE3;-webkit-transform:scale(1, 0.5);transform:scale(1, 0.5);margin-left:45px;}._adr_line_lst{margin-left:0;background:#C4C6CF;}</style>\r\n<script>\r\n    var radios = document.querySelectorAll('input[type=\"radio\"]');\r\n    var btn = document.getElementById('J_button');\r\n    var len = radios.length;\r\n    for(var i = 0; i < len; i++) {\r\n        radios[i].addEventListener('change', function(ev) {\r\n            btn.href = ev.target.value;\r\n        });\r\n    }\r\n</script>";

@end
