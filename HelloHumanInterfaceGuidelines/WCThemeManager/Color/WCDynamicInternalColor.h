//
//  WCDynamicInternalColor.h
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/15.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCDynamicInternalColor : UIColor

@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, strong, readonly) UIColor *defaultColor;
@property (nonatomic, assign, readonly, getter=isDynamicColor) BOOL dynamicColor;

@end

NS_ASSUME_NONNULL_END
