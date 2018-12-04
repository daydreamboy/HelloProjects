//
//  WCFontTool.m
//  HelloUIFont
//
//  Created by wesley_chen on 2018/11/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCFontTool.h"

@implementation WCFontTool

#pragma mark - Get Font Names

+ (NSDictionary<NSString *, NSArray *> *)allFontNamesTable {
    static NSMutableDictionary *sTable;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sTable = [NSMutableDictionary dictionary];
        
        NSArray<NSString *> *familyNames = [UIFont familyNames];
        for (NSString *familyName in familyNames) {
            NSMutableArray *sortedFontNames = [NSMutableArray array];
            NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
            if (fontNames.count) {
                [sortedFontNames addObjectsFromArray:fontNames];
                [sortedFontNames sortUsingSelector:@selector(compare:)];
            }
            sTable[familyName] = sortedFontNames;
        }
    });
    
    return sTable;
}

+ (NSArray<NSString *> *)allFontFamilyNames {
    static NSArray *sSortedFontFamilyNames;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSortedFontFamilyNames = [[[self allFontNamesTable] allKeys] sortedArrayUsingSelector:@selector(compare:)];
    });
    
    return sSortedFontFamilyNames;
}

+ (NSArray<NSString *> *)allFontNames {
    static NSMutableArray *sFontNames;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sFontNames = [NSMutableArray array];
        [[self allFontNamesTable] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray * _Nonnull obj, BOOL * _Nonnull stop) {
            [sFontNames addObjectsFromArray:obj];
        }];
        [sFontNames sortUsingSelector:@selector(compare:)];
    });
    
    return sFontNames;
}

#pragma mark - Get Font

+ (nullable UIFont *)fontWithFormattedName:(NSString *)formattedName {
    if (![formattedName isKindOfClass:[NSString class]] || formattedName.length == 0) {
        return nil;
    }
    
    UIFont *font;
    NSArray *parts = [formattedName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (parts.count >= 2) {
        NSString *fontName = parts[0];
        CGFloat fontSize = [parts[1] doubleValue];
        
        if (fontName.length && fontSize > 0) {
            font = [UIFont fontWithName:fontName size:fontSize];
        }
        
        // Check system font
        if (!font) {
            font = [self systemFontWithFormattedName:formattedName];
        }
    }
    
    return font;
}

+ (nullable UIFont *)systemFontWithFormattedName:(NSString *)formattedName {
    if (![formattedName isKindOfClass:[NSString class]] || formattedName.length == 0) {
        return nil;
    }
    
    UIFont *font;
    NSArray *parts = [formattedName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (parts.count >= 2) {
        NSString *fontName = parts[0];
        CGFloat fontSize = [parts[1] doubleValue];
        
        if (fontName.length && fontSize > 0) {
            if ([fontName isEqualToString:@"System"]) {
                font = [UIFont systemFontOfSize:fontSize];
            }
            else if ([fontName isEqualToString:@"System-Bold"]) {
                font = [UIFont boldSystemFontOfSize:fontSize];
            }
            else if ([fontName isEqualToString:@"System-Italic"]) {
                font = [UIFont italicSystemFontOfSize:fontSize];
            }
        }
    }
    
    return font;
}

@end
