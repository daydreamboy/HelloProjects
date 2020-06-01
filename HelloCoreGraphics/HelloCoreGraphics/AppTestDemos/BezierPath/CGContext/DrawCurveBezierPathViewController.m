//
//  DrawCurveBezierPathViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/5/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "DrawCurveBezierPathViewController.h"

// private
#define __VARIABLE_CONCAT_IMPL(x, y) x##y
/**
 Concatenate `a` and `b` into a variable name `ab`
 
 @param a the first part
 @param b the second part
 */
#define VARIABLE_CONCAT(a, b) __VARIABLE_CONCAT_IMPL(a, b)

#define UL unsigned long
#define znew  ((z=36969*(z&65535)+(z>>16))<<16)
#define wnew  ((w=18000*(w&65535)+(w>>16))&65535)
#define MWC   (znew+wnew)
#define SHR3  (jsr=(jsr=(jsr=jsr^(jsr<<17))^(jsr>>13))^(jsr<<5))
#define CONG  (jcong=69069*jcong+1234567)
#define KISS  ((MWC^CONG)+SHR3) \
static UL z=362436069*(int)__TIMESTAMP__, w=521288629*(int)__TIMESTAMP__, \
   jsr=123456789*(int)__TIMESTAMP__, jcong=380116160*(int)__TIMESTAMP__;

@interface DrawCurveBezierPathViewController ()

@end

@implementation DrawCurveBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    id VARIABLE_CONCAT(a, __COUNTER__) = @"123";
    id VARIABLE_CONCAT(a, __COUNTER__) = @"123";
    
    (int)__TIMESTAMP__;
}

@end
