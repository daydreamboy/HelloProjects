//
//  AccessThemeConfigurationViewController.m
//  HelloNSJSONSerialization
//
//  Created by wesley_chen on 2018/4/18.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "AccessThemeConfigurationViewController.h"
#import "WCThemeTool.h"

@interface AccessThemeConfigurationViewController ()

@end

@implementation AccessThemeConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    double height = [[WCThemeTool defaultInstance] frameHeightForKey:@"MyAlertView" defaultHeight:10];
    NSLog(@"height: %f", height);
}

@end
