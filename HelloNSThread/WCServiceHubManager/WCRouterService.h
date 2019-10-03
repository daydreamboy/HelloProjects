//
//  WCRouterService.h
//  HelloNSThread
//
//  Created by wesley_chen on 2019/9/3.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WCRouterService <NSObject>
- (instancetype)initWithURL:(NSURL *)URL nativeParam:(NSDictionary *)nativeParam;
@end

NS_ASSUME_NONNULL_END
