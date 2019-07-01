//
//  RootHandler.h
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/29.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventChaining.h"

NS_ASSUME_NONNULL_BEGIN

@class ParentHandler;

@interface RootHandler : NSObject <EventChaining>
@property (nonatomic, strong) ParentHandler *parentHandler;
@end

NS_ASSUME_NONNULL_END
