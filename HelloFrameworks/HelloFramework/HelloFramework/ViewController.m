//
//  ViewController.m
//  HelloFramework
//
//  Created by wesley_chen on 15/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "ViewController.h"
#import <MyFramework/MyFramework.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyManager *manager = [[MyManager alloc] initWithName:@"John"];
    NSLog(@"%@", manager);
    
    MyManager *manager2 = [[NSClassFromString(@"MyManager") alloc] initWithName:@"John"];
    NSLog(@"%@", manager2);
}

@end
