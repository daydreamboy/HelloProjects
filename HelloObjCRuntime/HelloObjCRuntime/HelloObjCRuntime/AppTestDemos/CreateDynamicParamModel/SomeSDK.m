//
//  SomeSDK.m
//  HelloObjCRuntime
//
//  Created by wesley_chen on 03/01/2018.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import "SomeSDK.h"
#import "PublicModelsForSomeSDK_Internal.h"

#import "NSObject+WCObjCRuntime.h"
#import <WCObjCRuntime/WCRTProtocol.h>
#import <objc/runtime.h>

@implementation SomeSDK

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SomeSDK *sSomeSDK;
    dispatch_once(&onceToken, ^{
        sSomeSDK = [[SomeSDK alloc] init];
    });
    
    return sSomeSDK;
}

- (void)requestWithParamA:(void (^)(id<ParamA> param))preparation completion:(void (^)(void))completion {
    //id<ParamA> model = [self factory_method1_with_PublicModelsForSomeSDK_object];
    
    id<ParamA> model = [self factory_method2_with_protocolName:NSStringFromProtocol(@protocol(ParamA))];
    
    [model setName:@"Default"];
    
    preparation(model);
    NSString *name = [model name];
    NSLog(@"%@", name);
}

- (void)requestWithParamB:(void (^)(id<ParamB> param))preparation completion:(void (^)(void))completion {
//    id<ParamA> model = [self createDelegateWithProtocolName:@"Model_A"];
//    [model setName:@"Default"];
//    preparation(model);
//    NSString *name = [model name];
//    NSLog(@"%@", name);
}

#pragma mark - Factory Methods

- (id)factory_method1_with_PublicModelsForSomeSDK_object {
    PublicModelsForSomeSDK *instance = [PublicModelsForSomeSDK new];
    return instance;
}

- (id)factory_method2_with_protocolName:(NSString *)protocolName {
    PublicModelsForSomeSDK *instance = [PublicModelsForSomeSDK new];
    
    WCRTProtocol *protocol = [WCRTProtocol protocolWithName:protocolName];
    if (protocol) {
        NSString *name = [protocol name];
        NSLog(@"name: %@", name);
        
        NSArray *requiredMethodList = [protocol methodsRequired:YES instance:YES];
        // TODO:
        //instance rt_addProperty
    }
    
    return instance;
}

@end
