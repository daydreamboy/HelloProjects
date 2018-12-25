//
//  WCArrayTool.m
//  HelloNSArray
//
//  Created by wesley_chen on 2018/12/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCArrayTool.h"

@implementation WCArrayTool

#pragma mark - Modification

+ (nullable NSArray *)arrayWithArray:(NSArray *)array moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (![array isKindOfClass:[NSArray class]]) {
        return array;
    }
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:array];
    if ((fromIndex != toIndex) && (fromIndex < arrayM.count && toIndex <= arrayM.count)) {
        id object = [arrayM objectAtIndex:fromIndex];
        [arrayM removeObjectAtIndex:fromIndex];
        [arrayM insertObject:object atIndex:toIndex];
    }
    
    return [NSArray arrayWithArray:arrayM];
}

+ (nullable NSArray *)subarrayWithArray:(NSArray *)array range:(NSRange)range {
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    if (range.location <= array.count) {
        if (range.length <= array.count - range.location) {
            return [array subarrayWithRange:range];
        }
        else {
            return nil;;
        }
    }
    else {
        return nil;
    }
}

+ (nullable NSArray *)subarrayWithArray:(NSArray *)array atLocation:(NSUInteger)location length:(NSUInteger)length {
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    if (location <= array.count) {
        if (length <= array.count - location) {
            return [array subarrayWithRange:NSMakeRange(location, length)];
        }
        else if (location < array.count || (array.count == location && length == 0)) {
            return [array subarrayWithRange:NSMakeRange(location, array.count - location)];
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}

@end
