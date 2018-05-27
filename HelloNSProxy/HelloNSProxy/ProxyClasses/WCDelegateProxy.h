//
//  WCDelegateProxy.h
//  HelloNSProxy
//
//  Created by wesley_chen on 2018/5/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// Add this define into your implementation to save the delegate into the delegate proxy.
// You will also require an internal declaration as follows:
// @property (nonatomic, strong) id<XXXDelegate> delegateProxy;
#define PST_DELEGATE_PROXY_CUSTOM(protocolname, GETTER, SETTER) \
- (id<protocolname>)GETTER { return ((WCDelegateProxy *)self.GETTER##Proxy).delegate; } \
- (void)SETTER:(id<protocolname>)delegate { self.GETTER##Proxy = delegate ? (id<protocolname>)[[WCDelegateProxy alloc] initWithDelegate:delegate conformingToProtocol:@protocol(protocolname) defaultReturnValue:nil] : nil; }

#define PST_DELEGATE_PROXY(protocolname) PST_DELEGATE_PROXY_CUSTOM(protocolname, delegate, setDelegate)

@interface WCDelegateProxy : NSProxy
@property (nonatomic, weak, readonly) id delegate;
@property (nonatomic, strong, readonly) Protocol *protocol;
@property (nonatomic, strong, readonly) NSValue *defaultReturnValue;

// Designated initializer. `delegate` can be nil.
// `returnValue` will unbox on method signatures that return a primitive number (e.g. @YES)
// Method signatures that don't match the unboxed type in `returnValue` will be ignored.
- (id)initWithDelegate:(id)delegate conformingToProtocol:(Protocol *)protocol defaultReturnValue:(NSValue *)returnValue;

// Returns an object that will return `defaultValue` for methods that return an primitive value type.
// Method signatures that don't match the unboxed type in `returnValue` will be ignored.
- (instancetype)copyThatDefaultsTo:(NSValue *)defaultValue;
- (instancetype)copyThatDefaultsToYES;

@end
