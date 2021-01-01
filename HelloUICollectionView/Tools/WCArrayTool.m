//
//  WCArrayTool.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2019/1/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCArrayTool.h"

@implementation WCArrayTool

+ (nullable NSArray *)shuffledArrayWithArray:(NSArray *)array {
    if (![array isKindOfClass:[NSArray class]]) {
        return array;
    }
    
    if (array.count <= 1) {
        return array;
    }
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:array];
    
    NSUInteger count = arrayM.count;
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [arrayM exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    
    return arrayM;
}

+ (nullable NSArray *)insertObjectsWithArray:(NSArray *)array objects:(NSArray *)objects atIndex:(NSUInteger)index {
    if (![array isKindOfClass:[NSArray class]] || ![objects isKindOfClass:[NSArray class]]) {
        return array;
    }
    
    if (index > array.count) {
        return array;
    }
    
    if (objects.count == 0) {
        return array;
    }
    
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:array.count + objects.count];
    NSArray *frontItems = [array subarrayWithRange:NSMakeRange(0, index)];
    NSArray *rearItems = [array subarrayWithRange:NSMakeRange(index, array.count - index)];
    [arrayM addObjectsFromArray:frontItems];
    [arrayM addObjectsFromArray:objects];
    [arrayM addObjectsFromArray:rearItems];
    
    return arrayM;
}

@end
