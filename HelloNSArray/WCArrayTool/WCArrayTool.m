//
//  WCArrayTool.m
//  HelloNSArray
//
//  Created by wesley_chen on 2018/12/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCArrayTool.h"
#import <UIKit/UIKit.h>

// >= `version`
#ifndef SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#endif

@implementation WCArrayTool

#pragma mark - Creation

+ (nullable NSArray *)arrayWithPlaceholderObject:(id)placeholderObject count:(NSUInteger)count allowMutable:(BOOL)allowMutable {
    if (!placeholderObject) {
        return nil;
    }
    
    if (count == 0) {
        return allowMutable ? [NSMutableArray array] : [NSArray array];
    }
    
    const void **buffer = malloc(sizeof(id) * count);
    for (NSUInteger i = 0; i < count; ++i) {
        buffer[i] = (__bridge const void *)placeholderObject;
    }
    // @see https://stackoverflow.com/a/10276091
    NSArray *array = [NSArray arrayWithObjects:(__unsafe_unretained id *)(void *)buffer count:count];
    free(buffer);
    
    return allowMutable ? [array mutableCopy] : array;
}

#pragma mark - Modification

+ (nullable NSArray *)moveObjectWithArray:(NSArray *)array fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
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
    
    return [arrayM copy];
}

+ (nullable NSArray *)removeObjectAtIndexWithArray:(NSArray *)array atIndex:(NSUInteger)index allowMutable:(BOOL)allowMutable {
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    if (index >= array.count) {
        return nil;
    }
    
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:array.count];
    [arrM addObjectsFromArray:array];
    [arrM removeObjectAtIndex:index];
    
    return allowMutable ? arrM : [arrM copy];
}

#pragma mark > Convert

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

+ (nullable NSArray *)collapsedArrayWithArray:(NSArray *)array keyPaths:(nullable NSArray<NSString *> *)keyPaths {
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    if (keyPaths && ![keyPaths isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:array];
    
    if (keyPaths.count) {
        NSMutableSet *lookup = [[NSMutableSet alloc] init];
        NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:array.count];
        
        for (NSInteger index = 0; index < [arrM count]; index++) {
            NSMutableString *identifier = [NSMutableString string];
            NSObject *element = arrM[index];
            
            for (NSString *keyPath in keyPaths) {
                @try {
                    if ([keyPath containsString:@"."]) {
                        [identifier appendFormat:@"_%@", [element valueForKeyPath:keyPath]];
                    }
                    else {
                        [identifier appendFormat:@"_%@", [element valueForKey:keyPath]];
                    }
                }
                @catch(NSException *e) {
#if DEBUG
                    NSLog(@"[%@] an exception occurred: %@", NSStringFromClass(self), e);
#endif
                    return nil;
                }
            }
            
            if ([lookup containsObject:identifier]) {
                [toRemove addObject:element];
            }
            else {
                [lookup addObject:identifier];
            }
        }
        
        [arrM removeObjectsInArray:toRemove];
        
        return arrM;
    }
    else {
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:array.count];
        
        for (id object in array) {
            if (![arrM containsObject:object]) {
                [arrM addObject:object];
            }
        }
        
        return arrM;
    }
}

+ (nullable NSArray *)reversedArrayWithArray:(NSArray *)array {
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSArray *reversedArray = [[array reverseObjectEnumerator] allObjects];
    return reversedArray;
}

#pragma mark - Subarray

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

#pragma mark - Comparison

+ (BOOL)compareArraysWithArray1:(NSArray *)array1 array2:(NSArray *)array2 considerOrder:(BOOL)considerOrder {
    
    if (![array1 isKindOfClass:[NSArray class]] || ![array2 isKindOfClass:[NSArray class]]) {
        return NO;
    }
    
    if (considerOrder) {
        return [array1 isEqualToArray:array2];
    }
    else {
        return [[NSCountedSet setWithArray:array1] isEqualToSet:[NSCountedSet setWithArray:array2]];
    }
}

#pragma mark - Sort

+ (nullable NSArray *)sortArrayWithArray:(NSArray *)array ascending:(BOOL)ascending keyPaths:(nullable NSArray<NSString *> *)keyPaths {
    if (keyPaths && ![keyPaths isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    if (!keyPaths || keyPaths.count == 0) {
        keyPaths = @[ @"self" ];
    }
    
    NSMutableArray<NSSortDescriptor *> *sorters = [NSMutableArray arrayWithCapacity:array.count];
    for (NSString *keyPath in keyPaths) {
        if ([keyPath isKindOfClass:[NSString class]] && keyPath.length) {
            [sorters addObject:[NSSortDescriptor sortDescriptorWithKey:keyPath ascending:ascending]];
        }
    }
    
    if (sorters.count == 0) {
        return array;
    }
    
    NSArray *sortedArray;
    
    @try {
        sortedArray = [array sortedArrayUsingDescriptors:sorters];
    }
    @catch (NSException *e) {
#if DEBUG
        NSLog(@"an exception occurred: %@", e);
#endif
    }
    
    return sortedArray;
}

#pragma mark - Query Item

+ (nullable id)itemWithArray:(NSArray *)array atIndex:(NSInteger)index {
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    // Note: range is [0, array.count-1]
    if (index >= 0 && index >= array.count) {
        return nil;
    }
    
    // Note: range is [-array.count, -1]
    if (index < 0 && ABS(index) > array.count) {
        return nil;
    }
    
    return index >= 0 ? array[index] : array[array.count + index];
    
    return nil;
}

#pragma mark - Assistant Methods

+ (NSArray *)arrayWithLetters:(BOOL)isUppercase {
    if (isUppercase) {
        static NSArray *uppercaseLetters;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            uppercaseLetters = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z" componentsSeparatedByString:@" "];
        });
        return uppercaseLetters;
    }
    else {
        static NSArray *lowercaseLetters;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            lowercaseLetters = [@"a b c d e f g h i j k l m n o p q r s t u v w x y z" componentsSeparatedByString:@" "];
        });
        return lowercaseLetters;
    }
}

@end
