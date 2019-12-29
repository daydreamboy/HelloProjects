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
+ (BOOL)getDocumentStringWithWKWebView:(WKWebView *)webView completion:(void (^)(NSString * _Nullable documentString, NSError * _Nullable error))completion;


#pragma mark > Insert HTML

#pragma mark > Insert CSS after WebView load finished

// @see https://stackoverflow.com/a/33126467
+ (BOOL)insertCSSWithWKWebView:(WKWebView *)webView CSSFilePath:(NSString *)CSSFilePath;

#pragma mark > Create User Script

+ (nullable WKUserScript *)userScriptWithAppendCSSAtFilePath:(NSString *)CSSFilePath;
+ (nullable WKUserScript *)userScriptWithAppendCSSAtFilePath:(NSString *)CSSFilePath injectionTime:(WKUserScriptInjectionTime)injectionTime forMainFrameOnly:(BOOL)forMainFrameOnly;

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

@end

NS_ASSUME_NONNULL_END
