//
//  BaseClass3+BaseClass3_Internal.h
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/26.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseClass3.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseClass3 () {
    // Note: Ivar without any modifier in extension is private by default
@protected
    NSInteger _number;
}
@end

NS_ASSUME_NONNULL_END
