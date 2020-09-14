//
//  MyThemeProvider.m
//  
//
//  Created by Johnson on 2020/8/9.
//  Copyright © 2020 Johnson. All rights reserved.
//

#import "DGIMUIThemeProvider.h"
#import "WCColorProvider.h"
#import "UIColor+HexCategory.h"

static NSDictionary *im_defaultDict = nil;
static NSDictionary *im_defaultDict2 = nil;

@implementation DGIMUIThemeProvider

- (instancetype)init {
    if (self = [super init]) {
        im_defaultDict = @{
            @"font_color":        @"#00FF00",
            @"unread_font_color": @"#00FFFF",
        };
        
        im_defaultDict2 = @{
            @"font_color":        @"#FF0000",
            @"unread_font_color": @"#FF00FF",
        };

    }
    return self;
}

- (UIColor *)colorWithThemeIdentifier:(NSString *)identifier colorKey:(NSString *)colorKey {
    if ([identifier isEqualToString:ThemeID1]) {
        NSString *hexString = im_defaultDict[colorKey];
        return [UIColor dg_colorWithHexString:hexString];
    }
    else {
        NSString *hexString = im_defaultDict2[colorKey];
        return [UIColor dg_colorWithHexString:hexString];
    }
}

- (BOOL)supportVarietyTheme {
    return NO;
}

@end
