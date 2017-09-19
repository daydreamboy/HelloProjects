//
//  MyManager.m
//  HelloFramework
//
//  Created by wesley_chen on 15/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "MyManager.h"

@interface MyManager ()
@property (nonatomic, copy) NSString *name;
@end

@implementation MyManager

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

+ (void)hello {
    NSLog(@"hello MyManager from MyFramework.framework");
}

- (void)sayHello {
    NSLog(@"hello %@", self.name);
}

@end
