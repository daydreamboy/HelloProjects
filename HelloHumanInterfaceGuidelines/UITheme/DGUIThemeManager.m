//
//  DGUIThemeManager.m
//  
//
//  Created by wesley chen on 2020/8/9.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "DGUIThemeManager.h"
#import "UIView+DGUITheme.h"
#import "UIColor+HexCategory.h"
#import "WCColorProvider.h"

NSString *const DGUIThemeDidChangeNotification = @"DGUIThemeDidChangeNotification";
NSString *const DGUIThemeCurrentIdentifierLocalKey = @"DGUIThemeCurrentIdentifierLocalKey";

@implementation DGUIThemeManager

- (instancetype)init {
    if (self = [super init]) {
        _currentThemeIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:DGUIThemeCurrentIdentifierLocalKey];
    }
    return self;
}


- (void)setCurrentThemeIdentifier:(NSString *)currentThemeIdentifier {
    BOOL themeChanged = _currentThemeIdentifier && ![_currentThemeIdentifier isEqualToString:currentThemeIdentifier];
    _currentThemeIdentifier = currentThemeIdentifier;
    if(themeChanged) {
        [self notifyThemeChanged];
    }
}


- (UIColor *)themeColorForKey:(NSString *)key {
    return [self themeColorForKey:key defaultHexValue:nil];
}


- (UIColor *)themeColorForKey:(NSString *)key defaultHexValue:(NSString * _Nullable)defaultHexValue {
    UIColor *color = [self.themeProvider colorWithThemeIdentifier:_currentThemeIdentifier colorKey:key];
    if (color) {
        return color;
    }else{
        if (defaultHexValue.length) {
            return [UIColor dg_colorWithHexString:defaultHexValue];
        }else{
            return [UIColor blackColor];
        }
    }
}

- (void)notifyThemeChanged {
    [[NSUserDefaults standardUserDefaults] setObject:_currentThemeIdentifier forKey:DGUIThemeCurrentIdentifierLocalKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:DGUIThemeDidChangeNotification object:self];
    
    [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!window.hidden && window.alpha > 0.01 && window.rootViewController) {
            if (window.rootViewController.isViewLoaded) {
                [window.rootViewController.view dgui_themeDidChangeByProvider:DGUIThemeManager.sharedManager.themeProvider identifier:DGUIThemeManager.sharedManager.currentThemeIdentifier];
            }
        }
    }];
}



#pragma mark - Class Method

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static DGUIThemeManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[DGUIThemeManager alloc]init];
    });
    return instance;
}


@end
