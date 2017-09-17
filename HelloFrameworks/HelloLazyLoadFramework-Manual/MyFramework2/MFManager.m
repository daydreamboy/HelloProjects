//
//  MFManager.m
//  HelloLazyLoadFramework-Manual
//
//  Created by wesley_chen on 17/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "MFManager.h"

@implementation MFManager

+ (void)load {
    NSLog(@"loading MFManager from MyFramework2");
}

+ (void)hello {
    NSLog(@"Hello from MyFramework2");
}

@end
