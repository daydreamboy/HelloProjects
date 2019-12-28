//
//  WCWebViewTool.h
//  HelloJavaScriptCore
//
//  Created by wesley_chen on 2019/12/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCWebViewTool : NSObject

@end

@interface WCWebViewTool ()

#pragma mark > Query HTML

/**
 Get the whole html sorce code from webView

 @param webView the UIWebView
 @return the whole html sorce code
 */
+ (BOOL)getDocumentStringWithWKWebView:(WKWebView *)webView completion:(void (^)(NSString * _Nullable documentString, NSError * _Nullable error))completion;

#pragma mark > Insert CSS

+ (BOOL)insertCSSWithWKWebView:(WKWebView *)webView CSSFilePath:(NSString *)CSSFilePath;

@end

NS_ASSUME_NONNULL_END
