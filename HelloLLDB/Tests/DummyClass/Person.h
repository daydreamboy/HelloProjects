//
//  Person.h
//  Tests
//
//  Created by wesley_chen on 2020/3/30.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger age;

+ (instancetype)personWithName:(NSString *)name age:(NSUInteger)age;

@end

NS_ASSUME_NONNULL_END
