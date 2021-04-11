//
//  Person.h
//  HelloKeyValueCoding
//
//  Created by wesley_chen on 2019/7/16.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Account;

@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) NSUInteger age;

@property (nonatomic, strong) Account *basicAccount;
@property (nonatomic, strong) NSMutableArray<Account *> *accounts;
@property (nonatomic, strong) NSArray<Account *> *frozenAccounts;

- (instancetype)initWithAge:(NSUInteger)age;
- (void)addAccount:(Account *)account;

@end

NS_ASSUME_NONNULL_END
