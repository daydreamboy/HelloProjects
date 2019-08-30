//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "Demo1ViewController.h"

@interface Demo1ViewController ()
@property (nonatomic, strong) NSDataDetector *dataDetector;
@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error;
    NSTextCheckingTypes types = NSTextCheckingAllTypes;
    _dataDetector = [[NSDataDetector alloc] initWithTypes:types error:&error];
    NSLog(@"%@", _dataDetector);
}

@end
