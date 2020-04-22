//
//  WCWebViewTool.m
//  HelloWebView
//
//  Created by wesley_chen on 2019/12/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCWebViewTool.h"

// >= `13.0`
#ifndef IOS13_OR_LATER
#define IOS13_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"13.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@implementation WCWebViewTool

#pragma mark - WKWebView

#pragma mark > Query HTML

+ (BOOL)documentStringWithWKWebView:(WKWebView *)webView completion:(void (^)(NSString * _Nullable documentString, NSError * _Nullable error))completion {
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

#pragma mark > Preset User Script

+ (WKUserScript *)viewportUserScript {
    NSString *script = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width; initial-scale=1.0; minimum-scale=1.0; maximum-scale=1.0; user-scalable=no;'); document.getElementsByTagName('head')[0].appendChild(meta);";
    // Note: use WCUserScriptAtEnd for after all DOM loaded to insert viewport
    return WCUserScriptAtEnd(script);
}

+ (WKUserScript *)disableTouchCalloutUserScript {
    NSString *script = IOS13_OR_LATER ? @"document.documentElement.style.webkitTouchCallout='none';" : @"document.body.style.webkitTouchCallout='none';";
    return WCUserScriptAtEnd(script);
}

+ (WKUserScript *)disableUserSelectUserScript {
    NSString *script = IOS13_OR_LATER ? @"document.documentElement.style.webkitUserSelect='none';" : @"document.body.style.webkitUserSelect='none';";
    return WCUserScriptAtEnd(script);
}

#pragma mark > Add User Script

+ (BOOL)addViewportScriptWithWKWebView:(WKWebView *)webView {
    return [self addUserScriptWithWKWebView:webView userScript:[self viewportUserScript]];
}

+ (BOOL)addDisableTouchCalloutUserScriptWithWKWebView:(WKWebView *)webView {
    return [self addUserScriptWithWKWebView:webView userScript:[self disableTouchCalloutUserScript]];
}

+ (BOOL)addDisableUserSelectUserScriptWithWKWebView:(WKWebView *)webView {
    return [self addUserScriptWithWKWebView:webView userScript:[self disableUserSelectUserScript]];
}

#pragma mark ::

+ (BOOL)addUserScriptWithWKWebView:(WKWebView *)webView userScript:(WKUserScript *)userScript {
    if (![webView isKindOfClass:[WKWebView class]]) {
        return NO;
    }
    
    if (!webView.configuration.userContentController) {
        webView.configuration.userContentController = [WKUserContentController new];
    }
    
    WKUserContentController *contentController = webView.configuration.userContentController;
    [contentController addUserScript:userScript];
    
    return YES;
}

#pragma mark ::

#pragma mark > Query Browser

+ (void)userAgentWithWKWebView:(WKWebView *)webView completion:(void (^)(NSString *userAgent))completion {
    if (![webView isKindOfClass:[WKWebView class]]) {
        !completion ?: completion(@"Unknown");
    }
    
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if ([result isKindOfClass:[NSString class]] && ((NSString *)result).length > 0) {
            // Note: create a variable to hold `webView` strongly if `webView` is
            // a local object release after call this method
            // @see https://forums.developer.apple.com/thread/123128
            __unused WKWebView *webViewL = webView;
            !completion ?: completion(result);
        }
        else {
            !completion ?: completion(@"Unknown");
        }
    }];
}

#pragma mark > Configure WebView

+ (BOOL)toggleLinkPreviewWithWKWebView:(WKWebView *)webView enabled:(BOOL)enabled {
    if (![webView isKindOfClass:[WKWebView class]]) {
        return NO;
    }
    
    if ([webView respondsToSelector:@selector(setAllowsLinkPreview:)]) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability"
        webView.allowsLinkPreview = enabled;
#pragma GCC diagnostic pop
        
        return YES;
    }
    
    return NO;
}

#pragma mark > Hook WebView

+ (BOOL)disableLongPressWithWKWebView:(WKWebView *)webView {
    if (![webView isKindOfClass:[WKWebView class]]) {
        return NO;
    }
    
    // Note: 禁用WKWebView的长按手势，避免导致长按变成单击跳转
    NSArray *subviews = [webView subviews];
    NSString *classNameToCheck = [@[ @"W", @"K", @"C", @"o", @"n", @"t", @"e", @"n", @"t", @"V", @"i", @"e", @"w" ] componentsJoinedByString:@""];

    BOOL hooked = NO;
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[UIView class]]) {
            for (UIView *subview2 in [subview subviews]) {
                if ([subview2 isKindOfClass:[UIView class]] && [NSStringFromClass([subview2 class]) isEqualToString:classNameToCheck]) {
                    for (UIGestureRecognizer *recognizer in subview2.gestureRecognizers) {
                        if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                            recognizer.enabled = NO;
                            hooked = YES;
                        }
                    }
                    break;
                }
            }
        }
    }
    
    return hooked;
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

#pragma mark > Query Browser

+ (nullable NSString *)userAgentWithUIWebView:(UIWebView *)webView {
    if (![webView isKindOfClass:[UIWebView class]]) {
        return nil;
    }
    
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    return userAgent;
}

#pragma mark > Hook WebView

+ (BOOL)disableLongPressWithUIWebView:(UIWebView *)webView {
    if (![webView isKindOfClass:[UIWebView class]]) {
        return NO;
    }
    
    // Note: 禁用UIWebView的长按手势，避免导致长按变成单击跳转
    NSArray *subviews = [webView subviews];
    NSString *classNameToCheck = [@[ @"U", @"I", @"W", @"e", @"b", @"B", @"r", @"o", @"w", @"s", @"e", @"r", @"V", @"i", @"e", @"w" ] componentsJoinedByString:@""];
    
    BOOL hooked = NO;
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[UIView class]]) {
            for (UIView *subview2 in [subview subviews]) {
                if ([subview2 isKindOfClass:[UIView class]] && [NSStringFromClass([subview2 class]) isEqualToString:classNameToCheck]) {
                    for (UIGestureRecognizer *recognizer in subview2.gestureRecognizers) {
                        if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                            recognizer.enabled = NO;
                            hooked = YES;
                        }
                    }
                    break;
                }
            }
        }
    }
    
    return hooked;
}

@end
