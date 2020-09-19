//
//  GetAllISOLanguageCodesViewController.m
//  HelloNSLocale
//
//  Created by wesley_chen on 2020/9/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "GetAllISOLanguageCodesViewController.h"
#import "WCArrayTool.h"

@interface GetAllISOLanguageCodesViewController ()

@end

@implementation GetAllISOLanguageCodesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listData = [WCArrayTool sortedGroupsByPrefixCharWithStrings:[NSLocale ISOLanguageCodes]];
}

@end
