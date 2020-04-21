//
//  WCWebViewTool.h
//  HelloWebView
//
//  Created by wesley_chen on 2019/12/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#define WCUserScriptAtStart(JSCode) WCUserScript3(JSCode, WKUserScriptInjectionTimeAtDocumentStart, YES)
#define WCUserScriptAtEnd(JSCode)   WCUserScript3(JSCode, WKUserScriptInjectionTimeAtDocumentEnd, YES)

#define WCUserScript3(JSCode, injectionTime__, forMainFrameOnly__)   ([[WKUserScript alloc] initWithSource:JSCode injectionTime:injectionTime__ forMainFrameOnly:forMainFrameOnly__])

NS_ASSUME_NONNULL_BEGIN

@interface WCWebViewTool : NSObject

#pragma mark - WKWebView

#pragma mark > Query HTML

/**
 Get the whole html sorce code from webView

 @param webView the WKWebView
 @param completion the callback
 - documentString, whole html sorce code
 - error, error info
 @return YES if operate successfully, NO if parameters are not correct.
 @see https://stackoverflow.com/a/34759075
 */
+ (BOOL)documentStringWithWKWebView:(WKWebView *)webView completion:(void (^)(NSString * _Nullable documentString, NSError * _Nullable error))completion;


#pragma mark > Insert HTML

#pragma mark > Insert CSS after WebView load finished

// @see https://stackoverflow.com/a/33126467
+ (BOOL)insertCSSWithWKWebView:(WKWebView *)webView CSSFilePath:(NSString *)CSSFilePath;

#pragma mark > Create User Script

+ (nullable WKUserScript *)userScriptWithAppendCSSAtFilePath:(NSString *)CSSFilePath;
+ (nullable WKUserScript *)userScriptWithAppendCSSAtFilePath:(NSString *)CSSFilePath injectionTime:(WKUserScriptInjectionTime)injectionTime forMainFrameOnly:(BOOL)forMainFrameOnly;

#pragma mark > Add User Script

/**
 Add viewport script
 
 @param webView the WKWebView
 @return YES if add script successfully, or NO if failed.
 */
+ (BOOL)addViewportScriptWithWKWebView:(WKWebView *)webView;

#pragma mark > Preset User Script

+ (WKUserScript *)viewportUserScript;

#pragma mark > Execute User Script

/**
 viewport script to fit screen width and disable zooming out
 
 @code
 <head>
 <meta name="viewport" content="width=device-width; minimum-scale=1.0; maximum-scale=1.0; user-scalable=no">
 </head>
 
 @return the script
 @see https://stackoverflow.com/questions/10666484/html-content-fit-in-uiwebview-without-zooming-out
 */
+ (WKUserScript *)viewportUserScript;

#pragma mark > Observing

#pragma mark > Query Browser

/**
 Get user agent string, e.g. Mozilla/5.0 (iPhone; CPU iPhone OS 13_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148
 
 @param webView the WKWebView
 @param completion the block to get user agent, which is asynchronous
 */
+ (void)userAgentWithWKWebView:(WKWebView *)webView completion:(void (^)(NSString *userAgent))completion;

#pragma mark - UIWebView

#pragma mark > Query HTML

/**
 Get the whole html sorce code from webView

 @param webView the UIWebView
 @return the whole html sorce code
 */
+ (nullable NSString *)documentStringWithUIWebView:(UIWebView *)webView;

/**
 Get the <html>...</html> part

 @param webView the UIWebView
 @return the <html>...</html> part
 @see http://stackoverflow.com/questions/992348/reading-html-content-from-a-uiwebview
 */
+ (nullable NSString *)HTMLStringWithUIWebView:(UIWebView *)webView;

/**
 Get the <!doctype ...> part
 
 *  <!DOCTYPE html>
 *  <!DOCTYPE html SYSTEM "about:legacy-compat">
 *  <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">

 @param webView the UIWebView
 @return the <!doctype ...> part
 @see http://stackoverflow.com/questions/6088972/get-doctype-of-an-html-as-string-with-javascript
 @see https://developer.mozilla.org/en-US/docs/Web/API/Document/doctype
 */
+ (nullable NSString *)doctypeTagStringWithUIWebView:(UIWebView *)webView;

#pragma mark > Query Browser

/**
 Get user agent string, e.g. Mozilla/5.0 (iPhone; CPU iPhone OS 13_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148
 
 @param webView the UIWebView
 @see https://stackoverflow.com/a/19184414
 */
+ (nullable NSString *)userAgentWithUIWebView:(UIWebView *)webView;

@end

NS_ASSUME_NONNULL_END
