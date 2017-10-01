//
//  CreateTimerDispatchSourceViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/12/21.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "CreateTimerDispatchSourceViewController.h"

@interface CreateTimerDispatchSourceViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *buttonToggleTimer;
@property (nonatomic, strong) NSArray *listData;
@end

@implementation CreateTimerDispatchSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Start Timer" forState:UIControlStateNormal];
    [button setTitle:@"Stop Timer" forState:UIControlStateSelected];
    [button sizeToFit];
    [button addTarget:self action:@selector(buttonToggleTimerClicked:) forControlEvents:UIControlEventTouchUpInside];
    CGRect frame = button.frame;
    frame.origin.y = 64 + 10;
    button.frame = frame;
    _buttonToggleTimer = button;
    [self.view addSubview:_buttonToggleTimer];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((screenSize.width - 100) / 2.0, 64 + 20, 100, 40)];
    label.text = @"0";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor blackColor];
    _label = label;
    [self.view addSubview:_label];
    
    CGFloat startY = CGRectGetMaxY(label.frame) + 10;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startY, screenSize.width, screenSize.height - startY) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:tableView];
 
    _listData = @[@"1", @"2", @"3", @"4", @"5", @"6"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopTimer];
}

#pragma mark - Actions

- (void)buttonToggleTimerClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    [button sizeToFit];
    if (button.selected) {
        [self startTimer];
    }
    else {
        [self stopTimer];
    }
}

#pragma mark

- (void)startTimer {
    static int count = 0;
    dispatch_source_t timer = CreateDispatchTimer(1ull * NSEC_PER_SEC, 0, dispatch_get_main_queue(), ^{
        NSLog(@"triggered at %ld time", (long)(++count));
        _label.text = [NSString stringWithFormat:@"%d", arc4random() % 100];
    });
    _timer = timer;
}

// @see https://gist.github.com/maicki/7622108
- (void)stopTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

// create a timer and start it immediately
dispatch_source_t CreateDispatchTimer(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer) {
        // also use wall time
        // dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        dispatch_source_set_cancel_handler(timer, ^{
            NSLog(@"timer is cancelled"); // not called when dealloc
        });
        dispatch_resume(timer);
    }
    return timer;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"CreateTimerDispatchSourceViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    cell.textLabel.text = _listData[indexPath.row];
    
    return cell;
}

@end
