//
//  WCDynamicColor.h
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/15.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^WCColorWillChangeBlockType)(id object, UIColor *newColor);

@protocol WCDynamicColorProvider <NSObject>
@required
- (nullable UIColor *)colorWithProviderName:(NSString *)name forKey:(NSString *)key;
@end

FOUNDATION_EXPORT const NSNotificationName WCDynamicColorDidChangeNotification;
FOUNDATION_EXPORT const NSString *WCDynamicColorChangeNotificationUserInfoProvider;
FOUNDATION_EXPORT const NSString *WCDynamicColorChangeNotificationUserInfoProviderName;

@interface WCDynamicColor : NSObject

+ (BOOL)setDynamicColorWithHost:(id)host defaultColor:(UIColor *)defaultColor forKey:(NSString *)key colorWillChangeBlock:(nullable WCColorWillChangeBlockType)colorDidChangeBlock forceReplace:(BOOL)forceReplace;

@end

NS_ASSUME_NONNULL_END
