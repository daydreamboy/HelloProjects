//
//  DisableCallScrollViewDidScrollAutomaticallyViewController.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2019/12/7.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "DisableCallScrollViewDidScrollAutomaticallyViewController.h"

@interface DisableCallScrollViewDidScrollAutomaticallyViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, strong) UILabel *hudTip;
@property (nonatomic, strong) UISwitch *switcher;
@property (nonatomic, assign) BOOL disableAutoCallScrollViewDidScroll;
@end

@implementation DisableCallScrollViewDidScrollAutomaticallyViewController

- (instancetype)initWithOptions:(NSDictionary *)options {
    self = [super init];
    if (self) {
        _options = options;
        _disableAutoCallScrollViewDidScroll = [options[kOptionDisableAutoCallScrollViewDidScroll] boolValue];
        
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        [groups addObject:[NSArray arrayWithObjects:@"G1-R1", @"G1-R2", @"G1-R3", @"G1-R4", nil]];
        [groups addObject:[NSArray arrayWithObjects:@"G2-R1", @"G2-R2", @"G2-R3", nil]];
        [groups addObject:[NSArray arrayWithObjects:@"G2-R1", @"G2-R2", @"G2-R3", nil]];
        [groups addObject:[NSArray arrayWithObjects:@"G2-R1", @"G2-R2", @"G2-R3", nil]];
        [groups addObject:[NSArray arrayWithObjects:@"G2-R1", @"G2-R2", @"G2-R3", nil]];
        [groups addObject:[NSArray arrayWithObjects:@"G2-R1", @"G2-R2", @"G2-R3", nil]];
        [groups addObject:[NSArray arrayWithObjects:@"G2-R1", @"G2-R2", @"G2-R3", nil]];
        
        _listData = groups;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.hudTip];
    
    UIBarButtonItem *itemAnimated = [[UIBarButtonItem alloc] initWithCustomView:self.switcher];
    
    UIBarButtonItem *itemScrollToBottom = [[UIBarButtonItem alloc] initWithTitle:@"UIScrollView底部" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToBottomClicked:)];

    UIBarButtonItem *itemScrollToTop = [[UIBarButtonItem alloc] initWithTitle:@"UIScrollView顶部" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToTopClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[itemAnimated, itemScrollToBottom, itemScrollToTop];
    
    for (UIBarItem *barItem in self.navigationItem.rightBarButtonItems) {
        [barItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
        [barItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]} forState:UIControlStateHighlighted];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.disableAutoCallScrollViewDidScroll) {
        self.tableView.delegate = self;
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) style:UITableViewStylePlain];
        if (!self.disableAutoCallScrollViewDidScroll) {
            tableView.delegate = self;
        }
        tableView.dataSource = self;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (UILabel *)hudTip {
    if (!_hudTip) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        label.userInteractionEnabled = NO;
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
        label.alpha = 0;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:25];
        
        _hudTip = label;
    }
    
    return _hudTip;
}

- (UISwitch *)switcher {
    if (!_switcher) {
        UISwitch *switcher = [UISwitch new];
        switcher.on = YES;
        [switcher addTarget:self action:@selector(switcherToggled:) forControlEvents:UIControlEventValueChanged];
        _switcher = switcher;
    }
    
    return _switcher;
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
    NSLog(@"ScrollView begin decelerating: %f", scrollView.contentOffset.y);
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.hudTip.alpha = 1;
    self.hudTip.text = @"begin decelerating by user";
    [self.hudTip sizeToFit];
    self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"ScrollView end decelerating");
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.hudTip.alpha = 1;
    self.hudTip.text = @"end decelerating by user";
    [self.hudTip sizeToFit];
    self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    [UIView animateWithDuration:1.5 animations:^{
        self.hudTip.alpha = 0;
    }];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"ScrollView end scrolling by animation");
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.hudTip.alpha = 1;
    self.hudTip.text = @"end scrolling by animation";
    [self.hudTip sizeToFit];
    self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    [UIView animateWithDuration:1.5 animations:^{
        self.hudTip.alpha = 0;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll: %f", scrollView.contentOffset.y);
    
    // @see https://stackoverflow.com/a/1857162
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    // Note: ensure that the end of scroll is fired.
    [self performSelector:@selector(scrollViewDidEndScrolling:) withObject:scrollView afterDelay:0.3];
}

#pragma mark -

- (void)scrollViewDidEndScrolling:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollViewDidEndScrollingAnimation:) object:scrollView];
    
    NSLog(@"ScrollView end scrolling");
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.hudTip.alpha = 1;
    self.hudTip.text = @"end scrolling";
    [self.hudTip sizeToFit];
    self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    [UIView animateWithDuration:1.5 animations:^{
        self.hudTip.alpha = 0;
    }];
}

#pragma mark - Action

- (void)itemScrollToBottomClicked:(id)sender {
    CGPoint bottomOffset = CGPointMake(0, _tableView.contentSize.height - _tableView.bounds.size.height + _tableView.contentInset.bottom);
    [_tableView setContentOffset:bottomOffset animated:self.switcher.on];
}

- (void)itemScrollToTopClicked:(id)sender {
    CGPoint topOffset = CGPointMake(0, -_tableView.adjustedContentInset.top);
    [_tableView setContentOffset:topOffset animated:self.switcher.on];
}

- (void)switcherToggled:(id)sender {
    UISwitch *switcher = (UISwitch *)sender;
    switcher.on = !switcher.on;
}


@end
