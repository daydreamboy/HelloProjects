//
//  CreateWeakSelfInDeallocViewController.m
//  HelloObjCRuntimeCrash
//
//  Created by wesley_chen on 2019/4/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CreateWeakSelfInDeallocViewController.h"

@interface MyModel : NSObject
@end

@implementation MyModel
- (void)dealloc {
    __weak typeof(self) weak_self = self; // CRASH
    NSLog(@"%@", weak_self);
}
@end

@implementation CreateWeakSelfInDeallocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    MyModel *model = [MyModel new];
    NSLog(@"%@", model);
}

@end
