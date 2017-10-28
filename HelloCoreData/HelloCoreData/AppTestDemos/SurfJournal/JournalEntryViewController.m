//
//  JournalEntryViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 28/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "JournalEntryViewController.h"
#import <Foundation/Foundation.h>

@interface JournalEntryViewController ()
@property (nonatomic, strong) NSArray<UITextField *> *textFields;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@end

@implementation JournalEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(itemCancelClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(itemSaveClicked:)];
    
    [self setupViews];
}

#pragma mark -

- (void)setupViews {
    NSArray *titles = @[
                         @"Height",
                         @"Period",
                         @"Wind",
                         @"Location",
                         @"Rating",
                         ];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:4];
    
    CGFloat startY = 64 + 10;
    CGFloat startX = 10;
    CGFloat height = 20;
    CGFloat width = 72;
    CGFloat spaceV = 20;
    for (NSInteger i = 0; i < titles.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY + i * (height + spaceV), width, height)];
        label.font = [UIFont systemFontOfSize:16];
        label.text = [NSString stringWithFormat:@"%@:", titles[i]];
        [self.view addSubview:label];
        
        CGRect frame = CGRectMake(CGRectGetMaxX(label.frame) + 5, CGRectGetMidY(label.frame) - 30 / 2.0, 224, 30);
        if (i < titles.count - 1) {
            UITextField *textField = [[UITextField alloc] initWithFrame:frame];
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.borderStyle = UITextBorderStyleRoundedRect;
            [self.view addSubview:textField];
            
            [arrM addObject:textField];
        }
        else {
            NSArray *items = @[ @"1", @"2", @"3", @"4", @"5" ];
            UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
            segmentedControl.frame = frame;
            [self.view addSubview:segmentedControl];
            self.segmentedControl = segmentedControl;
        }
    }
}

#pragma mark - Actions

- (void)itemCancelClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(viewControllerDidFinish:saved:)]) {

    }
}

- (void)itemSaveClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(viewControllerDidFinish:saved:)]) {
        
    }
}

@end
