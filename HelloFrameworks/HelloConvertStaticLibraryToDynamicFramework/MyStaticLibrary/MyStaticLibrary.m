//
//  MyStaticLibrary.m
//  MyStaticLibrary
//
//  Created by wesley_chen on 11/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "MyStaticLibrary.h"
#import "PublicClass.h"
#import "PrivateClass.h"

@implementation MyStaticLibrary

- (void)helloMyStaticLibrary {
    NSLog(@"call helloMyStaticLibrary");
    
    PublicClass *publicInstance = [PublicClass new];
    [publicInstance helloPublicClass];
    
    PrivateClass *privateInstance = [PrivateClass new];
    [privateInstance helloPrivateClass];
}

@end
