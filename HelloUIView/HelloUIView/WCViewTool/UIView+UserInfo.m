//
//  UIView+UserInfo.m
//  HelloUIView
//
//  Created by wesley_chen on 2018/8/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UIView+UserInfo.h"
#import <objc/runtime.h>

@implementation UIView (UserInfo)

@dynamic associatedUserObject;
@dynamic associatedUserInfo;
@dynamic associatedWeakUserInfo;

- (void)setAssociatedUserObject:(id)userObject {
    objc_setAssociatedObject(self, @selector(associatedUserObject), userObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedUserObject {
    return objc_getAssociatedObject(self, @selector(associatedUserObject));
}

- (NSMutableDictionary *)associatedUserInfo {
    NSMutableDictionary *dictM = objc_getAssociatedObject(self, @selector(associatedUserInfo));
    
    if (dictM == nil) {
        @synchronized(self) {
            if (dictM == nil) {
                dictM = [NSMutableDictionary dictionary];
                objc_setAssociatedObject(dictM, @selector(associatedUserInfo), dictM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    
    return dictM;
}

- (NSMapTable *)associatedWeakUserInfo {
    NSMapTable *tableStrongToWeak = objc_getAssociatedObject(self, @selector(associatedWeakUserInfo));
    
    if (tableStrongToWeak == nil) {
        @synchronized(self) {
            if (tableStrongToWeak == nil) {
                tableStrongToWeak = [NSMapTable strongToWeakObjectsMapTable];
                objc_setAssociatedObject(tableStrongToWeak, @selector(associatedWeakUserInfo), tableStrongToWeak, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    
    return tableStrongToWeak;
}

@end
