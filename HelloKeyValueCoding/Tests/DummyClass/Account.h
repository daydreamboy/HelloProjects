//
//  Account.h
//  HelloKeyValueObserving
//
//  Created by wesley chen on 17/2/12.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Transaction;

@interface Account : NSObject
@property (nonatomic, copy)  NSString *name;
@property (nonatomic, assign) double openingBalance;
@property (nonatomic, assign) NSInteger countOfItemChanged;

@property (nonatomic, strong) NSMutableArray<Transaction *> *transactions;

@end
