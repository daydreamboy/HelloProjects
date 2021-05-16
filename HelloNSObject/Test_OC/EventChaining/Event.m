//
//  Event.m
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "Event.h"

@implementation Event

- (instancetype)initWithName:(NSString *)name userInfo:(nullable NSDictionary *)userInfo {
    self = [super init];
    if (self) {
        _name = name;
        _userInfo = userInfo;
    }
    return self;
}

@end
