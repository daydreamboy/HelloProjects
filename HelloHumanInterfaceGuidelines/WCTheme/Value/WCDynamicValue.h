//
//  WCDynamicValue.h
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/16.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@class WCDynamicValue;

typedef void(^WCValueDidChangeBlockType)(id object, WCDynamicValue *newValue);

@protocol WCDynamicValueProvider <NSObject>
@required
- (nullable WCDynamicValue *)valueWithProviderName:(NSString *)name forKey:(NSString *)key;
@end

FOUNDATION_EXPORT const NSNotificationName WCDynamicValueDidChangeNotification;
FOUNDATION_EXPORT const NSString *WCDynamicValueChangeNotificationUserInfoProvider;
FOUNDATION_EXPORT const NSString *WCDynamicValueChangeNotificationUserInfoProviderName;

@interface WCDynamicValue : NSObject

@property (nonatomic, assign, readonly) BOOL boolValue;
@property (nonatomic, assign, readonly) char charValue;
@property (nonatomic, assign, readonly) double doubleValue;
@property (nonatomic, assign, readonly) float floatValue;
@property (nonatomic, assign, readonly) int intValue;
@property (nonatomic, assign, readonly) NSInteger integerValue;
@property (nonatomic, assign, readonly) long long longLongValue;
@property (nonatomic, assign, readonly) long longValue;
@property (nonatomic, assign, readonly) short shortValue;
@property (nonatomic, assign, readonly) unsigned char unsignedCharValue;
@property (nonatomic, assign, readonly) NSUInteger unsignedIntegerValue;
@property (nonatomic, assign, readonly) unsigned int unsignedIntValue;
@property (nonatomic, assign, readonly) unsigned long long unsignedLongLongValue;
@property (nonatomic, assign, readonly) unsigned long unsignedLongValue;
@property (nonatomic, assign, readonly) unsigned short unsignedShortValue;

@property (nonatomic, copy, readonly) NSString *stringValue;

@property (nonatomic, assign, readonly) CGPoint pointValue;
@property (nonatomic, assign, readonly) CGSize sizeValue;
@property (nonatomic, assign, readonly) CGRect rectValue;
@property (nonatomic, assign, readonly) UIEdgeInsets insetValue;

+ (instancetype)valueWithBool:(BOOL)value;
+ (instancetype)valueWithChar:(char)value;
+ (instancetype)valueWithDouble:(double)value;
+ (instancetype)valueWithFloat:(float)value;
+ (instancetype)valueWithInt:(int)value;
+ (instancetype)valueWithInteger:(NSInteger)value;
+ (instancetype)valueWithLongLong:(long long)value;
+ (instancetype)valueWithLong:(long)value;
+ (instancetype)valueWithShort:(short)value;
+ (instancetype)valueWithUnsignedChar:(unsigned char)value;
+ (instancetype)valueWithUnsignedInteger:(NSUInteger)value;
+ (instancetype)valueWithUnsignedInt:(unsigned int)value;
+ (instancetype)valueWithUnsignedLongLong:(unsigned long long)value;

// TODO
//...

+ (BOOL)setDynamicValueWithHost:(id)host defaultValue:(WCDynamicValue *)defaultValue forKey:(NSString *)key valueDidChangeBlock:(nullable WCValueDidChangeBlockType)valueDidChangeBlock forceReplace:(BOOL)forceReplace;

@end

#define WCDynamicValueDouble(doubleValue) ([WCDynamicValue valueWithDouble:(doubleValue)])

NS_ASSUME_NONNULL_END
