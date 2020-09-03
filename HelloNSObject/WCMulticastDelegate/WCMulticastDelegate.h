//
//  WCMulticastDelegate.h
//  HelloNSObject
//
//  Created by wesley_chen on 2020/8/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The multidelegate which allow add one more delegates
 
 @discussion This class support two mode: non-middle man, and middle man
 non-middle man, use init method
 middle man, use initWithMiddleManXXX methods
 */
@interface WCMulticastDelegate : NSObject

/**
 The middle man which intercepts the specific methods (by implement the methods) that disable call delegate methods implemented by delegates
 which added by addDelegate: method
 */
@property (nonatomic, weak, nullable) id middleMan;
@property (nonatomic, readonly, copy, nullable) NSArray *interceptedProtocols;

/**
 The multicast delegate
 
 @see https://blog.scottlogic.com/2012/11/19/a-multicast-delegate-pattern-for-ios-controls.html
 */
- (instancetype)init;

/**
 The multicast delegate with middle man interceptor mode
 
 @param middleMan the middle man
 @param firstInterceptedProtocol the interceptedProtocol list
 */
- (instancetype)initWithMiddleMan:(id)middleMan interceptedProtocols:(Protocol *)firstInterceptedProtocol, ... NS_REQUIRES_NIL_TERMINATION;

/**
 The multicast delegate with middle man interceptor mode
 
 @param middleMan the middle man
 @param interceptedProtocolArray the interceptedProtocol list
 */
- (instancetype)initWithMiddleMan:(id)middleMan interceptedProtocolArray:(NSArray *)interceptedProtocolArray;

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
