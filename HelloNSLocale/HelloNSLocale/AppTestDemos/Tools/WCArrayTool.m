//
//  WCArrayTool.m
//  HelloNSLocale
//
//  Created by wesley_chen on 2020/9/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCArrayTool.h"

@implementation WCArrayTool

+ (nullable NSArray<NSArray<NSString *> *> *)sortedGroupsByPrefixCharWithStrings:(NSArray<NSString *> *)strings {
    return [self sortedGroupsWithStrings:strings groupKeyBlock:^NSString *(NSString *string) {
        NSString *prefixChar = [string substringToIndex:1];
        return prefixChar;
    }];
}

+ (nullable NSArray<NSArray<NSString *> *> *)sortedGroupsWithStrings:(NSArray<NSString *> *)strings groupKeyBlock:(NSString * (^)(NSString *string))groupKeyBlock {
    if (!groupKeyBlock) {
        return nil;
    }
    
    NSMutableDictionary<NSString *, NSMutableArray *> *buckets = [NSMutableDictionary dictionaryWithCapacity:strings.count];
    
    for (NSString *string in strings) {
        NSString *groupKey = groupKeyBlock(string);
        
        NSMutableArray *bucket = buckets[groupKey];
        if (!bucket) {
            bucket = [NSMutableArray array];
        }
        
        [bucket addObject:string];
        buckets[groupKey] = bucket;
    }
    
    NSArray *groupKeys = [buckets.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *groupsM = [NSMutableArray arrayWithCapacity:groupKeys.count];
    
    for (NSString *groupKey in groupKeys) {
        [groupsM addObject:[buckets[groupKey] sortedArrayUsingSelector:@selector(compare:)]];
    }
    
    return [groupsM copy];
}

@end
