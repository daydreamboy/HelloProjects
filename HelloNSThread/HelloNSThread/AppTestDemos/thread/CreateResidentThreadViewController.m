//
//  CreateResidentThreadViewController.m
//  HelloNSThread
//
//  Created by wesley_chen on 2019/10/2.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CreateResidentThreadViewController.h"
#import "WCThreadTool.h"

@interface CreateResidentThreadViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSThread *residentThread;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *listData;
@end

@implementation CreateResidentThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.residentThread = [WCThreadTool createResidentThreadWithName:@"ResidentThread" startImmediately:YES];
    
    [self setup];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    __weak typeof(self) weak_self = self;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong typeof(weak_self) strong_self = weak_self;
        
        NSDate *date = [NSDate date];
        
        //[strong_self performSelector:@selector(executeInAnotherThread:) onThread:strong_self.residentThread withObject:date waitUntilDone:NO];
        [strong_self performSelector:@selector(executeInAnotherThread:) onThread:strong_self.residentThread withObject:date waitUntilDone:NO];
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    NSLog(@"timer started");
}

- (void)dealloc {
    [WCThreadTool stopResidentThread:self.residentThread];
}

#pragma mark -

- (void)executeInAnotherThread:(id)parameter {
    NSLog(@"%@", parameter);
}

#pragma mark -

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

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _tableView = tableView;
    }
    
    return _tableView;
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
