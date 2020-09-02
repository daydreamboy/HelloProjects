//
//  WCMulticastDelegate.h
//  HelloNSObject
//
//  Created by wesley_chen on 2020/8/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// @see https://blog.scottlogic.com/2012/11/19/a-multicast-delegate-pattern-for-ios-controls.html
@interface WCMulticastDelegate : NSObject

@property (nonatomic, weak, nullable) id middleMan;
@property (nonatomic, readonly, copy, nullable) NSArray *interceptedProtocols;

- (instancetype)init;
- (instancetype)initWithMiddleMan:(id)middleMan interceptedProtocols:(Protocol *)firstInterceptedProtocol, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype)initWithMiddleMan:(id)middleMan interceptedProtocolArray:(NSArray *)arrayOfInterceptedProtocols;

- (BOOL)addDelegate:(id)delegate;
- (BOOL)removeDelegate:(id)delegate;
- (BOOL)removeAllDelegate;

@end

@interface NSObject (WCMulticastDelegate)

@property (nonatomic, strong, readonly) WCMulticastDelegate *multicastDelegate;

/**
 Set delegate of the current object to the WCMulticastDelegate object if needed
 
 @return YES if operate successfully
 */
- (BOOL)takeOverDelegateIfNeeded;

@end

NS_ASSUME_NONNULL_END
