//
//  addValue.m
//  HelloARMAssembly
//
//  Created by wesley_chen on 07/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface aViewController : UIViewController

@end

@implementation aViewController

- (void)foo {
    int add = [self addValue:12 toValue:34];
    NSLog(@"add = %i", add);
}

- (int)addValue:(int)a toValue:(int)b {
    int c = a + b;
    return c;
}
@end

