//
//  DebugBaseViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2020/5/1.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "DebugBaseViewController.h"
#import "YYTextExampleHelper.h"

@interface DebugBaseViewController ()

@end

@implementation DebugBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [YYTextExampleHelper addDebugOptionToViewController:self];
}

@end
