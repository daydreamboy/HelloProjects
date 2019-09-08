//
//  ObtainWeakVariableViewController.m
//  HelloObjCRuntime
//
//  Created by wesley_chen on 2019/4/11.
//  Copyright © 2019 wesley chen. All rights reserved.
//

#import "ObtainWeakVariableViewController.h"

@interface MyModel : NSObject
@property (nonatomic, strong) void (^cleanUpBlock)(void);
@property (nonatomic, strong) NSString *name;
@end

@implementation MyModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _name = @"123";
        
        __weak typeof(self) weak_self = self;
        _cleanUpBlock = ^{
            __strong typeof(weak_self) strong_self = weak_self;
            NSString *localName = weak_self.name;
            
            if (weak_self) NSLog(@"weak_self is not nil");
            else NSLog(@"weak_self is nil");
            
            if (strong_self) NSLog(@"strong_self is not nil");
            else NSLog(@"strong_self is nil");
            
            if (localName) NSLog(@"localName is not nil");
            else NSLog(@"localName is nil");
        };
    }
    return self;
}

- (void)dealloc {
    _cleanUpBlock();
}

@end

@implementation ObtainWeakVariableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    MyModel *model = [MyModel new];
    NSLog(@"%@", model);
}

@end
