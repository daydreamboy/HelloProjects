//
//  Person.m
//  Tests
//
//  Created by wesley_chen on 2019/7/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (instancetype)personWithFirstName:(NSString *)firstName lastName:(NSString *)lastName age:(NSUInteger)age {
    Person *p = [Person new];
    p.firstName = firstName;
    p.lastName = lastName;
    p.age = age;
    
    return p;
}

@end
