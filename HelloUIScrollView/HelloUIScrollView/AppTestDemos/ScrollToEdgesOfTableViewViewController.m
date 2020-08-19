//
//  ScrollToEdgesOfTableViewViewController.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ScrollToEdgesOfTableViewViewController.h"
#import "WCMacroTool.h"
#import "WCViewTool.h"
#import "WCScrollViewTool.h"

@interface ScrollToEdgesOfTableViewViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) UIView *toolbarView;
@property (nonatomic, assign) BOOL scrollAnimated;
@end

@implementation ScrollToEdgesOfTableViewViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _listData = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 20; ++i) {
            [_listData addObject:[NSString stringWithFormat:@"%ld", (long)i]];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Configure: toggle animate and set content height
    self.scrollAnimated = YES;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolbarView];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGRect frame = self.view.bounds;
        frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.layer.borderColor = [UIColor redColor].CGColor;
        tableView.layer.borderWidth = 1.0;
        
        tableView.contentInset = UIEdgeInsetsMake(30, 0, 30, 0);
        
        if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#pragma GCC diagnostic pop
        }
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 50)];
        header.backgroundColor = [UIColor greenColor];
        tableView.tableHeaderView = header;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 50)];
        footer.backgroundColor = [UIColor blueColor];
        tableView.tableFooterView = footer;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (UIView *)toolbarView {
    if (!_toolbarView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        // row 1
        UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(itemBackClicked:)];
        
        // row 2
        UIBarButtonItem *itemScrollToTop = [[UIBarButtonItem alloc] initWithTitle:@"TableView⬆️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToTopClicked:)];
        
        UIBarButtonItem *itemScrollToLeft = [[UIBarButtonItem alloc] initWithTitle:@"TableView⬅️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToLeftClicked:)];
        
        UIBarButtonItem *itemScrollToBottom = [[UIBarButtonItem alloc] initWithTitle:@"TableView⬇️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToBottomClicked:)];

        UIBarButtonItem *itemScrollToRight = [[UIBarButtonItem alloc] initWithTitle:@"TableView➡️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToRightClicked:)];
        
        // row 3
        UIBarButtonItem *itemScrollToTopOfContent = [[UIBarButtonItem alloc] initWithTitle:@"Content⬆️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToTopOfContentClicked:)];

        UIBarButtonItem *itemScrollToLeftOfContent = [[UIBarButtonItem alloc] initWithTitle:@"Content⬅️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToLeftOfContentClicked:)];

        UIBarButtonItem *itemScrollToBottomOfContent = [[UIBarButtonItem alloc] initWithTitle:@"Content⬇️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToBottomOfContentClicked:)];

        UIBarButtonItem *itemScrollToRightOfContent = [[UIBarButtonItem alloc] initWithTitle:@"Content➡️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToRightOfContentClicked:)];
        
        // row 4
        UIBarButtonItem *itemScrollToTopOfList = [[UIBarButtonItem alloc] initWithTitle:@"List⬆️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToTopOfListClicked:)];
        
        UIBarButtonItem *itemScrollToLeftOfList = [[UIBarButtonItem alloc] initWithTitle:@"List⬅️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToLeftOfListClicked:)];
        
        UIBarButtonItem *itemScrollToBottomOfList = [[UIBarButtonItem alloc] initWithTitle:@"List⬇️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToBottomOfListClicked:)];
        
        UIBarButtonItem *itemScrollToRightOfList = [[UIBarButtonItem alloc] initWithTitle:@"List➡️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToRightOfListClicked:)];
        
        NSArray *items1 = @[itemBack];
        
        NSArray *items2 = @[
                           itemScrollToTop,
                           itemScrollToLeft,
                           itemScrollToBottom,
                           itemScrollToRight
                        ];
        
        NSArray *items3 = @[
                           itemScrollToTopOfContent,
                           itemScrollToLeftOfContent,
                           itemScrollToBottomOfContent,
                           itemScrollToRightOfContent
                        ];
        
        NSArray *items4 = @[
                           itemScrollToTopOfList,
                           itemScrollToLeftOfList,
                           itemScrollToBottomOfList,
                           itemScrollToRightOfList
                        ];
        
        NSMutableArray *allItems = [NSMutableArray array];
        [allItems addObject:items1];
        [allItems addObject:items2];
        [allItems addObject:items3];
        [allItems addObject:items4];
        
        // @see https://stackoverflow.com/a/17091443
        for (UIBarItem *barItem in [allItems valueForKeyPath:@"@unionOfArrays.self"]) {
            [barItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
            [barItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} forState:UIControlStateHighlighted];
        }
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
        
        CGFloat startY = 0;
        for (NSInteger i = 0; i < allItems.count; i++) {
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, startY, 440, 44)];
            [toolbar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
            [toolbar setItems:allItems[i] animated:NO];
            // Note: not work as expect to fit all items, only fit to screen.width and 44
            //[toolbar sizeToFit];
            
            startY = CGRectGetMaxY(toolbar.frame);
            
            [containerView addSubview:toolbar];
        }
        
        [WCViewTool makeViewFrameToFitAllSubviewsWithSuperView:containerView];
        
        containerView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanned:)];
        [containerView addGestureRecognizer:panGesture];
        
        _toolbarView = containerView;
    }
    
    return _toolbarView;
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"LoadMoreViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    cell.textLabel.text = self.listData[indexPath.row];
    
    return cell;
}

#pragma mark - Actions

- (void)itemBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Scroll to edges of ScrollView

- (void)itemScrollToBottomClicked:(id)sender {
    [WCScrollViewTool scrollToBottomWithScrollView:self.tableView animated:self.scrollAnimated];
}

- (void)itemScrollToTopClicked:(id)sender {
    [WCScrollViewTool scrollToTopWithScrollView:self.tableView animated:self.scrollAnimated];
}

- (void)itemScrollToLeftClicked:(id)sender {
    [WCScrollViewTool scrollToLeftWithScrollView:self.tableView animated:self.scrollAnimated];
}

- (void)itemScrollToRightClicked:(id)sender {
    [WCScrollViewTool scrollToRightWithScrollView:self.tableView animated:self.scrollAnimated];
}

#pragma mark - Scroll to edges of Content

- (void)itemScrollToBottomOfContentClicked:(id)sender {
    [WCScrollViewTool scrollToBottomOfContentWithScrollView:self.tableView animated:self.scrollAnimated considerSafeArea:YES];
}

- (void)itemScrollToTopOfContentClicked:(id)sender {
    [WCScrollViewTool scrollToTopOfContentWithScrollView:self.tableView animated:self.scrollAnimated considerSafeArea:YES];
}

- (void)itemScrollToLeftOfContentClicked:(id)sender {
    [WCScrollViewTool scrollToLeftOfContentWithScrollView:self.tableView animated:self.scrollAnimated considerSafeArea:YES];
}

- (void)itemScrollToRightOfContentClicked:(id)sender {
    [WCScrollViewTool scrollToRightOfContentWithScrollView:self.tableView animated:self.scrollAnimated considerSafeArea:YES];
}

#pragma mark - Scroll to edges of List

- (void)itemScrollToBottomOfListClicked:(id)sender {
    [WCScrollViewTool scrollToBottomOfListWithTableView:self.tableView animated:self.scrollAnimated considerSafeArea:YES];
}

- (void)itemScrollToTopOfListClicked:(id)sender {
    [WCScrollViewTool scrollToTopOfListWithTableView:self.tableView animated:self.scrollAnimated considerSafeArea:YES];
}

- (void)itemScrollToLeftOfListClicked:(id)sender {
    [WCScrollViewTool scrollToLeftOfListWithTableView:self.tableView animated:self.scrollAnimated considerSafeArea:YES];
}

- (void)itemScrollToRightOfListClicked:(id)sender {
    [WCScrollViewTool scrollToRightOfListWithTableView:self.tableView animated:self.scrollAnimated considerSafeArea:YES];
}

#pragma mark -

- (void)viewPanned:(UIPanGestureRecognizer *)recognizer {
    // @see https://stackoverflow.com/questions/25503537/swift-uigesturerecogniser-follow-finger
    UIView *targetView = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self.view];
        targetView.center = CGPointMake(targetView.center.x + translation.x, targetView.center.y + translation.y);
        // Note: reset translation when every UIGestureRecognizerStateChanged detected, so translation is always calculated based on CGPointZero
        [recognizer setTranslation:CGPointZero inView:self.view];
    }
}

@end
