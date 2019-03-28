//
//  Person.m
//  Tests
//
//  Created by wesley_chen on 2019/3/27.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)init {
    self = [super init];

    if (self) {
        _name = @"unknown";
    }

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> - name: %@", NSStringFromClass([self class]), self, self.name];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%p %@", self, self.name];
}

@end
