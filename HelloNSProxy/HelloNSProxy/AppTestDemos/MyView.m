//
//  MyView.m
//  HelloNSProxy
//
//  Created by wesley_chen on 2018/5/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "MyView.h"
#import "WCDelegateProxy.h"

@interface MyView ()
@property (nonatomic, strong) id<MyViewLifeCycle> delegateProxy;
@end

@implementation MyView

PST_DELEGATE_PROXY(MyViewLifeCycle);

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        // Note: 使用WCDelegateProxy，不用使用respondsToSelector判断
        /*
        id<MyViewLifeCycle> delegate = self.delegate;
        if ([delegate respondsToSelector:@selector(myViewWillAppear:)]) {
            [delegate myViewWillAppear:self];
        }
         */
        [self.delegateProxy myViewWillAppear:self];
    }
    else {
        [self.delegateProxy myViewWillDisappear:self];
    }
}

- (void)didMoveToSuperview {
    if (self.superview) {
        [self.delegateProxy myViewDidAppear:self];
    }
    else {
        [self.delegateProxy myViewDidDisappear:self];
    }
}

@end
