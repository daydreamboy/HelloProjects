//
//  ParentHandler.h
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/29.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventChaining.h"

NS_ASSUME_NONNULL_BEGIN

@class ChildHandler;

@interface ParentHandler : NSObject <EventChaining>
@property (nonatomic, strong) ChildHandler *childHandler;
@end

NS_ASSUME_NONNULL_END
