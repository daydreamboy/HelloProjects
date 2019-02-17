//
//  MyPoint.h
//  Tests
//
//  Created by wesley_chen on 2019/2/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class MyPoint;

@protocol MyPointsExports <JSExport>
@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
- (NSString *)description;
- (instancetype)initWithX:(double)x y:(double)y;
+ (MyPoint *)makePointWithX:(double)x y:(double)y;

JSExportAs(makeMyPointWithXY, + (MyPoint *)makePoint2WithX:(double)x y:(double)y);
// Note: the aboved JSExportAs preprocessed as the followings lines
/*
@optional
+ (MyPoint *)makePoint2WithX:(double)x y:(double)y __JS_EXPORT_AS__makeMyPointWithXY:(id)argument;
@required
+ (MyPoint *)makePoint2WithX:(double)x y:(double)y;
 */

@end

@interface MyPoint : NSObject <MyPointsExports>
@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
- (void)myPrivateMethod;
@end
