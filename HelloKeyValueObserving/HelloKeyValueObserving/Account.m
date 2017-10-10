//
//  Account.m
//  HelloKeyValueObserving
//
//  Created by wesley chen on 17/2/12.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "Account.h"
#import "Transaction.h"

@implementation Account

#pragma mark - KVO

// this method won't be never called, caused by automaticallyNotifiesObserversForKey: method is existing
+ (BOOL)automaticallyNotifiesObserversOfOpeningBalance {
    return NO;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    BOOL automatic = NO;
    if ([key isEqualToString:@"openingBalance"]) { // Note: disable automatic notify changing for `openingBalance`
        automatic = NO;
    }
    else {
        automatic = [super automaticallyNotifiesObserversForKey:key];
    }
    return automatic;
}

#pragma mark > Override setters

// override case 1: original setter method
/*
- (void)setOpeningBalance:(double)openingBalance {
    [self willChangeValueForKey:@"openingBalance"];
    _openingBalance = openingBalance;
    [self didChangeValueForKey:@"openingBalance"];
}
 */

// override case 2: avoid setting same value
/*
- (void)setOpeningBalance:(double)openingBalance {
    if (openingBalance != _openingBalance) {
        [self willChangeValueForKey:@"openingBalance"];
        _openingBalance = openingBalance;
        [self didChangeValueForKey:@"openingBalance"];
    }
}
 */

// override case 3: a setter for changind mutiple properties at once
- (void)setOpeningBalance:(double)openingBalance {
    [self willChangeValueForKey:@"openingBalance"];
    [self willChangeValueForKey:@"countOfItemChanged"];
    _openingBalance = openingBalance;
    _countOfItemChanged = _countOfItemChanged + 1;
    [self didChangeValueForKey:@"countOfItemChanged"];
    [self didChangeValueForKey:@"openingBalance"];
}

#pragma mark > Public Methods

- (void)removeTransactionsAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"transactions"];
    
    // Remove the transaction objects at the specified indexes.
    [_transactions removeObjectsAtIndexes:indexes];
    
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"transactions"];
}

@end
