//
//  MethodUnrecognizedGuard.h
//  HelloObjCRuntime
//
//  Created by wesley_chen on 04/01/2018.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MethodUnrecognizedGuard : NSObject
@property (nonatomic, copy) NSString *className;
@property (nonatomic, assign) SEL unrecognizedSelector;
@property (nonatomic, strong) NSArray<NSString *> *callStackSymbols;
@property (nonatomic, strong) NSArray<NSNumber *> *callStackReturnAddresses;

+ (void)inject;

@end
