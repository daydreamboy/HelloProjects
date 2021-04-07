//
//  KVCProhibitedPerson.m
//  Tests
//
//  Created by wesley_chen on 2021/4/7.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "KVCProhibitedPerson.h"

@implementation KVCProhibitedPerson

@synthesize age = _age;
@synthesize name = _name;

- (instancetype)initWithAge:(NSString *)age {
    self = [super init];
    if (self) {
        _age = age;
    }
    return self;
}

+ (BOOL)accessInstanceVariablesDirectly {
    return NO;
}

- (NSString *)name {
    return _name;
}

- (void)setName:(NSString *)name {
    _name = name;
}

@end
