//
//  Person.m
//  Tests
//
//  Created by wesley_chen on 2020/3/30.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (instancetype)personWithName:(NSString *)name age:(NSUInteger)age {
    Person *person = [[Person alloc] init];
    person.name = name;
    person.age = age;
    
    return person;
}

@end
