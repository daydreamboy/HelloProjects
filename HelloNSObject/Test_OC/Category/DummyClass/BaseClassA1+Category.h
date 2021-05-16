//
//  BaseClassA1+Category.h
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/29.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "BaseClassA1.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseClassA1 (Category)
- (NSString *)thisMethodOverrideByCategory;
@end

NS_ASSUME_NONNULL_END
