//
//  CheckCharactersInNSCharacterSetViewController.m
//  HelloNSCharacterSet
//
//  Created by wesley_chen on 2018/7/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CheckCharactersInNSCharacterSetViewController.h"
#import "WCCharacterSetTool.h"

@interface CheckCharactersInNSCharacterSetViewController ()

@end

@implementation CheckCharactersInNSCharacterSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *array = [WCCharacterSetTool charactersInCharacterSet:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *string = [array componentsJoinedByString:@""];
    NSLog(@"%@", string);
}

@end
