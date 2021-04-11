//
//  Account.m
//  HelloKeyValueObserving
//
//  Created by wesley chen on 17/2/12.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "Account.h"
#import "Transaction.h"

@implementation Account {
    NSString *_privateIvarName1;
    NSString *_isPrivateIvarName2;
    NSString *privateIvarName3;
    NSString *isPrivateIvarName4;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _privateIvarName1 = @"private_ivar1";
        _isPrivateIvarName2 = @"private_ivar2";
        privateIvarName3 = @"private_ivar3";
        isPrivateIvarName4 = @"private_ivar4";
    }
    return self;
}

- (NSString *)getName {
    return @"Anonymous";
}

- (double)openingBalance {
    return 3.14;
}

// Note: for test to compare with isCountOfItemChanged
/*
- (NSInteger)countOfItemChanged {
    return 5;
}
 */

- (NSInteger)isCountOfItemChanged {
    return 5;
}

- (NSMutableArray *)_privateTransactions {
    return [@[] copy];
}

@end
