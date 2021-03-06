//
//  WCStickySectionManager.h
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WCStickySection.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCStickySectionStatus) {
    WCStickySectionStatusUnsticking,
    WCStickySectionStatusSticking,
};

@protocol WCStickySectionDelegate <NSObject>

- (void)stickySection:(WCStickySection *)section willChangeStatus:(WCStickySectionStatus)status;

@end

@interface WCStickySectionManager : NSObject

@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, weak) id<WCStickySectionDelegate> delegate;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
/**
 Add a section to top
 
 @discussion If the priority is same, add to top by First-In-First-Get rule
 @note The last added header section is front-most
 */
- (BOOL)addStickySection:(WCStickySection *)section atInitialY:(CGFloat)initialY;

@end

NS_ASSUME_NONNULL_END
