//
//  main.m
//  HelloAddingProperties
//
//  Created by chenliang-xy on 14-12-15.
//  Copyright (c) 2014年 chenliang-xy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Addition.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSString *string = [NSString string] ;
        string.defaultHashKey = @"Ciao";
        [string printHashKey] ;
    }
    return 0;
}
