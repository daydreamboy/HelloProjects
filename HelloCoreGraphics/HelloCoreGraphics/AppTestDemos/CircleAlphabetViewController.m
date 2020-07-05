//
//  CircleAlphabetViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/7/5.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "CircleAlphabetViewController.h"
#import "CircleAlphabetNaive.h"

@interface CircleAlphabetViewController ()
@property (nonatomic, strong) CircleAlphabetNaive *circleAlphabetNaive;
@end

@implementation CircleAlphabetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.circleAlphabetNaive];
}

#pragma mark - Getter

- (CircleAlphabetNaive *)circleAlphabetNaive {
    if (!_circleAlphabetNaive) {
        CircleAlphabetNaive *view = [[CircleAlphabetNaive alloc] initWithFrame:CGRectMake(0, 0, 200, 200) radius:80];
        _circleAlphabetNaive = view;
    }
    
    return _circleAlphabetNaive;
}

@end
