//
//  WCArrayTool.h
//  HelloNSArray
//
//  Created by wesley_chen on 2018/12/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Options for mapping an array
 */
typedef NS_OPTIONS(NSUInteger, WCArrayMappingOption) {
    /// If mapping failed, use [NSNull null] as placeholder
    WCArrayMappingOptionUseNullIfError = 1 << 0,
};

NS_ASSUME_NONNULL_BEGIN

@interface WCArrayTool : NSObject

#pragma mark - Creation

/**
 Get an array with all same object and repeat N times

 @param placeholderObject the placeholder object
 @param count the size of the returned array
 @param allowMutable YES to return a mutable array, or NO to return an immutable array
 @return the array with all same objects and size is count
 @see https://stackoverflow.com/questions/1071648/creating-an-nsarray-initialized-with-count-n-all-of-the-same-object
 */
+ (nullable NSArray *)arrayWithPlaceholderObject:(id)placeholderObject count:(NSUInteger)count allowMutable:(BOOL)allowMutable;

#pragma mark - Modification

/**
 Move item from index to index

 @param array the array to modify, e.g. NSArray/NSMutableArray
 @param fromIndex the from index
 @param toIndex the to index
 @return the modificated array after movement
 @see https://stackoverflow.com/questions/4349669/nsmutablearray-move-object-from-index-to-index
 @discussion The item move to the toIndex, and the original item will move to the next position
 */
+ (nullable NSArray *)moveObjectWithArray:(NSArray *)array fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

/**
 Insert an array of objects at the index

 @param array the original array
 @param objects the objects to insert
 @param index the index
 @return the new array
 */
+ (nullable NSArray *)insertObjectsWithArray:(NSArray *)array objects:(NSArray *)objects atIndex:(NSUInteger)index;

/**
 Remove object at the index and return the modified one

 @param array the original array
 @param index the index of object to remove
 @param allowMutable YES if return a mutable array. NO if return an immutable array.
 @return the modified array. NSArray or NSMutableArray
 */
+ (nullable NSArray *)removeObjectAtIndexWithArray:(NSArray *)array atIndex:(NSUInteger)index allowMutable:(BOOL)allowMutable;

#pragma mark > Convert

/**
 Get a shuffled array

 @param array the original array
 @return the shuffled array. If the original array is empty or has one element, will return the original array.
 @discussion This method not use -[NSArray(GameplayKit) shuffledArray] because it needs import the GameplayKit frameworks
             and it's only avaiable on iOS 10+.
 @see https://stackoverflow.com/a/56656
 */
+ (nullable NSArray *)shuffledArrayWithArray:(NSArray *)array;

/**
 Remove duplicated element in the array by the combination of the key paths (or properties).

 @param array the array to deduplicate
 @param keyPaths the key path array.
 \ If nil or empty, deduplicate the same elements by NSArray's containsObject: method.
 \ If key path not exist, return nil.
 \ If the key path is not NSString, return the nil.
 @return the deduplicated array. Return nil if some error occur.
 @see https://stackoverflow.com/questions/7491805/nsarray-remove-objects-with-duplicate-properties
 @discussion For the duplicated elements by the order in the array, the first element to get, the others to ignore.
 */
+ (nullable NSArray *)collapsedArrayWithArray:(NSArray *)array keyPaths:(nullable NSArray<NSString *> *)keyPaths;

/**
 Get a reversed array
 
 @param array the array
 @return the reversed array
 @see https://stackoverflow.com/a/586529
 */
+ (nullable NSArray *)reversedArrayWithArray:(NSArray *)array;

/**
 Mapping an array by item's key path
 
 @param array the original array
 @param keyPath the key path, e.g. @"a.b", @"a.[1].c"
 @param options the options
 - kNilOptions If mapped the item failed, will filter out the item
 - WCArrayMappingOptionUseNullIfError If mapped the item failed, use [NSNull null] as placeholder
 
 @return the mapped array
 */
+ (nullable NSArray *)mappedArrayWithArray:(NSArray *)array keyPath:(NSString *)keyPath options:(WCArrayMappingOption)options;

+ (nullable NSArray *)mappedArrayWithArray:(NSArray *)array usingBlock:(id _Nullable(^ _Nullable)(id item, NSUInteger idx, BOOL * _Nonnull stop))block options:(WCArrayMappingOption)options;

#pragma mark - Subarray

/**
 Get subarray from the array with range

 @param array the original array
 @param range the range for the subarray. The valid range.location is [0, array.count].
 @return the subarray. Return nil if the range is invalid, e.g. location out of [0, array.count].
 @discussion If the location is array.count, the length is 0, return an empty array, but the length is > 0, return nil.
 */
+ (nullable NSArray *)subarrayWithArray:(NSArray *)array range:(NSRange)range;

/**
 Get subarray from the array with location and length

 @param array the original array
 @param location the location. The valid location is [0, array.count].
 @param length the length. If the length > string.length - location, will return the subarray from location to the end
 @return the subarray. Return nil if the range is invalid, e.g. location out of [0, array.count].
 @discussion If the location is array.count, the length is 0, return an empty array, but the length is > 0, return nil.
 */
+ (nullable NSArray *)subarrayWithArray:(NSArray *)array atLocation:(NSUInteger)location length:(NSUInteger)length;

#pragma mark - Comparison

/**
 Compare elements of two arrays

 @param array1 the first array
 @param array2 the second array
 @param considerOrder YES if consider the order, NO if not consider the order
 @return YES if the array1 equals to the array2, NO if the array1 not equals to the array2 or the parameters are invalid.
 @discussion The array allows multiple same elements
 @see https://stackoverflow.com/a/15732286
 */
+ (BOOL)compareArraysWithArray1:(NSArray *)array1 array2:(NSArray *)array2 considerOrder:(BOOL)considerOrder;

#pragma mark - Sort

/**
 Sort array by key path of the element

 @param array the original array
 @param ascending the order
 @param keyPaths the array of key path. If nil, sort the array by itself. If the key not exists, the key ignored.
 @return the sorted array
 @discussion the element is not KVC compliant, return nil if catch the exception.
 */
+ (nullable NSArray *)sortArrayWithArray:(NSArray *)array ascending:(BOOL)ascending keyPaths:(nullable NSArray<NSString *> *)keyPaths;

#pragma mark - Query Item

/**
 Get item the index (>=0) by forward or the index (<0) by backward
 
 @param array the original array
 @param index the index. index >= 0 by forward or index < 0 by backward,
 @return the item at the index
 @discussion index >= 0, range is [0, array.count-1]; index < 0, range is [-array.count, -1]
 */
+ (nullable id)itemWithArray:(NSArray *)array atIndex:(NSInteger)index;

#pragma mark - Assistant Methods

/**
 Get an array of letters with uppercase or lowercase

 @param isUppercase YES, uppercase or NO, lowercase
 @return the array of letters
 @note the array of letters can be used as index, e.g. UITableView's index
 */
+ (NSArray *)arrayWithLetters:(BOOL)isUppercase;

@end

NS_ASSUME_NONNULL_END
