//
//  WCColorTool.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/10/31.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCColorTool.h"

@implementation WCColorTool

+ (UIColor *)randomColor{
    CGFloat red = arc4random() % 255 / 255.0f;
    CGFloat green = arc4random() % 255 / 255.0f;
    CGFloat blue = arc4random() % 255 / 255.0f;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    
    return color;
}

@end
