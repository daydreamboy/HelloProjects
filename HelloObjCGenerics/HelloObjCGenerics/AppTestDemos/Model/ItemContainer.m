//
//  ItemContainer.m
//  HelloObjCGenerics
//
//  Created by wesley_chen on 21/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "ItemContainer.h"

@interface Item<__covariant ObjectType> : NSObject
@property (nonatomic, strong) ObjectType object;
@end

@implementation Item
- (instancetype)initWithObject:(id)object {
    self = [super init];
    if (self) {
        _object = object;
    }
    return self;
}
@end

#pragma mark -

@interface ItemContainer<__covariant ObjectType> ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, Item<ObjectType> *> *dictionaryItems;
@end

@implementation ItemContainer

- (instancetype)init {
    self = [super init];
    if (self) {
        _dictionaryItems = [[NSMutableDictionary alloc] initWithCapacity:100];
    }
    return self;
}

- (void)addItem:(id)item forKey:(NSString *)key {
    if (item && key) {
        @synchronized(self.dictionaryItems) {
            self.dictionaryItems[key] = [[Item alloc] initWithObject:item];
            NSLog(@"%@", item);
        }
    }
}

- (void)removeItemForKey:(NSString *)key {
    if (key) {
        @synchronized(self.dictionaryItems) {
            [self.dictionaryItems removeObjectForKey:key];
        }
    }
}

@end
