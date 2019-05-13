//
//  WCArrayTool.h
//  HelloUICollectionView
//
//  Created by wesley_chen on 2019/1/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCArrayTool : NSObject

@end

@interface WCArrayTool ()
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
@end

NS_ASSUME_NONNULL_END
