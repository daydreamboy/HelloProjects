//
//  DataRaceViewController.m
//  HelloXcode_ThreadSanitizer
//
//  Created by wesley_chen on 2018/11/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DataRaceViewController.h"

@interface DataRaceViewController ()
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) BOOL messageIsAvailable;
@end

@implementation DataRaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSThread detachNewThreadSelector:@selector(consumer) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(producer) toTarget:self withObject:nil];
}

- (void)producer {
    _message = @"hello!";
    _messageIsAvailable = YES;
}

- (void)consumer {
    do {
        usleep(1000);
    }
    while (!_messageIsAvailable); // WARNING: Data race here!
    printf("%s", _message.UTF8String);
}

@end
