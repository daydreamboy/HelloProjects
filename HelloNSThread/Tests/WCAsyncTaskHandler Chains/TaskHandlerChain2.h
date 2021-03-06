//
//  TaskHandler2.h
//  Tests
//
//  Created by wesley_chen on 2020/8/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCAsyncTaskChainManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chain2_TaskHandler1 : NSObject <WCAsyncTaskHandler>
@end

@interface Chain2_TaskHandler2 : NSObject <WCAsyncTaskHandler>
@end

@interface Chain2_TaskHandler3 : NSObject <WCAsyncTaskHandler>
@end

NS_ASSUME_NONNULL_END
