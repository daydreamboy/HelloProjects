//
//  CheckScrollingViewController.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2019/9/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CheckScrollingViewController.h"

@interface CheckScrollingViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, strong) UILabel *hudTip;
@end

@implementation CheckScrollingViewController


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
    
    _hudTip = [[UILabel alloc] initWithFrame:CGRectZero];
    _hudTip.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    _hudTip.userInteractionEnabled = NO;
    _hudTip.layer.cornerRadius = 3;
    _hudTip.layer.masksToBounds = YES;
    _hudTip.alpha = 0;
    _hudTip.textColor = [UIColor whiteColor];
    _hudTip.font = [UIFont boldSystemFontOfSize:25];
    
    [self.view addSubview:_hudTip];
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
    
    NSLog(@"scrollViewWillBeginDecelerating: %f", scrollView.contentOffset.y);
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.hudTip.alpha = 1;
    self.hudTip.text = @"User begin dragging";
    [self.hudTip sizeToFit];
    self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"User end dragging and is decelerate: %@", decelerate ? @"YES" : @"NO");
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.hudTip.alpha = 1;
    self.hudTip.text = @"User end dragging";
    [self.hudTip sizeToFit];
    self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    [UIView animateWithDuration:1.5 animations:^{
        self.hudTip.alpha = 0;
    }];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"ScrollView begin decelerating");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"ScrollView end decelerating");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll: %f", scrollView.contentOffset.y);
}

@end
