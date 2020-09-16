//
//  AppFontProvider.h
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/16.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCTheme.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *AppFontKey_label_body;
FOUNDATION_EXPORT NSString *AppFontKey_cell_title;

FOUNDATION_EXPORT NSString *AppValueKey_cell_height;

@interface AppFontProvider : NSObject <WCDynamicFontProvider, WCDynamicValueProvider>

@end

NS_ASSUME_NONNULL_END
