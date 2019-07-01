//
//  BaseClassA1.h
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/29.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseClassA1 : NSObject
- (NSString *)thisMethodOverrideByCategory;
- (NSString *)internallyCallThisMethodOverrideByCategory;

@end

NS_ASSUME_NONNULL_END
