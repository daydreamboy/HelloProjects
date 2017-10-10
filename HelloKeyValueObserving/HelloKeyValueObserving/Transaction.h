//
//  Transaction.h
//  HelloKeyValueObserving
//
//  Created by wesley chen on 17/2/14.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject
@property (nonatomic, assign) NSUInteger transactionId;
- (instancetype)initWithTransactionId:(NSUInteger)transactionId;
@end
