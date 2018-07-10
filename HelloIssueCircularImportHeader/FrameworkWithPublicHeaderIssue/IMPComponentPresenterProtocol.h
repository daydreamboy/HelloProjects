//
//  IMPComponentPresenterProtocol.h
//  HelloIssueCircularImportHeader
//
//  Created by wesley_chen on 2018/7/10.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

// WARNING: This will cause a circular header import
#import "MsgDynamicCommon.h"

@protocol IMPComponentPresenterProtocol <NSObject>

// 获取View
- (UIView *)getView;

@end
