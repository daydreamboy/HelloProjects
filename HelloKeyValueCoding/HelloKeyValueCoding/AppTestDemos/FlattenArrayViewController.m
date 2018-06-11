//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "FlattenArrayViewController.h"

@interface FlattenArrayViewController ()

@end

@implementation FlattenArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test_flatten_2D_array];
    [self test_flatten_3D_array];
}

- (void)test_flatten_2D_array {
    NSArray *arr2D = @[
                       @[@"1", @"2"],
                       @[@"3"],
                       @[@"4", @"5", @"6"],
                       ];
    // @see https://stackoverflow.com/a/17091443
    NSArray *flatArray = [arr2D valueForKeyPath:@"@unionOfArrays.self"];
    NSLog(@"%@", flatArray);
}

- (void)test_flatten_3D_array {
    NSArray *arr3D = @[
                       @[
                           @[@"1", @"2"],
                        ],
                       @[
                           @[@"3"],
                        ],
                       @[
                           @[@"4"],
                           @[@"5"],
                           @[@"6"],
                        ]
                       ];
    // @see https://stackoverflow.com/a/17091443
    NSArray *flatArray = [arr3D valueForKeyPath:@"@unionOfArrays.self.@unionOfArrays.self"];
    NSLog(@"%@", flatArray);
}

@end
