//
//  DGUITheme.h
//  DingGovMini
//
//  Created by wesley chen on 2019/9/24.
//  Copyright © 2019 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGUIThemeManager.h"
#import "UIColor+DGUITheme.h"
#import "WCColorProvider.h"

#define DGUIThemeColorForKey(dg_colorKey, dg_defaultHexString) \
({[UIColor dgui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof NSString * _Nullable colorKey, __kindof NSString * _Nullable defaultHexValue) { \
        return [[DGUIThemeManager sharedManager] themeColorForKey:colorKey defaultHexValue:defaultHexValue]; \
    } colorKey:dg_colorKey defaultColorHexValue:dg_defaultHexString];}) \

