//
//  WCTraitCollectionTool.m
//  HelloUITraitCollection
//
//  Created by wesley_chen on 2020/9/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCTraitCollectionTool.h"

@implementation WCTraitCollectionTool

+ (NSString *)stringFromSizeClass:(UIUserInterfaceSizeClass)sizeClass {
    switch (sizeClass) {
        case UIUserInterfaceSizeClassCompact:
            return @"Compact";
        case UIUserInterfaceSizeClassRegular:
            return @"Regular";
        case UIUserInterfaceSizeClassUnspecified:
        default: {
            return @"Unspecified";
        }
    }
}

+ (nullable NSString *)stringInfoWithTraitCollection:(UITraitCollection *)traitCollection {
    if (![traitCollection isKindOfClass:[UITraitCollection class]]) {
        return nil;
    }
    
    UIUserInterfaceSizeClass hSizeClass = [traitCollection horizontalSizeClass];
    UIUserInterfaceSizeClass vSizeClass = [traitCollection verticalSizeClass];
    
    return [NSString stringWithFormat:@"w%@ - h%@", [self stringFromSizeClass:hSizeClass], [self stringFromSizeClass:vSizeClass]];
}

@end
