//
//  IndexedSubscriptingObject.m
//  Tests
//
//  Created by wesley_chen on 2019/5/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "IndexedSubscriptingObject.h"

@interface IndexedSubscriptingObject ()
@property (nonatomic, strong) NSMutableArray *internalArr;
@end

@implementation IndexedSubscriptingObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _internalArr = [NSMutableArray array];
    }
    return self;
}

- (nullable id)objectAtIndexedSubscript:(NSUInteger)index {
    if (index < _internalArr.count) {
        id element = _internalArr[index];
        if (element == [NSNull null]) {
            return nil;
        }
        else {
            return element;
        }
    }
    else {
        return nil;
    }
}

- (void)setObject:(nullable id)object atIndexedSubscript:(NSUInteger)index {
    if (object) {
        // update or insert
        if (index < _internalArr.count) {
            // update
            _internalArr[index] = object;
        }
        else {
            // insert
            for (NSInteger idx = _internalArr.count; idx < index; ++idx) {
                [_internalArr addObject:[NSNull null]];
            }
            [_internalArr addObject:object];
        }
    }
    else {
        // remove
        if (index < _internalArr.count) {
            _internalArr[index] = [NSNull null];
            
            // if index is the last, check forward to clean unused [NSNull null](s)
            if (index == _internalArr.count - 1) {
                [_internalArr removeObjectAtIndex:index];
                for (NSInteger idx = index - 1; idx >= 0; --idx) {
                    id element = _internalArr[idx];
                    if (element == [NSNull null]) {
                        [_internalArr removeObjectAtIndex:idx];
                    }
                    else {
                        break;
                    }
                }
            }
        }
    }
}

@end
