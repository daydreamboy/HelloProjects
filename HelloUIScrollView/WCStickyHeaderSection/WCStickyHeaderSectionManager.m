//
//  WCStickyHeaderSectionManager.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCStickyHeaderSectionManager.h"

@interface WCStickyHeaderSectionManager ()
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<WCStickyHeaderSection *> *sections;
@property (nonatomic, assign) CGFloat contentInsetHeight;
@end

@implementation WCStickyHeaderSectionManager

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        _sections = [NSMutableArray array];
        _contentInsetHeight = 0;
        
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (BOOL)addStickyHeaderSection:(WCStickyHeaderSection *)section {
    [self.sections addObject:section];
    
    [self.scrollView addSubview:section];
    self.contentInsetHeight += section.height;
    
    return YES;
}

- (void)viewDidLayoutSubviews {
    self.scrollView.contentOffset = CGPointMake(0, -self.contentInsetHeight);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _scrollView && [keyPath isEqualToString:@"contentOffset"]) {
        NSValue *value = change[NSKeyValueChangeNewKey];
        CGPoint contentOffset = [value CGPointValue];
        
        NSLog(@"%f", contentOffset.y);
        
        for (WCStickyHeaderSection *section in self.sections) {
            if (section.sticky) {
                section.frame = ({
                    CGRect frame = section.frame;
                    
                    // @see https://stackoverflow.com/questions/11272847/make-uiview-in-uiscrollview-stick-to-the-top-when-scrolled-up
                    if (contentOffset.y + section.fixedY > section.initialY) {
                        frame.origin.y = section.fixedY + contentOffset.y;
                    }
                    else {
                        frame.origin.y = section.initialY;
                    }
                    frame;
                });
            }
        }
    }
}

@end
