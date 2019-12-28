//
//  WCWebViewTool.m
//  HelloWebView
//
//  Created by wesley_chen on 2019/12/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCWebViewTool.h"

@implementation WCWebViewTool

#pragma mark - UIWebView

#pragma mark > Query HTML

+ (nullable NSString *)documentStringWithUIWebView:(UIWebView *)webView {
    return [NSString stringWithFormat:@"%@\n%@", [self doctypeTagStringWithUIWebView:webView], [self HTMLStringWithUIWebView:webView]];
}

+ (nullable NSString *)HTMLStringWithUIWebView:(UIWebView *)webView {
    
    if (![webView isKindOfClass:[UIWebView class]]) {
        return nil;
    }
    
    NSString *HTMLString = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    return HTMLString;
}

+ (nullable NSString *)doctypeTagStringWithUIWebView:(UIWebView *)webView {
    if (![webView isKindOfClass:[UIWebView class]]) {
        return nil;
    }
    
    NSString *name = [webView stringByEvaluatingJavaScriptFromString:@"document.doctype.name"];
    NSString *publicId = [webView stringByEvaluatingJavaScriptFromString:@"document.doctype.publicId"];
    NSString *systemId = [webView stringByEvaluatingJavaScriptFromString:@"document.doctype.systemId"];
    
    NSMutableString *doctypeString = [NSMutableString stringWithString:@"<!DOCTYPE "];
    if (name.length) {
        [doctypeString appendString:name];
    }
    
    if (publicId.length) {
        [doctypeString appendFormat:@" PUBLIC \"%@\"", publicId];
    }
    
    if (!publicId.length && systemId.length) {
        [doctypeString appendString:@" SYSTEM"];
    }
    
    if (systemId.length) {
        [doctypeString appendFormat:@" \"%@\"", systemId];
    }
    
    [doctypeString appendString:@">"];
    
    return doctypeString;
}

@end
