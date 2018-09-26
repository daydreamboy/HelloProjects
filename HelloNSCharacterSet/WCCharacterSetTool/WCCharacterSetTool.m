//
//  WCCharacterSetTool.m
//  HelloNSCharacterSet
//
//  Created by wesley_chen on 2018/7/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCCharacterSetTool.h"

@interface WCCharacterSetTool ()
@property (nonatomic, strong, readonly, class) NSCache *cache;
@end

@implementation WCCharacterSetTool

@dynamic cache;
static NSCache *sCache;

+ (NSCache *)cache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sCache = [[NSCache alloc] init];
    });
    
    return sCache;
}

+ (nullable NSArray<NSString *> *)charactersInCharacterSet:(NSCharacterSet *)characterSet {
    if (![characterSet isKindOfClass:[NSCharacterSet class]]) {
        return nil;
    }
    
    NSString *key = [NSString stringWithFormat:@"%p", characterSet];
    NSArray *value = [self.cache objectForKey:key];
    if (value) {
        return value;
    }
    
    NSCharacterSet *charset = characterSet;
    NSMutableArray *array = [NSMutableArray array];
    for (int plane = 0; plane <= 16; plane++) {
        if ([charset hasMemberInPlane:plane]) {
            UTF32Char c;
            for (c = plane << 16; c < (plane + 1) << 16; c++) {
                if ([charset longCharacterIsMember:c]) {
                    UTF32Char c1 = OSSwapHostToLittleInt32(c); // To make it byte-order safe
                    NSString *s = [[NSString alloc] initWithBytes:&c1 length:4 encoding:NSUTF32LittleEndianStringEncoding];
                    [array addObject:s];
                }
            }
        }
    }
    [self.cache setObject:array forKey:key];
    
    return array;
}

@end
