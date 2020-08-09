//
//  WCStickyPushSectionManager.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/9.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCStickyPushSectionManager.h"
#import "WCStickySection_Internal.h"

@interface WCStickyPushSectionManager ()
@property (nonatomic, weak, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableOrderedSet<WCStickySection *> *sections;
@end

@implementation WCStickyPushSectionManager

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        _sections = [[NSMutableOrderedSet alloc] init];
        
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (BOOL)addStickySection:(WCStickySection *)section atNextOffsetY:(CGFloat)nextOffsetY {
    section.sticky = NO;
    //CGFloat totalFixedHeight = 0;
    WCStickySection *firstStickySection = nil;
    for (WCStickySection *section in self.sections) {
        if (section.sticky) {
            if (!firstStickySection) {
                firstStickySection = section;
            }
            
            //totalFixedHeight += CGRectGetHeight(section.bounds);
        }
    }
    if (firstStickySection) {
        section.fixedY = firstStickySection.fixedY;
    }
    
    WCStickySection *lastSection = [self.sections lastObject];
    CGFloat initialY = CGRectGetMaxY(lastSection.frame) + nextOffsetY;
    
    section.frame = CGRectMake(0, initialY, CGRectGetWidth(self.scrollView.bounds), section.height);
    section.initialY = initialY;
    [self.scrollView addSubview:section];
    [self.sections addObject:section];
    
    WCStickySection *firstSection = [self.sections firstObject];
    firstSection.sticky = YES;
    
    return YES;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _scrollView && [keyPath isEqualToString:@"contentOffset"]) {
        NSValue *value = change[NSKeyValueChangeNewKey];
        CGPoint contentOffset = [value CGPointValue];
        
        NSLog(@"%f", contentOffset.y);
        
        for (NSInteger i = self.sections.count - 1; i >= 0; --i) {
            WCStickySection *section = self.sections[i];
            WCStickySection *previousSection = i > 0 ? self.sections[i - 1] : nil;
            
            if (section.sticky) {
                section.frame = ({
                    CGRect frame = section.frame;
                    
                    if (contentOffset.y + section.fixedY > section.initialY) {
                        frame.origin.y = section.fixedY + contentOffset.y;
                    }
                    else {
                        frame.origin.y = section.initialY;
                    }
                    frame;
                });
            }
            
            if (contentOffset.y + previousSection.fixedY + previousSection.height > section.initialY) {
                section.sticky = NO;
                previousSection.sticky = YES;
            }
            else {
                section.sticky = YES;
                previousSection.sticky = NO;
            }
        }
    }
}

#pragma mark -

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
