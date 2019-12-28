//
//  WCWebViewTool.m
//  HelloJavaScriptCore
//
//  Created by wesley_chen on 2019/12/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCWebViewTool.h"

@implementation WCWebViewTool

+ (BOOL)getDocumentStringWithWKWebView:(WKWebView *)webView completion:(void (^)(NSString * _Nullable documentString, NSError * _Nullable error))completion {
    if (![webView isKindOfClass:[WKWebView class]]) {
        return NO;
    }
    
    [webView evaluateJavaScript:@"document.documentElement.outerHTML.toString()" completionHandler:^(id _Nullable html, NSError * _Nullable error) {
        if ([html isKindOfClass:[NSString class]]) {
            !completion ?: completion(html, error);
        }
        else {
            !completion ?: completion(nil, error);
        }
    }];
    
    return YES;
}

#pragma mark > Insert CSS

+ (BOOL)insertCSSWithWKWebView:(WKWebView *)webView CSSFilePath:(NSString *)CSSFilePath {
    if (![webView isKindOfClass:[WKWebView class]] || ![CSSFilePath isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:CSSFilePath]) {
        return NO;
    }
    
    NSError *error;
    NSString *string = [NSString stringWithContentsOfFile:CSSFilePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        return NO;
    }
    
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!string.length) {
        return NO;
    }
    
    NSString *JSCodeString = [NSString stringWithFormat:@"var style = document.createElement('style'); style.innerHTML = '%@'; document.head.appendChild(style);", string];
    [webView evaluateJavaScript:JSCodeString completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        }
    }];
    
    return YES;
}

@end
