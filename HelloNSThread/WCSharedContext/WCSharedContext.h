//
//  WCSharedContext.h
//  Tests
//
//  Created by wesley_chen on 2019/6/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WCContextItemObjectT <NSObject, NSCopying>
@end

/**
 The item in the shared context
 */
@protocol WCContextItem <NSObject, NSCopying>

/**
 The timestamp of the item created
 */
@property (nonatomic, assign, readonly) NSTimeInterval timestamp;

/**
 The object which the item holds
 
 @discussion the object confirms WCContextItemObjectT in fact,
 but use id type only to avoid warning when use it to assign another type variable
 */
@property (nonatomic, strong, readonly) id object;

+ (instancetype)itemWithObject:(id<WCContextItemObjectT>)object;
- (NSString *)description;
@end

/**
 A shared context
 
 @discussion WCSharedContext provides three sementics
 - List
 - Map
 - Map, but value as List
 The different sementics have their own APIs
 */
@protocol WCSharedContext <NSObject>
@property (nonatomic, copy, nullable) NSString *name;

#pragma mark - List Semantic

- (void)appendItemWithObject:(id<WCContextItemObjectT>)object;
- (nullable id<WCContextItem>)itemAtIndex:(NSUInteger)index;
- (NSArray<id<WCContextItem>> *)allItems;
- (void)cleanupForList;

#pragma mark - Map Semantic

- (void)setItemWithObject:(id<WCContextItemObjectT>)object forKey:(NSString *)key;
- (nullable id<WCContextItem>)itemForKey:(NSString *)key;
- (void)cleanupForMap;

#pragma mark - Map Nesting List Semantic

- (void)appendItemWithObject:(id<WCContextItemObjectT>)object forKey:(NSString *)key;
- (nullable NSArray<id<WCContextItem>> *)itemListForKey:(NSString *)key;
- (void)cleanupForMapNestingList;

@end

NS_ASSUME_NONNULL_END
