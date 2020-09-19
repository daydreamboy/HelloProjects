//
//  GetAllISOCountryCodesViewController.m
//  HelloNSLocale
//
//  Created by wesley_chen on 2020/9/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "GetAllISOCountryCodesViewController.h"
#import "WCArrayTool.h"

@interface GetAllISOCountryCodesViewController ()

@end

@implementation GetAllISOCountryCodesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listData = [WCArrayTool sortedGroupsByPrefixCharWithStrings:[NSLocale ISOCountryCodes]];
}

@end
