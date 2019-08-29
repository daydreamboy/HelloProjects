//
//  WCThreadSafeMutableArray.h
//  HelloDyldFunctions
//
//  Created by wesley_chen on 2018/8/7.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCThreadSafeMutableArray<__covariant ObjectType> : NSMutableArray

@property (readonly) NSUInteger count;

- (void)addObject:(ObjectType)object;
- (void)insertObject:(ObjectType)object atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)object;
- (instancetype)init;
- (instancetype)initWithCapacity:(NSUInteger)capacity;

@end
