//
//  WCMockGestureWrapper.h
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2019/12/10.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCMockGestureWrapper : NSObject
@property (nonatomic, weak) UIGestureRecognizer *originalGesture;
@property (nonatomic, strong) UIGestureRecognizer *mockGesture;
@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, strong) NSMutableArray<NSArray *> *targetActionPairs;

- (instancetype)initWithGesture:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)addTarget:(id)target action:(SEL)action;

@end

@interface WCMockTapGestureWrapper : WCMockGestureWrapper

@property (nonatomic, assign) NSUInteger numberOfTapsRequired;
@property (nonatomic, assign) NSUInteger numberOfTouchesRequired;

- (BOOL)triggerTapsAtPosition:(CGPoint)position;
- (BOOL)triggerTapsAtPosition:(CGPoint)position numberOfTaps:(NSUInteger)numberOfTaps numberOfTouches:(NSUInteger)numberOfTouches;

@end


NS_ASSUME_NONNULL_END
