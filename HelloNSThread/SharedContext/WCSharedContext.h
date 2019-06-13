//
//  WCSharedContext.h
//  Tests
//
//  Created by wesley_chen on 2019/6/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The item in the shared context
 */
@protocol WCContextItem <NSObject>

/**
 The timestamp of the item created
 */
@property (nonatomic, assign, readonly) NSTimeInterval timestamp;

/**
 The object which the item holds
 */
@property (nonatomic, strong, readonly) id object;

+ (instancetype)itemWithObject:(id)object;
- (NSString *)description;
@end

/**
 A shared context
 */
@protocol WCSharedContext <NSObject>
@property (nonatomic, copy, nullable) NSString *name;

#pragma mark - List Semantic

- (void)appendItemWithObject:(id)object;
- (nullable id<WCContextItem>)itemAtIndex:(NSUInteger)index;
- (NSArray<id<WCContextItem>> *)allItems;
- (void)removeAllItems;

#pragma mark - Map Semantic

- (void)setItemWithObject:(id)object forKey:(NSString *)key;
- (nullable id<WCContextItem>)itemForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
