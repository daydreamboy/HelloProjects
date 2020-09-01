//
//  GetSystemInfoViewController.m
//  HelloUIDevice
//
//  Created by wesley_chen on 2018/10/17.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "GetSystemInfoViewController.h"

#import "WCDeviceTool.h"

#define kTitle      @"title"
#define kSubtitle   @"subtitle"

@interface GetSystemInfoViewController ()
@property (nonatomic, strong) NSArray<NSDictionary *> *listData;
@property (nonatomic, strong) NSArray<NSArray *> *sectionListData;
@property (nonatomic, strong) NSArray<NSString *> *sectionTitles;
@end

@implementation GetSystemInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sectionTitles = @[
        @"System",
        @"Localization",
    ];
    
    _sectionListData = @[
        @[
            @{ kTitle: [WCDeviceTool systemName], kSubtitle: @"system name" },
            @{ kTitle: [WCDeviceTool systemVersion], kSubtitle: @"system version" },
            @{ kTitle: [WCDeviceTool systemLanguage], kSubtitle: @"system language" },
            @{ kTitle: [WCDeviceTool systemLanguageCode], kSubtitle: @"system language code" },
            @{ kTitle: [WCDeviceTool systemUptime], kSubtitle: @"system up time" },
        ],
        @[
            @{ kTitle: [WCDeviceTool localizationCountry], kSubtitle: @"Country" },
            @{ kTitle: [WCDeviceTool localizationLanguage], kSubtitle: @"Language" },
            @{ kTitle: [WCDeviceTool localizationTimeZone], kSubtitle: @"TimeZone" },
            @{ kTitle: [WCDeviceTool localizationCurrency], kSubtitle: @"Currency" },
        ],
    ];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionListData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionListData[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"RootViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSDictionary *dict = self.sectionListData[indexPath.section][indexPath.row];
    cell.textLabel.text = dict[kTitle];
    cell.detailTextLabel.text = dict[kSubtitle];
    
    return cell;
}

@end
