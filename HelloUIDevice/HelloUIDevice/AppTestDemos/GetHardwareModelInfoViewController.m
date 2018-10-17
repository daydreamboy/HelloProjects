//
//  GetHardwareModelInfoViewController.m
//  HelloUIDevice
//
//  Created by wesley_chen on 2018/10/17.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "GetHardwareModelInfoViewController.h"

#import "WCDeviceTool.h"

#define kTitle      @"title"
#define kSubtitle   @"subtitle"

@interface GetHardwareModelInfoViewController ()
@property (nonatomic, strong) NSArray<NSDictionary *> *listData;
@end

@implementation GetHardwareModelInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listData = @[
                      @{ kTitle: [WCDeviceTool deviceName], kSubtitle: @"device name" },
                      @{ kTitle: [WCDeviceTool deviceModel], kSubtitle: @"device model" },
                      @{ kTitle: [WCDeviceTool deviceLocalizedModel], kSubtitle: @"device localized model" },
                      @{ kTitle: [WCDeviceTool deviceDetailedModel], kSubtitle: @"device detailed model" },
                      @{ kTitle: [WCDeviceTool deviceModelPrettyPrinted:NO], kSubtitle: @"device model not pretty printed" },
                      @{ kTitle: [WCDeviceTool deviceModelPrettyPrinted:YES], kSubtitle: @"device model pretty printed" },
                      ];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"RootViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSDictionary *dict = self.listData[indexPath.row];
    cell.textLabel.text = dict[kTitle];
    cell.detailTextLabel.text = dict[kSubtitle];
    
    return cell;
}

@end
