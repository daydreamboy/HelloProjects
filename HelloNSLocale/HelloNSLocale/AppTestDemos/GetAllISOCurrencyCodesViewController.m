//
//  GetAllISOCurrencyCodesViewController.m
//  HelloNSLocale
//
//  Created by wesley_chen on 2020/9/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "GetAllISOCurrencyCodesViewController.h"
#import "WCArrayTool.h"

@interface GetAllISOCurrencyCodesViewController ()

@end

@implementation GetAllISOCurrencyCodesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listData = [WCArrayTool sortedGroupsByPrefixCharWithStrings:[NSLocale ISOCurrencyCodes]];
}

@end
