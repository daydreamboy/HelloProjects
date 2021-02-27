//
//  SomeSDK.h
//  HelloObjCRuntime
//
//  Created by wesley_chen on 03/01/2018.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicModelsForSomeSDK.h"

@interface SomeSDK : NSObject

+ (instancetype)sharedInstance;

- (void)requestWithParamA:(void (^)(id<ParamA> param))preparation completion:(void (^)(void))completion;
- (void)requestWithParamB:(void (^)(id<ParamB> param))preparation completion:(void (^)(void))completion;

@end
