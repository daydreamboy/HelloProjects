//
//  Transaction.m
//  HelloKeyValueObserving
//
//  Created by wesley chen on 17/2/14.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction
- (instancetype)initWithTransactionId:(NSUInteger)transactionId {
    self = [super init];
    if (self) {
        _transactionId = transactionId;
    }
    return self;
}
@end
