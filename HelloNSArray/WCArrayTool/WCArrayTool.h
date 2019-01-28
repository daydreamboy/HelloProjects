//
//  WCArrayTool.h
//  HelloNSArray
//
//  Created by wesley_chen on 2018/12/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCArrayTool : NSObject

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
 Get a shuffled array

 @param array the original array
 @return the shuffled array. If the original array is empty or has one element, will return the original array.
 @discussion This method not use -[NSArray(GameplayKit) shuffledArray] because it needs import the GameplayKit frameworks
             and it's only avaiable on iOS 10+.
 @see https://stackoverflow.com/a/56656
 */
+ (nullable NSArray *)shuffledArrayWithArray:(NSArray *)array;

/**
 Insert an array of objects at the index

 @param array the original array
 @param objects the objects to insert
 @param index the index
 @return the new array
 */
+ (nullable NSArray *)insertObjectsWithArray:(NSArray *)array objects:(NSArray *)objects atIndex:(NSUInteger)index;

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

@end

NS_ASSUME_NONNULL_END
