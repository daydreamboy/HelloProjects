//
//  WCMockGestureWrapper.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2019/12/10.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCMockGestureWrapper.h"

@interface WCMockTapGestureRecognizer : UITapGestureRecognizer
@property (nonatomic, assign) CGPoint position;
@end

@implementation WCMockTapGestureRecognizer

- (CGPoint)locationInView:(UIView *)view {
    return self.position;
}

@end

@implementation WCMockGestureWrapper

- (instancetype)initWithGesture:(UIGestureRecognizer *)gestureRecognizer {
    self = [super init];
    if (self) {
        _originalGesture = gestureRecognizer;
        _targetView = gestureRecognizer.view;
        _targetActionPairs = [NSMutableArray array];
        if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            _mockGesture = [[WCMockTapGestureRecognizer alloc] initWithTarget:nil action:nil];
        }
        
        @try {
            [_mockGesture setValue:_targetView forKey:@"_view"];
        } @catch (NSException *exception) {}
    }
    return self;
}

- (BOOL)addTarget:(id)target action:(SEL)action {
    if (target && action) {
        [_targetActionPairs addObject:@[ target, NSStringFromSelector(action) ]];
        [_mockGesture addTarget:target action:action];
        return YES;
    }
    
    return NO;
}

- (BOOL)triggerGesture {
    BOOL status = NO;
    for (NSArray *targetActionPair in _targetActionPairs) {
        if (targetActionPair.count == 2) {
            status = YES;
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
            [targetActionPair[0] performSelector:NSSelectorFromString(targetActionPair[1]) withObject:_mockGesture];
#pragma GCC diagnostic pop
        }
    }
    
    return status;
}

@end

@implementation WCMockTapGestureWrapper

- (instancetype)initWithGesture:(UIGestureRecognizer *)gestureRecognizer {
    self = [super initWithGesture:gestureRecognizer];
    if (self) {
        if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)gestureRecognizer;
            _numberOfTapsRequired = tapGesture.numberOfTapsRequired;
            _numberOfTouchesRequired = tapGesture.numberOfTouchesRequired;
        }
    }
    return self;
}

- (BOOL)triggerTapsAtPosition:(CGPoint)position {
    return [self triggerTapsAtPosition:position numberOfTaps:1 numberOfTouches:1];
}

- (BOOL)triggerTapsAtPosition:(CGPoint)position numberOfTaps:(NSUInteger)numberOfTaps numberOfTouches:(NSUInteger)numberOfTouches {
    numberOfTaps = MAX(1, numberOfTaps);
    numberOfTouches = MAX(1, numberOfTouches);
    
    if (numberOfTaps == self.numberOfTapsRequired && numberOfTouches == self.numberOfTouchesRequired) {
        if (CGRectContainsPoint(self.originalGesture.view.bounds, position)) {
            WCMockTapGestureRecognizer *mockGesture = (WCMockTapGestureRecognizer *)self.mockGesture;
            mockGesture.position = position;
            
            return [super triggerGesture];
        }
    }
    
    return NO;
}

@end
