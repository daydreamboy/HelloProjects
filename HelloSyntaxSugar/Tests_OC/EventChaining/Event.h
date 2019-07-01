//
//  Event.h
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Event : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong, nullable) NSDictionary *userInfo;

- (instancetype)initWithName:(NSString *)name userInfo:(nullable NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
