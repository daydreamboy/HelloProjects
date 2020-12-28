//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "ExecuteMethodsSeriallyViewController.h"

//#if DEBUG
#define WCLog(...) NSLog(__VA_ARGS__)
//#else
//#define WCLog(...)
//#endif

@interface ExecuteMethodsSeriallyViewController ()

@end

@implementation ExecuteMethodsSeriallyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Click" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - Action

- (void)rightItemClicked:(id)sender {
    [self doLongTimeWork];
    [self doShortTimeWork];
}

- (void)doLongTimeWork {
    WCLog(@"doLongTimeWork start: %f", [[NSDate date] timeIntervalSince1970]);
    //[NSThread sleepForTimeInterval:3];
    
    // 4s
    for (NSUInteger i = 0; i < 20000; i++) {
        NSLog(@"%lu", (unsigned long)i);
    }
    
    WCLog(@"doLongTimeWork   end: %f", [[NSDate date] timeIntervalSince1970]);
}

- (void)doShortTimeWork {
    WCLog(@"doShortTimeWork start: %f", [[NSDate date] timeIntervalSince1970]);
    
    //[NSThread sleepForTimeInterval:1];
    
    // 0.4s
    for (NSUInteger i = 0; i < 10000; i++) {
        NSLog(@"%lu", (unsigned long)i);
    }
    
    WCLog(@"doShortTimeWork   end: %f", [[NSDate date] timeIntervalSince1970]);
}


@end
