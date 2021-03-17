//
//  Person.h
//  Tests
//
//  Created by wesley_chen on 2019/7/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Job : NSObject
@property (nonatomic, copy) NSString *name;
@end

@interface Person : NSObject
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, strong, nullable) Job *job;

+ (instancetype)personWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age;
+ (instancetype)personWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age jobName:(NSString *)jobName;

@end

NS_ASSUME_NONNULL_END
