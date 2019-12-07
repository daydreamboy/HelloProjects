//
//  IViewControllerInitOption.h
//  HelloUIScrollView
//
//  Created by wesley_chen on 2019/12/7.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IViewControllerInitOption <NSObject>
- (instancetype)initWithOptions:(NSDictionary *)options;
@end

NS_ASSUME_NONNULL_END
