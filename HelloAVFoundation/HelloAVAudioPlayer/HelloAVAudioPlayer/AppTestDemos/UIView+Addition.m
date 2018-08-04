//
//  UIView+Addition.m
//  HelloAVAudioPlayer
//
//  Created by wesley_chen on 2018/8/3.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UIView+Addition.h"
#import <objc/runtime.h>

@implementation UIView (Addition)
static const char * const UIView_Frame_UserInfoObjectTag = "UIView_Frame_UserInfoObjectTag";
@dynamic userInfo;
- (void)setUserInfo:(id)userInfo {
    objc_setAssociatedObject(self, UIView_Frame_UserInfoObjectTag, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)userInfo {
    return objc_getAssociatedObject(self, UIView_Frame_UserInfoObjectTag);
}
@end
