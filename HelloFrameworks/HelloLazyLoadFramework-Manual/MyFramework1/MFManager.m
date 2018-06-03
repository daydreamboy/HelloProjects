//
//  MFManager.m
//  HelloLazyLoadFramework-Manual
//
//  Created by wesley_chen on 17/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "MFManager.h"

void __attribute__((constructor)) setupWhenImageLoad() {
    NSLog(@"image load");
}

@interface Manager1 : NSObject <ManagerBehavior>

@end

@implementation Manager1
- (NSString *)defaultName {
    return @"Manager1 (MyFramework1)";
}
@end

@implementation MFManager

+ (void)load {
    NSLog(@"loading MFManager from MyFramework1");
}

+ (void)hello {
    NSLog(@"Hello from MyFramework1");
}

- (void)helloWithName:(NSString *)name {
    NSLog(@"Hello `%@` from MyFramework1", name);
}

+ (id<ManagerBehavior>)defaultManager {
    return [Manager1 new];
}

@end
