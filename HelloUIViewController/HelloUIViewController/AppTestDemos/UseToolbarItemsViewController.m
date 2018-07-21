//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "UseToolbarItemsViewController.h"

@interface UseToolbarItemsViewController ()
@property (nonatomic, strong) NSArray<UIBarButtonItem *> *toolbarItems;
@end

@implementation UseToolbarItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Toggle toolbar" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];

    // Note: If this view controller is embedded inside a navigation controller interface, and the navigation controller displays a toolbar, this property identifies the items to display in that toolbar.
    self.toolbarItems = self.toolbarItems;
    // Note: default is YES
    self.navigationController.toolbarHidden = NO;
}

#pragma mark - Getters

- (NSArray<UIBarButtonItem *> *)toolbarItems {
    if (!_toolbarItems) {
        UIBarButtonItem *moveToHeadItem = [[UIBarButtonItem alloc] initWithTitle:@"Move to Head" style:UIBarButtonItemStylePlain target:self action:@selector(moveToHeadItemClicked:)];
        UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteItemClicked:)];
        UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        _toolbarItems = @[moveToHeadItem, flexibleSpaceItem, deleteItem];
    }
    
    return _toolbarItems;
}

#pragma mark - Actions

- (void)rightBarButtonItemClicked:(id)sender {
    [self.navigationController setToolbarHidden:!self.navigationController.toolbarHidden animated:YES];
}

- (void)moveToHeadItemClicked:(id)sender {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)deleteItemClicked:(id)sender {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

@end
