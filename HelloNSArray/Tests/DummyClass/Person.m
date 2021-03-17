//
//  Person.m
//  Tests
//
//  Created by wesley_chen on 2019/7/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "Person.h"

@implementation Job

@end

@implementation Person

+ (instancetype)personWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age {
    Person *p = [Person new];
    p.firstName = firstName;
    p.lastName = lastName;
    p.age = age;
    
    return p;
}

+ (instancetype)personWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age jobName:(NSString *)jobName {
    Person *p = [Person new];
    p.firstName = firstName;
    p.lastName = lastName;
    p.age = age;
    
    Job *job = [Job new];
    job.name = jobName;
    p.job = job;
    
    return p;
}

@end
