//
//  WCDynamicFont.h
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WCFontDidChangeBlockType)(id object, UIFont *newFont);

@protocol WCDynamicFontProvider <NSObject>
@required
- (nullable UIFont *)fontWithProviderName:(NSString *)name forKey:(NSString *)key;
@end

FOUNDATION_EXPORT const NSNotificationName WCDynamicFontDidChangeNotification;
FOUNDATION_EXPORT const NSNotificationName WCDynamicFontWillChangeNotification;

FOUNDATION_EXPORT const NSString *WCDynamicFontChangeNotificationUserInfoProvider;
FOUNDATION_EXPORT const NSString *WCDynamicFontChangeNotificationUserInfoProviderName;

@interface WCDynamicFont : NSObject

+ (BOOL)setDynamicFontWithHost:(id)host defaultFont:(UIFont *)defaultFont forKey:(NSString *)key fontDidChangeBlock:(nullable WCFontDidChangeBlockType)fontDidChangeBlock forceReplace:(BOOL)forceReplace;

@end

NS_ASSUME_NONNULL_END
