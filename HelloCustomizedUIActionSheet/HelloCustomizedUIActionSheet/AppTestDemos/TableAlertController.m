//
//  TableAlertController.m
//  HelloCustomizedUIActionSheet
//
//  Created by wesley_chen on 15/07/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "TableAlertController.h"

// @see https://stackoverflow.com/questions/37428337/customised-uiactionsheet/37428360#37428360
@interface TableAlertController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableViewController *tableViewController;
@end

@implementation TableAlertController

- (instancetype)init {
    self = [super init];
    if (self) {
        _tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        [_tableViewController.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableAlertController_sCellIdentifier"];
        _tableViewController.tableView.delegate = self;
        _tableViewController.tableView.dataSource = self;
        [_tableViewController.tableView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
        // Warning: maybe use private API
        [self setValue:_tableViewController forKey:@"contentViewController"];
    }
    return self;
}

- (void)dealloc {
    [_tableViewController.tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        _tableViewController.preferredContentSize = _tableViewController.tableView.contentSize;
    }
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"TableAlertController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"Upcoming activities";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:YES animated:NO];
            break;
        }
        case 1: {
            cell.textLabel.text = @"Past activities";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:NO animated:NO];
            break;
        }
        case 2: {
            cell.textLabel.text = @"Activities where I am admin";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:YES animated:NO];
            break;
        }
        case 3: {
            cell.textLabel.text = @"Attending";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:YES animated:NO];
            break;
        }
        case 4: {
            cell.textLabel.text = @"Declined";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:YES animated:NO];
            break;
        }
        case 5: {
            cell.textLabel.text = @"Not responded";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:YES animated:NO];
            break;
        }
        default: {
            NSAssert(NO, @"Should never hit here");
            break;
        }
    }
    
    return cell;
}

@end
