//
//  GetSystemMemoryInfoViewController.m
//  HelloUIDevice
//
//  Created by wesley_chen on 2018/10/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "GetSystemMemoryInfoViewController.h"
#import "WCDeviceTool.h"

@interface GetSystemMemoryInfoViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) NSTimer *timerQuery;
@property (nonatomic, strong) NSTimer *timerAutoMalloc;
@property (nonatomic, strong) UIButton *button;
@end

@implementation GetSystemMemoryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
    
    self.timerQuery = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(queryMemory:) userInfo:nil repeats:YES];
}

- (void)dealloc {
    [_timerQuery invalidate];
    _timerQuery = nil;
    
    [_timerAutoMalloc invalidate];
    _timerAutoMalloc = nil;
}

- (void)didReceiveMemoryWarning {
    NSLog(@"%@: didReceiveMemoryWarning", self);
}

- (void)setup {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    NSMutableArray *labels = [NSMutableArray array];
    NSArray *titles = @[
                        @"System avaiable Mem.",
                        @"Process resident Mem.",
                        @"Process Mem. footprint",
                        ];
    
    CGFloat startY = 100;
    CGFloat paddingV = 10;
    for (NSString *title in titles) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, startY, screenSize.width, 30)];
        label.textColor = [UIColor blueColor];
        label.font = [UIFont systemFontOfSize:18];
        label.text = title;
        
        [labels addObject:label];
        [self.view addSubview:label];
        
        startY += (CGRectGetHeight(label.bounds) + paddingV);
    }
    
    UIButton *autoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    autoButton.frame = CGRectMake(0, startY, screenSize.width, 30);
    [autoButton setTitle:@"auto malloc 10 MB per 2s" forState:UIControlStateNormal];
    [autoButton addTarget:self action:@selector(autoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:autoButton];
    
    startY += (CGRectGetHeight(autoButton.bounds) + paddingV);
    
    UIButton *manualButton = [UIButton buttonWithType:UIButtonTypeSystem];
    manualButton.frame = CGRectMake(0, startY, screenSize.width, 30);
    [manualButton setTitle:@"malloc 10 MB manually" forState:UIControlStateNormal];
    [manualButton addTarget:self action:@selector(manualButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:manualButton];
    
    self.labels = labels;
    self.titles = titles;
}

#pragma mark - NSTimer

- (void)queryMemory:(NSTimer *)timer {
    double available = [WCDeviceTool systemAvailableMemory];
    double resident = [WCDeviceTool processMemoryResident];
    double footprint = [WCDeviceTool processMemoryFootprint];
    
    NSLog(@"resident: %f, footprint: %f", resident, footprint);
    
    ((UILabel *)self.labels[0]).text = [NSString stringWithFormat:@"%@: %f", self.titles[0], available];
    ((UILabel *)self.labels[1]).text = [NSString stringWithFormat:@"%@: %f", self.titles[1], resident];
    ((UILabel *)self.labels[2]).text = [NSString stringWithFormat:@"%@: %f", self.titles[2], footprint];
}

- (void)autoMalloc:(NSTimer *)timer {
    [self manualButtonClicked:nil];
}

#pragma mark - Actions

- (void)autoButtonClicked:(id)sender {
    self.timerAutoMalloc = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoMalloc:) userInfo:nil repeats:YES];
}

- (void)manualButtonClicked:(id)sender {
    NSLog(@"malloc 10 MB memory");
    
    static int *bytes = NULL;
    
    bytes = (int *)malloc(10 * 1024 * 1024);
    int size = 10 * 1024 * 1024 / 4;
    for (int i = 0 ; i < size; i++) {
        bytes[i] = 3;
    }
}

@end
