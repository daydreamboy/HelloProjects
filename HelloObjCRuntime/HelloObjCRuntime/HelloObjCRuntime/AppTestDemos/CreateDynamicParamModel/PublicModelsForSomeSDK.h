//
//  PublicModelsForSomeSDK.h
//  HelloObjCRuntime
//
//  Created by wesley_chen on 03/01/2018.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParamA <NSObject>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@end

@protocol ParamB <NSObject>
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSDictionary *dict;
@end
