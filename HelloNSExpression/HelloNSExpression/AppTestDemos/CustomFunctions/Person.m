//
//  Person.m
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/12/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "Person.h"

@implementation Person {
    NSString *_name;
    Job *_job;
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (NSString *)setName:(NSString *)name {
    _name = name;
    return _name;
}

- (NSString *)name {
    return _name;
}

- (Job *)setJob:(Job *)job {
    _job = job;
    return _job;
}

- (Job *)job {
    return _job;
}

@end
