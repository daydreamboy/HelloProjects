//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "UseGenericCollectionClassViewController.h"
#import <Foundation/Foundation.h>
#import "Cat.h"

@interface UseGenericCollectionClassViewController ()

@end

@implementation UseGenericCollectionClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_use_none_generic_collection_class];
    [self test_use_generic_collection_class];
}

#pragma mark - Test Methods

- (void)test_use_none_generic_collection_class {
    NSMutableSet *cats = [NSMutableSet set];
    [cats addObject:[NSObject new]];
}

- (void)test_use_generic_collection_class {
    NSMutableSet<Cat *> *cats = [NSMutableSet set];
    // Note: this will get a warning
    [cats addObject:[NSObject new]];
}

@end
