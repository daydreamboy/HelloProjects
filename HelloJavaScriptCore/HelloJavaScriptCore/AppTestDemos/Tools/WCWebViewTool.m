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

+ (nullable WKUserScript *)userScriptWithAppendCSSAtFilePath:(NSString *)CSSFilePath {
    return [self userScriptWithAppendCSSAtFilePath:CSSFilePath injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
}

+ (nullable WKUserScript *)userScriptWithAppendCSSAtFilePath:(NSString *)CSSFilePath injectionTime:(WKUserScriptInjectionTime)injectionTime forMainFrameOnly:(BOOL)forMainFrameOnly {
    if (![CSSFilePath isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSError *error;
    NSString *string = [NSString stringWithContentsOfFile:CSSFilePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        return nil;
    }
    
    // Note: remove \n and \r to avoid executing JS failed
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!string.length) {
        return nil;
    }
    
    NSString *JSCodeString = [NSString stringWithFormat:@"var style = document.createElement('style'); style.innerHTML = '%@'; document.head.appendChild(style);", string];
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:JSCodeString injectionTime:injectionTime forMainFrameOnly:forMainFrameOnly];
    
    return userScript;
}

@end
