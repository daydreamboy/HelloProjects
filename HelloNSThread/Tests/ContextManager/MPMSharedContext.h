//
//  MPMSharedContext.h
//  Tests
//
//  Created by wesley_chen on 2019/6/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MPMContextItem <NSObject>
@property (nonatomic, assign, readonly) NSTimeInterval timestamp;
@property (nonatomic, strong, readonly) id object;

+ (instancetype)itemWithObject:(id)object;
- (NSString *)description;
@end

@protocol MPMSharedContext <NSObject>
@property (nonatomic, copy, nullable) NSString *name;

#pragma mark - List Semantic

- (void)appendItemWithObject:(id)object;
- (nullable id<MPMContextItem>)itemAtIndex:(NSUInteger)index;
- (NSArray<id<MPMContextItem>> *)allItems;

#pragma mark - Map Semantic

- (void)setItemWithObject:(id)object forKey:(NSString *)key;
- (nullable id<MPMContextItem>)itemForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
