//
//  WCGCDTool.h
//  HelloGCD
//
//  Created by wesley_chen on 12/12/2017.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCGCDTool : NSObject
+ (void)safePerformBlockOnMainQueue:(void (^)(void))block;
@end
