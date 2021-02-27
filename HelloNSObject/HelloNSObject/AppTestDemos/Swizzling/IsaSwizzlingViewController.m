//
//  IsaSwizzlingViewController.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 3/7/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "IsaSwizzlingViewController.h"
#import <objc/runtime.h>

@interface NormalModel : NSObject
@property (nonatomic, readonly) NSInteger readonlyInteger;
@end
@implementation NormalModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _readonlyInteger = 5;
    }
    return self;
}
@end

// Note: HackNormalModel must have same ivar layout as NormalModel
@interface HackNormalModel : NSObject {
@public
    NSInteger _readonlyInteger;
}
// Warning: first property `someInt` not match NormalModel's first property
//@property (nonatomic, assign) NSInteger *someInt;
@property (nonatomic, assign) NSInteger readonlyInteger;
// Note: ok, someInt after readonlyInteger
@property (nonatomic, assign) NSInteger *someInt;
- (void)hackReadonlyIntegerWithNumber:(NSNumber *)number;
@end

@implementation HackNormalModel
- (void)hackReadonlyIntegerWithNumber:(NSNumber *)number {
    _readonlyInteger = [number integerValue];
}
@end

@implementation IsaSwizzlingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // @see http://stackoverflow.com/questions/38877465/are-method-swizzling-and-isa-swizzling-the-same-thing
    NormalModel *normalModel = [NormalModel new];
    NSLog(@"readonly int: %ld", (long)normalModel.readonlyInteger);
    NSLog(@"Class name: %@", NSStringFromClass([normalModel class]));
    
    object_setClass(normalModel, [HackNormalModel class]);
    NSLog(@"Class name (isa-swizzled): %@", NSStringFromClass([normalModel class]));
    
    [normalModel performSelector:@selector(hackReadonlyIntegerWithNumber:) withObject:@(10)];
    NSLog(@"readonly int (isa-swizzled): %ld", (long)normalModel.readonlyInteger);
    
    HackNormalModel *hackNormalModel = (id)normalModel;
    hackNormalModel.readonlyInteger = 15;
    NSLog(@"readonly int (isa-swizzled): %ld", (long)normalModel.readonlyInteger);
    
    object_setClass(normalModel, [NormalModel class]);
//    hackNormalModel.readonlyInteger = 20; // Crash: unrecognized selector `setReadonlyInteger:` for NormalModel
    hackNormalModel->_readonlyInteger = 25;
    NSLog(@"readonly int (isa-swizzled): %ld", (long)normalModel.readonlyInteger);
}

@end
