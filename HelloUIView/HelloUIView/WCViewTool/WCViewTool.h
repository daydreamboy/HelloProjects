//
//  WCViewTool.h
//  HelloUIView
//
//  Created by wesley_chen on 13/12/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCViewTool : NSObject
+ (void)registerGeometryChangedObserverForView:(UIView *)view;
+ (void)unregisterGeometryChangeObserverForView:(UIView *)view;
@end
