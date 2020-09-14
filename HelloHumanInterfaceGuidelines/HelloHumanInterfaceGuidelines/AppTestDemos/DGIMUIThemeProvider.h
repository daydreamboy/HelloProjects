//
//  MyThemeProvider.h
//
//
//  Created by wesley chen on 2020/8/9.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCColorProvider.h"

NS_ASSUME_NONNULL_BEGIN

//#111F2C 66
#define font_color        @"font_color"
//#0089FF
#define unread_font_color @"unread_font_color"

#define ThemeID1 @"ThemeID1"
#define ThemeID2 @"ThemeID2"

@protocol WCColorProvider;

@interface DGIMUIThemeProvider : NSObject <WCColorProvider>

@end

NS_ASSUME_NONNULL_END
