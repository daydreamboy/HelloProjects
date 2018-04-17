//
//  CGRectViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2018/4/17.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CGRectViewController.h"

/**
 Safe convert NSString to CGRect

 @param string the NSString represents CGRect
 @return the CGRect. If the NSString is malformed, return the CGRectNull
 */
CGRect WCCGRectFromString(NSString *string)
{
    NSString *compactString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([compactString isEqualToString:@"{{0,0},{0,0}}"]) {
        return CGRectZero;
    }
    else {
        CGRect rect = CGRectFromString(string);
        if (CGRectEqualToRect(rect, CGRectZero)) {
            return CGRectNull;
        }
        else {
            return rect;
        }
    }
}

@interface CGRectViewController ()

@end

@implementation CGRectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_CGRectNull];
    [self test_CGRectFromString];
    [self test_WCCGRectFromString];
}

- (void)test_CGRectNull {
    NSValue *value = [NSValue valueWithCGRect:CGRectNull];
    NSLog(@"%@", value);
    
    CGRect rect = [value CGRectValue];
    if (CGRectIsNull(rect)) {
        NSLog(@"null rect");
    }
    else {
        NSLog(@"rect: %@", NSStringFromCGRect(rect));
    }
}

- (void)test_CGRectFromString {
    NSString *str;
    CGRect rect;
    
    str = @"{{1,2},{3,4}";
    rect = CGRectFromString(str);
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
    
    str = @"{{1,2},{3,4}}";
    rect = CGRectFromString(str);
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
    
    str = @"{{5,  6}, {7, 8}}";
    rect = CGRectFromString(str);
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
}

- (void)test_WCCGRectFromString {
    NSString *str;
    CGRect rect;
    
    str = @"{{1,2},{3,4}";
    rect = WCCGRectFromString(str);
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
    
    str = @"{{0,0 } , {0,0}}";
    rect = WCCGRectFromString(str);
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
    
    str = @"{{1,2},{3,4}}";
    rect = WCCGRectFromString(str);
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
    
    str = @"{{5,  6}   , {7, 8}}";
    rect = WCCGRectFromString(str);
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
}

@end
