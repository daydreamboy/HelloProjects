//
//  KVCProhibitedPerson.h
//  Tests
//
//  Created by wesley_chen on 2021/4/7.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVCProhibitedPerson : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) NSString *age;

- (instancetype)initWithAge:(NSString *)age;

@end

NS_ASSUME_NONNULL_END
