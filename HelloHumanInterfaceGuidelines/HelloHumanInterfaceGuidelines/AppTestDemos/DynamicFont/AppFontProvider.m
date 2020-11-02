//
//  AppFontProvider.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/16.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "AppFontProvider.h"

NSString *AppFontKey_label_body = @"label_body";
NSString *AppFontKey_cell_title = @"cell_title";

NSString *AppValueKey_cell_height = @"cell_height";

@implementation AppFontProvider

- (UIFont *)fontWithProviderName:(NSString *)name forKey:(NSString *)key {
    if ([name isEqualToString:@"large"]) {
        NSDictionary *fonts = @{
            AppFontKey_label_body: [UIFont systemFontOfSize:40],
            AppFontKey_cell_title: [UIFont systemFontOfSize:30],
            @"label_callout": [UIFont systemFontOfSize:32],
            @"label_caption1": [UIFont systemFontOfSize:32],
            @"label_caption2": [UIFont systemFontOfSize:32],
            @"label_headline": [UIFont systemFontOfSize:32],
            @"label_subheadline": [UIFont systemFontOfSize:32],
            @"label_largeTitle": [UIFont systemFontOfSize:32],
            @"label_title1": [UIFont systemFontOfSize:32],
            @"label_title2": [UIFont systemFontOfSize:32],
            @"label_title3": [UIFont systemFontOfSize:32],
        };
        
        return fonts[key];
    }
    else if ([name isEqualToString:@"medium"]) {
        NSDictionary *fonts = @{
            AppFontKey_label_body: [UIFont systemFontOfSize:22],
            AppFontKey_cell_title: [UIFont systemFontOfSize:20],
            @"label_callout": [UIFont systemFontOfSize:32],
            @"label_caption1": [UIFont systemFontOfSize:32],
            @"label_caption2": [UIFont systemFontOfSize:32],
            @"label_headline": [UIFont systemFontOfSize:32],
            @"label_subheadline": [UIFont systemFontOfSize:32],
            @"label_largeTitle": [UIFont systemFontOfSize:32],
            @"label_title1": [UIFont systemFontOfSize:32],
            @"label_title2": [UIFont systemFontOfSize:32],
            @"label_title3": [UIFont systemFontOfSize:32],
        };
        
        return fonts[key];
    }
    else if ([name isEqualToString:@"default"]) {
        NSDictionary *fonts = @{
            AppFontKey_label_body: [UIFont systemFontOfSize:22],
            AppFontKey_cell_title: [UIFont systemFontOfSize:17],
            @"label_callout": [UIFont systemFontOfSize:32],
            @"label_caption1": [UIFont systemFontOfSize:32],
            @"label_caption2": [UIFont systemFontOfSize:32],
            @"label_headline": [UIFont systemFontOfSize:32],
            @"label_subheadline": [UIFont systemFontOfSize:32],
            @"label_largeTitle": [UIFont systemFontOfSize:32],
            @"label_title1": [UIFont systemFontOfSize:32],
            @"label_title2": [UIFont systemFontOfSize:32],
            @"label_title3": [UIFont systemFontOfSize:32],
        };
        
        return fonts[key];
    }
    else if ([name isEqualToString:@"small"]) {
        NSDictionary *fonts = @{
            AppFontKey_label_body: [UIFont systemFontOfSize:14],
            AppFontKey_cell_title: [UIFont systemFontOfSize:14],
            @"label_callout": [UIFont systemFontOfSize:32],
            @"label_caption1": [UIFont systemFontOfSize:32],
            @"label_caption2": [UIFont systemFontOfSize:32],
            @"label_headline": [UIFont systemFontOfSize:32],
            @"label_subheadline": [UIFont systemFontOfSize:32],
            @"label_largeTitle": [UIFont systemFontOfSize:32],
            @"label_title1": [UIFont systemFontOfSize:32],
            @"label_title2": [UIFont systemFontOfSize:32],
            @"label_title3": [UIFont systemFontOfSize:32],
        };
        
        return fonts[key];
    }
    else {
        return nil;
    }
}

- (nullable WCDynamicValue *)valueWithProviderName:(NSString *)name forKey:(NSString *)key {
    if ([name isEqualToString:@"large"]) {
        
        NSDictionary *fonts = @{
            AppValueKey_cell_height: WCDynamicValueDouble(80),
        };
        
        return fonts[key];
    }
    else if ([name isEqualToString:@"medium"]) {
        NSDictionary *fonts = @{
            AppValueKey_cell_height: WCDynamicValueDouble(60),
        };
        
        return fonts[key];
    }
    else if ([name isEqualToString:@"default"]) {
        NSDictionary *fonts = @{
            AppValueKey_cell_height: WCDynamicValueDouble(44),
        };
        
        return fonts[key];
    }
    else if ([name isEqualToString:@"small"]) {
        NSDictionary *fonts = @{
            AppValueKey_cell_height: WCDynamicValueDouble(20),
        };
        
        return fonts[key];
    }
    else {
        return nil;
    }
}

@end
