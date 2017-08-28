//
//  WCRuntimeHelper.m
//  HelloCaptureUIView
//
//  Created by chenliang-xy on 15/3/13.
//  Copyright (c) 2015年 chenliang-xy. All rights reserved.
//

#import "WCRuntimeHelper.h"
#import <objc/runtime.h>

@implementation WCRuntimeHelper

/*!
 *  Exchange IMPs for two Methods
 *
 *  @param cls          the Class to be modified
 *  @param origin       the origin Method
 *  @param substitute   the substitute Method
 */
+ (void)exchangeSelectorForClass:(Class)cls origin:(SEL)origin substitute:(SEL)substitute {
	Method origMethod = class_getInstanceMethod(cls, origin);
	Method replaceMethod = class_getInstanceMethod(cls, substitute);
    
	if (class_addMethod(cls, origin, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod))) {
		class_replaceMethod(cls, substitute, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
	}
	else {
		method_exchangeImplementations(origMethod, replaceMethod);
	}
}

@end
