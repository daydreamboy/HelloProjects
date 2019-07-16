//
//  Transaction.h
//  Tests
//
//  Created by wesley_chen on 2019/7/16.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Transaction : NSObject
@property (nonatomic, copy) NSString *payee;   // To whom
@property (nonatomic, strong) NSNumber *amount;  // How much
@property (nonatomic, strong) NSDate *date;      // When

+ (instancetype)transactionWithPayee:(NSString *)payee amount:(NSNumber *)amount date:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
