//
//  SomeTool.m
//  MyFramework3
//
//  Created by wesley_chen on 28/12/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "SomeTool.h"
#import "OrphanClassWithoutImpl.h"

@implementation SomeTool

- (instancetype)init {
    self = [super init];
    if (self) {
        [OrphanClassWithoutImpl doSomething];
    }
    return self;
}

@end
