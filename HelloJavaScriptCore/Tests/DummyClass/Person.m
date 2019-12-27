//
//  Person.m
//  Tests
//
//  Created by wesley_chen on 2019/2/15.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSString *)getFullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

+ (instancetype)createWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    Person *person = [[Person alloc] init];
    person.firstName = firstName;
    person.lastName = lastName;
    return person;
}

@end
