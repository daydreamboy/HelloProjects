//
//  GetHardwareProcessorInfoViewController.m
//  HelloUIDevice
//
//  Created by wesley_chen on 2018/10/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "GetHardwareProcessorInfoViewController.h"
#import "WCDeviceTool.h"

#define kTitle      @"title"
#define kSubtitle   @"subtitle"

@interface GetHardwareProcessorInfoViewController ()
@property (nonatomic, strong) NSArray<NSDictionary *> *listData;
@end

@implementation GetHardwareProcessorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listData = @[
                      @{ kTitle: [@([WCDeviceTool deviceProcessorNumber]) stringValue], kSubtitle: @"number of processor" },
                      @{ kTitle: [@([WCDeviceTool deviceProcessorActiveNumber]) stringValue], kSubtitle: @"number of active processor" },
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
