//
//  WrongContextManager.h
//  Tests
//
//  Created by wesley_chen on 2019/6/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCSharedContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface WrongContextManager : NSObject

+ (instancetype)sharedInstance;
- (nullable id<WCSharedContext>)objectForKeyedSubscript:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
