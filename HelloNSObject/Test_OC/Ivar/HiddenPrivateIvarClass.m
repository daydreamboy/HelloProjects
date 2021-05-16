//
//  HiddenPrivateIvarClass.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/5/15.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "HiddenPrivateIvarClass.h"
#import <UIKit/UIKit.h>

@implementation HiddenPrivateIvarClass {
@private
    NSString *_name;
    NSString *_job;
    CGSize _size;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _name = @"w";
        _job = @"hacker";
        _size = CGSizeMake(1, 2);
    }
    return self;
}

@end
