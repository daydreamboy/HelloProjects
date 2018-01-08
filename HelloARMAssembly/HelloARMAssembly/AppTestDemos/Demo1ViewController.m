//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "Demo1ViewController.h"

@interface Demo1ViewController ()

@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self foo];
}

- (void)foo {
    int add = [self addValue:12 toValue:34];
    NSLog(@"add = %i", add);
}

- (int)addValue:(int)a toValue:(int)b {
    int c = a + b;
    return c;
}

@end
