//
//  WCLabelTool.h
//  HelloUILabel
//
//  Created by wesley_chen on 2020/10/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WCLabelLinkInfoTapBlockType)(UILabel *label, NSRange linkRange, id userInfo);

@interface WCLabelTool : NSObject

+ (BOOL)addLinkDetectionWithLabel:(UILabel *)label linkColor:(UIColor *)linkColor linkTapBlock:(void (^)(UILabel *label, NSRange linkRange, id userInfo))linkTapBlock userInfo:(nullable id)userInfo forceReplace:(BOOL)forceReplace;

@end

NS_ASSUME_NONNULL_END
