//
//  GetAllClassNamesOfMainBundleViewController.m
//  HelloNSBundle
//
//  Created by wesley_chen on 17/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "GetAllClassNamesOfMainBundleViewController.h"
#import "WCBundleTool.h"

@interface GetAllClassNamesOfMainBundleViewController ()
@property (nonatomic, strong) NSArray *titles;
@end

@implementation GetAllClassNamesOfMainBundleViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [self prepareForInit];
    }
    
    return self;
}

- (void)prepareForInit {
    self.title = @"AppTest";
    
    _titles = [WCBundleTool classNamesWithMainBundleImage];
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"GetAllClassNamesOfMainBundleViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    cell.textLabel.text = _titles[indexPath.row];
    
    return cell;
}

@end
