//
//  HelloStaticLibrary.m
//  HelloStaticLibrary
//
//  Created by wesley_chen on 16/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "HelloStaticLibrary.h"

@implementation HelloStaticLibrary
- (void)test {
    @try {
//        NSLog(@"a");
        NSObject *a = [[NSObject alloc] init];
    }
    @catch (NSException *e) {

    }
    
//    NSLog(@"a");
}
@end
