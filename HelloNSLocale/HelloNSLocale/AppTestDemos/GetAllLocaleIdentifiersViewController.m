//
//  GetAllLocaleIdentifiersViewController.m
//  HelloNSLocale
//
//  Created by wesley_chen on 2020/9/10.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "GetAllLocaleIdentifiersViewController.h"
#import "WCArrayTool.h"

@interface GetAllLocaleIdentifiersViewController ()
@end

@implementation GetAllLocaleIdentifiersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listData = [WCArrayTool sortedGroupsByPrefixCharWithStrings:[NSLocale availableLocaleIdentifiers]];
}

@end
