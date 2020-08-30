//
//  WCViewTool.h
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/8/30.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCViewTool : NSObject

@end

@interface WCViewTool ()
+ (BOOL)enumerateSubviewsInView:(UIView *)view enumerateIncludeView:(BOOL)enumerateIncludeView usingBlock:(void (^)(UIView *subview, BOOL *stop))block;
@end

NS_ASSUME_NONNULL_END
