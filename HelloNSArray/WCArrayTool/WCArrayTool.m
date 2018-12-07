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

+ (NSArray *)arrayWithArray:(NSArray *)array moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
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

@end
