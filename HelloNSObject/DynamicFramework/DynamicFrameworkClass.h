//
//  DynamicFrameworkClass.h
//  DynamicFramework
//
//  Created by wesley_chen on 2021/5/15.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DynamicFrameworkClass : NSObject {
    @package
        NSString *_packageIvar;
    @public
        NSString *_publicIvar;
}

@end

NS_ASSUME_NONNULL_END
