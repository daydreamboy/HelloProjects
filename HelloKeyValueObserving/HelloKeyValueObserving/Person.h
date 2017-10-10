//
//  Person.h
//  HelloKeyValueObserving
//
//  Created by wesley chen on 17/2/12.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;

@interface Person : NSObject
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy, readonly) NSString *fullName;

@property (nonatomic, strong) NSMutableArray<Account *> *accounts;
@property (nonatomic, assign) double totalOfOpeningBalance;

- (void)addAccount:(Account *)account;
- (Account *)accountWithName:(NSString *)name;
- (void)removeAllAccounts;

@end
