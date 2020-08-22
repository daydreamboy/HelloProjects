//
//  UIFont+WCFont.h
//  HelloUIFont
//
//  Created by wesley_chen on 2020/4/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (WCFont)

+ (void)tbfont_registerFontWithData:(NSData *)data completionHandler:(void (^ NS_NOESCAPE)(NSString *fontName, NSError *error))completionHandler;

+ (void)tbfont_registerFontWithFilePath:(NSString *)fontFilePath completionHandler:(nullable void (^ NS_NOESCAPE)(NSString *fontName, NSError *error))completionHandler;

/**
 @param name, 字体的PostScript名称 或者 字体全称
 */
+ (void)tbfont_unregisterFontWithName:(NSString *)name completionHandler:(nullable void (^)(NSError *error))completionHandler;

@end

NS_ASSUME_NONNULL_END
