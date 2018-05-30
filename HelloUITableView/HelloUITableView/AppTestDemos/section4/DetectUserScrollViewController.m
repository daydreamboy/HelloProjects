//
//  DetectUserScrollViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2018/5/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DetectUserScrollViewController.h"

@interface DetectUserScrollViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, strong) UIView *hudTip;
@end

@implementation DetectUserScrollViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        [groups addObject:[NSArray arrayWithObjects:@"G1-R1", @"G1-R2", @"G1-R3", @"G1-R4", nil]];
        [groups addObject:[NSArray arrayWithObjects:@"G2-R1", @"G2-R2", @"G2-R3", nil]];
        
        _listData = groups;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    CGFloat side = 200;
    _hudTip = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - side) / 2.0, (screenSize.height - side) / 2.0, side, side)];
    _hudTip.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    _hudTip.userInteractionEnabled = NO;
    _hudTip.hidden = YES;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numItemsInSection = [[self.listData objectAtIndex:section] count];
    return numItemsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    cell.textLabel.text = [[self.listData objectAtIndex:section] objectAtIndex:row];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"User begin dragging");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"User end dragging and is decelerate: %@", decelerate ? @"YES" : @"NO");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"ScrollView begin decelerating");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"ScrollView end decelerating");
}

@end
