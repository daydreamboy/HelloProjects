//
//  WCStickySectionManager.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCStickySectionManager.h"
#import "WCStickySection.h"
#import "WCStickySection_Internal.h"

@interface WCStickySectionManager ()
@property (nonatomic, weak, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableOrderedSet<WCStickySection *> *sectionsSet;
@property (nonatomic, strong) NSNumber *statusSwitchFlag;
@end

@implementation WCStickySectionManager

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        _sectionsSet = [[NSMutableOrderedSet alloc] init];
        
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (BOOL)addStickySection:(WCStickySection *)section atInitialY:(CGFloat)initialY {
    section.frame = CGRectMake(section.frame.origin.x, initialY, CGRectGetWidth(self.scrollView.bounds), section.height);
    section.initialY = initialY;
    [self.scrollView addSubview:section];
    [self.sectionsSet addObject:section];
    
    return YES;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _scrollView && [keyPath isEqualToString:@"contentOffset"]) {
        NSValue *value = change[NSKeyValueChangeNewKey];
        CGPoint contentOffset = [value CGPointValue];
        
        NSLog(@"%f", contentOffset.y);
        
        for (WCStickySection *section in [self.sectionsSet reverseObjectEnumerator]) {
            if (section.sticky) {
                section.frame = ({
                    CGRect frame = section.frame;
                    
                    // @see https://stackoverflow.com/questions/11272847/make-uiview-in-uiscrollview-stick-to-the-top-when-scrolled-up
                    if (contentOffset.y + section.fixedY > section.initialY) {
                        if (self.statusSwitchFlag.integerValue != WCStickySectionStatusSticking) {
                            self.statusSwitchFlag = @(WCStickySectionStatusSticking);
                            if ([self.delegate respondsToSelector:@selector(stickySection:willChangeStatus:)]) {
                                [self.delegate stickySection:section willChangeStatus:WCStickySectionStatusSticking];
                            }
                        }
                        
                        frame.origin.y = section.fixedY + contentOffset.y;
                    }
                    else {
                        if (self.statusSwitchFlag.integerValue != WCStickySectionStatusUnsticking) {
                            self.statusSwitchFlag = @(WCStickySectionStatusUnsticking);
                            [self.delegate stickySection:section willChangeStatus:WCStickySectionStatusSticking];
                        }
                        
                        frame.origin.y = section.initialY;
                    }
                    frame;
                });
            }
        }
    }
}

#pragma mark -

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
