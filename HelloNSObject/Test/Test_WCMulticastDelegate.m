//
//  Test_WCMulticastDelegate.m
//  Test
//
//  Created by wesley_chen on 2020/8/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCMulticastDelegate.h"

@protocol MyDelegate <NSObject>
- (void)delegateMethod;
@end

@interface AnObjectWithDelegate : NSObject
@property (nonatomic, strong) id<MyDelegate> delegate;
@end

@implementation AnObjectWithDelegate

- (void)triggerCallDelegate {
    if ([self.delegate respondsToSelector:@selector(delegateMethod)]) {
        [self.delegate delegateMethod];
    }
}

@end

#pragma mark -

@interface Delegate1 : NSObject <MyDelegate>
@end
@implementation Delegate1
- (void)delegateMethod {
    NSLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}
@end

@interface Delegate2 : NSObject <MyDelegate>
@end
@implementation Delegate2
- (void)delegateMethod {
    NSLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}
@end

@interface Delegate3 : NSObject <MyDelegate>
@end
@implementation Delegate3
- (void)delegateMethod {
    NSLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}
@end


@interface Test_WCMulticastDelegate : XCTestCase

@end

@implementation Test_WCMulticastDelegate

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_multicastDelegate {
    AnObjectWithDelegate *anObject = [AnObjectWithDelegate new];
    //
    //anObject.delegate = (id<MyDelegate>)anObject.multicastDelegate;
    
    [anObject takeOverDelegate];
    
    [anObject.multicastDelegate addDelegate:[Delegate1 new]];
    [anObject.multicastDelegate addDelegate:[Delegate2 new]];
    [anObject.multicastDelegate addDelegate:[Delegate3 new]];
    
    [anObject triggerCallDelegate];
}

@end
