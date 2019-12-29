//
//  WCWebViewTool.m
//  HelloWebView
//
//  Created by wesley_chen on 2019/12/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCWebViewTool.h"

@implementation WCWebViewTool

#pragma mark - WKWebView

#pragma mark > Query HTML

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

#pragma mark > Insert HTML

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

#pragma mark > Create User Script

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
