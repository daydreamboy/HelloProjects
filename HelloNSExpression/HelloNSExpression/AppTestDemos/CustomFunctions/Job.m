//
//  Job.m
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/12/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "Job.h"

@implementation Job {
    NSString *_name;
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (NSString *)name {
    return _name;
}

- (NSString *)setName:(NSString *)name {
    _name = name;
    return _name;
}

@end
