//
//  PlainTableViewWithNonFloatSectionViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 19/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "PlainTableViewWithNonFloatSectionViewController.h"

@interface DummyTableHeaderView : UIView
@end
@implementation DummyTableHeaderView
@end

@interface NonFloatSectionPlainTableView : UITableView
@end

@interface NonFloatSectionPlainTableView ()
@property (nonatomic, strong) UIView *tableViewHeaderView;
@property (nonatomic, strong) DummyTableHeaderView *dummyTableHeaderView;
@property (nonatomic, strong) UIView *tableHeaderWrappingView;
@end

@implementation NonFloatSectionPlainTableView

#pragma mark - Public Methods

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (style == UITableViewStyleGrouped) {
        return [super initWithFrame:frame style:style];
    }
    else {
        self = [super initWithFrame:frame style:UITableViewStylePlain];
        
        if (self) {
            CGFloat dummyViewHeight = 40;
            _dummyTableHeaderView = [[DummyTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, dummyViewHeight)];
            _dummyTableHeaderView.backgroundColor = [UIColor clearColor];
#if DEBUG_UI
            _dummyTableHeaderView.backgroundColor = [UIColor yellowColor];
#endif
            self.tableHeaderView = _dummyTableHeaderView;
        }
    }
    
    return self;
}

- (void)setTableHeaderView:(UIView *)tableHeaderView {
    
    if (![tableHeaderView isKindOfClass:[DummyTableHeaderView class]]) {
        _tableViewHeaderView = tableHeaderView;
    }
    
    // http://stackoverflow.com/questions/1074006/is-it-possible-to-disable-floating-headers-in-uitableview-with-uitableviewstylep
    
    CGFloat headerViewHeight = CGRectGetHeight(tableHeaderView.bounds);
    UIEdgeInsets insets = self.contentInset;
    
    if ([tableHeaderView isKindOfClass:[DummyTableHeaderView class]]) {
        [super setTableHeaderView:tableHeaderView];
        
        self.contentInset = UIEdgeInsetsMake(-headerViewHeight, insets.left, insets.bottom, insets.right);
    }
    else {
        CGFloat dummyHeight = CGRectGetHeight(_dummyTableHeaderView.bounds);
        CGFloat totalHeight = headerViewHeight + dummyHeight;
        
        CGRect newFrame = tableHeaderView.frame;
        newFrame.origin.y += CGRectGetHeight(_dummyTableHeaderView.bounds);
        tableHeaderView.frame = newFrame;
        
        _tableHeaderWrappingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, totalHeight)];
        [_tableHeaderWrappingView addSubview:_dummyTableHeaderView];
        [_tableHeaderWrappingView addSubview:tableHeaderView];
        
        [super setTableHeaderView:_tableHeaderWrappingView];
        self.contentInset = UIEdgeInsetsMake(-dummyHeight, insets.left, insets.bottom, insets.right);
    }
}

@end

@interface PlainTableViewWithNonFloatSectionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableViewWithoutTableHeader;
@property (nonatomic, strong) UITableView *tableViewWithTableHeader;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *listData;
@end

@implementation PlainTableViewWithNonFloatSectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Non-TableHeader", @"With Table Header"]];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(segmentedControlIndexSelected:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableViewWithoutTableHeader];
    [self.view addSubview:self.tableViewWithTableHeader];
    
    [self segmentedControlIndexSelected:segmentedControl];
}

- (void)setup {
    NSArray *arr = @[
                     @[
                         @"viewDidLoad",
                         @"UITableView",
                         @"UITableView2",
                         @"screenSize",
                         @"UITableViewCell",
                         ],
                     @[
                         @"UIScreen",
                         @"backgroundColor",
                         @"view",
                         @"self",
                         @"whiteColor",
                         @"UIColor",
                         @"initWithFrame",
                         ],
                     @[
                         @"UITableViewStylePlain",
                         @"delegate",
                         @"dataSource",
                         @"UITableViewDelegate",
                         @"UITableViewDataSource",
                         @"FadeInCellRowByRowViewController",
                         @"listData",
                         ],
                     ];
    self.listData = arr;
}

- (void)viewDidAppear:(BOOL)animated {
    // Note: 
    NSLog(@"non-float tableView's contentInset: %@", NSStringFromUIEdgeInsets(self.tableViewWithoutTableHeader.contentInset));
}

#pragma mark - Actions

- (void)segmentedControlIndexSelected:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.tableViewWithoutTableHeader.hidden = NO;
        self.tableViewWithTableHeader.hidden = YES;
    }
    else if (segmentedControl.selectedSegmentIndex == 1) {
        self.tableViewWithoutTableHeader.hidden = YES;
        self.tableViewWithTableHeader.hidden = NO;
    }
}

#pragma mark - Getters

- (UITableView *)tableViewWithoutTableHeader {
    if (!_tableViewWithoutTableHeader) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        NonFloatSectionPlainTableView *tableView = [[NonFloatSectionPlainTableView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _tableViewWithoutTableHeader = tableView;
    }
    
    return _tableViewWithoutTableHeader;
}

- (UITableView *)tableViewWithTableHeader {
    if (!_tableViewWithTableHeader) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        NonFloatSectionPlainTableView *tableView = [[NonFloatSectionPlainTableView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        CGFloat tableHeaderViewHeight = 40;
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableHeaderViewHeight)];
        tableHeaderView.backgroundColor = [UIColor yellowColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
        label.text = @"This is table view header";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        label.layer.borderColor = [UIColor grayColor].CGColor;
        label.layer.borderWidth = 1;
        label.layer.cornerRadius = 4;
        [tableHeaderView addSubview:label];
        
        tableView.tableHeaderView = tableHeaderView;
        
        _tableViewWithTableHeader = tableView;
    }
    
    return _tableViewWithTableHeader;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"FadeInCellRowByRowViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    cell.textLabel.text = self.listData[indexPath.section][indexPath.row];
    
    return cell;
}

@end
