//
//  Person.m
//  HelloKeyValueCoding
//
//  Created by wesley_chen on 2019/7/16.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize age = _age;
@synthesize name = _name;

- (instancetype)initWithAge:(NSString *)age {
    self = [super init];
    if (self) {
        _age = age;
    }
    return self;
}

- (NSString *)name {
    return _name;
}

- (void)setName:(NSString *)name {
    _name = name;
}

@end
