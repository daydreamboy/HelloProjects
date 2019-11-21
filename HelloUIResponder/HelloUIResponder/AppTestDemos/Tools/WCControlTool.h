//
//  WCControlTool.h
//  HelloUIControl
//
//  Created by wesley_chen on 2019/11/19.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface WCControlTool : NSObject

@end

@interface WCControlTool ()

/**
 Get each target's selector for the every registered event of the control
 
 @param control control description
 @return the dictionary which contains all targets, each target's selectors for each registered event.
 The data structure is
 key - target address (NSString)
 NSArray[0] - target (id)
 NSArray[1] - event (NSNumber)
 NSArray[2] - event (NSString)
 NSArray[3] - selector (NSArray<NSString *> *)
 @discussion the returned dictionary will strongly hold the target, so the target should not hold the
 dictionary to avoid retain cycle.
 @see https://stackoverflow.com/a/5183349
 */
+ (nullable NSDictionary<NSString *, NSArray *> *)allTargetActionsMapWithControl:(UIControl *)control;

@end

NS_ASSUME_NONNULL_END
