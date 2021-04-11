//
//  Transaction.m
//  Tests
//
//  Created by wesley_chen on 2019/7/16.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction {
    NSString *_privateIvarName1;
    NSString *_isPrivateIvarName2;
    NSString *privateIvarName3;
    NSString *isPrivateIvarName4;
}

+ (instancetype)transactionWithPayee:(NSString *)payee amount:(NSNumber *)amount date:(NSDate *)date {
    Transaction *transaction = [Transaction new];
    transaction.payee = payee;
    transaction.amount = amount;
    transaction.date = date;
    
    transaction.balance = [amount doubleValue];
    
    return transaction;
}

- (void)setPayee:(NSString *)payee {
    _payee = payee;
}

- (void)_setAmount:(NSNumber *)amount {
    _amount = amount;
}

@end
