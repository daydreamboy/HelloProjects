//
//  WCRuntimeHelper.h
//  HelloCaptureUIView
//
//  Created by chenliang-xy on 15/3/13.
//  Copyright (c) 2015年 chenliang-xy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCRuntimeHelper : NSObject

+ (void)exchangeSelectorForClass:(Class)cls origin:(SEL)origin substitute:(SEL)substitute;

@end
