//
//  GetCommonISOCurrencyCodesViewController.m
//  HelloNSLocale
//
//  Created by wesley_chen on 2020/9/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "GetCommonISOCurrencyCodesViewController.h"
#import "WCArrayTool.h"

@interface GetCommonISOCurrencyCodesViewController ()

@end

@implementation GetCommonISOCurrencyCodesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listData = [WCArrayTool sortedGroupsByPrefixCharWithStrings:[NSLocale commonISOCurrencyCodes]];
}

@end
