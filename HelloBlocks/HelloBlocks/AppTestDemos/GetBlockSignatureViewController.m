//
//  GetBlockSignatureViewController.m
//  HelloBlocks
//
//  Created by wesley_chen on 27/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "GetBlockSignatureViewController.h"
#import "WCBlockTool.h"

#define STR_OF_BOOL(yesOrNo)     ((yesOrNo) ? @"YES" : @"NO")

@interface GetBlockSignatureViewController ()

@end

@implementation GetBlockSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test_WCBlockDescriptor_initWithBlock];
//    [self test_WCBlockDescriptor_isEqual];
//    [self test_WCBlockDescriptor_blockSignatureTypes];
    [self test_WCBlockDescriptor_isEqualToSigature];
}

#pragma mark - Test Methods

- (void)test_WCBlockDescriptor_initWithBlock {
    id block = nil;
    
    if (@available(iOS 10, *)) {
        // iOS 10 ObjC code
        NSLog(@"something");
    }
    
    block = ^{
        NSLog(@"some output");
    };
    
    WCBlockDescriptor *descriptor = [[WCBlockDescriptor alloc] initWithBlock:block];
    NSLog(@"%@", descriptor);
}

- (void)test_WCBlockDescriptor_isEqual {
    id block1 = nil;
    id block2 = nil;
    
    block1 = ^(NSNumber *a){
        NSLog(@"a = %@", a);
    };
    
    block2 = ^(NSNumber *b){
        NSLog(@"b = %@", b);
    };
    
    WCBlockDescriptor *descriptor1 = [[WCBlockDescriptor alloc] initWithBlock:block1];
    NSLog(@"%@", descriptor1);
    
    WCBlockDescriptor *descriptor2 = [[WCBlockDescriptor alloc] initWithBlock:block2];
    NSLog(@"%@", descriptor2);
    
    NSLog(@"descriptor1 == descriptor2: %@", STR_OF_BOOL([descriptor2 isEqual:descriptor1]));
}

- (void)test_WCBlockDescriptor_isEqualToSigature {
    id block = nil;
    WCBlockDescriptor *descriptor = nil;
    const char *encodeType = nil;
    
    // case
    block = ^(NSNumber *a) {
        NSLog(@"a = %@", a);
    };
    descriptor = [[WCBlockDescriptor alloc] initWithBlock:block];
    encodeType = "v@?@\"NSNumber\"";
    NSLog(@"%@", STR_OF_BOOL([descriptor isEqualToSigature:[NSMethodSignature signatureWithObjCTypes:encodeType]]));
    
    // case
    block = ^{
        NSLog(@"a = ?");
    };
    descriptor = [[WCBlockDescriptor alloc] initWithBlock:block];
    encodeType = "v@?";
    NSLog(@"%@", STR_OF_BOOL([descriptor isEqualToSigature:[NSMethodSignature signatureWithObjCTypes:encodeType]]));
    
    // case
    block = ^id(int a) {
        NSLog(@"a = ?");
        return @"object";
    };
    descriptor = [[WCBlockDescriptor alloc] initWithBlock:block];
    encodeType = "@@?i";
    NSLog(@"%@", STR_OF_BOOL([descriptor isEqualToSigature:[NSMethodSignature signatureWithObjCTypes:encodeType]]));
    
    // case
    block = ^id(int a) {
        NSLog(@"a = ?");
        return @"object";
    };
    descriptor = [[WCBlockDescriptor alloc] initWithBlock:block];
    encodeType = "@@?i";
    NSLog(@"%@", STR_OF_BOOL([descriptor isEqualToSigature:[NSMethodSignature signatureWithObjCTypes:encodeType]]));
}

- (void)test_WCBlockDescriptor_blockSignatureTypes {
    WCBlockDescriptor *descriptor;
    id block = nil;
    
    //
    block = ^(NSNumber *a){
        NSLog(@"a = %@", a);
    };
    descriptor = [[WCBlockDescriptor alloc] initWithBlock:block];
    NSLog(@"%@", [descriptor blockSignatureTypes]);
    
    //
    block = ^(NSObject *b){
        NSLog(@"b = %@", b);
    };
    descriptor = [[WCBlockDescriptor alloc] initWithBlock:block];
    NSLog(@"%@", [descriptor blockSignatureTypes]);
    
    //
    block = ^(NSObject *b, int a){
        NSLog(@"b = %@", b);
    };
    descriptor = [[WCBlockDescriptor alloc] initWithBlock:block];
    NSLog(@"%@", [descriptor blockSignatureTypes]);
    
    //
    block = ^NSString *(NSObject *b, int a){
        NSLog(@"b = %@", b);
        NSString *str = @"hello";
        return str;
    };
    descriptor = [[WCBlockDescriptor alloc] initWithBlock:block];
    NSLog(@"%@", [descriptor blockSignatureTypes]);
}

@end
