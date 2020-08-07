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
/// sorted section which priority from high to low
@property (nonatomic, strong, readwrite) NSMutableArray<WCStickySection *> *sections;
@end

@implementation WCStickySectionManager

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        _sections = [NSMutableArray array];
        
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (BOOL)addStickyHeaderSection:(WCStickySection *)section {
    NSInteger indexToInsert = self.sections.count;
    for (NSInteger i = 0; i < self.sections.count; ++i) {
        WCStickySection *currentSection = self.sections[i];
        if (section.priority > currentSection.priority) {
            indexToInsert = i;
            break;
        }
    }
    
    [self.sections insertObject:section atIndex:indexToInsert];
    
    for (WCStickySection *section in self.sections) {
        [self.scrollView addSubview:section];
    }
    
    return YES;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _scrollView && [keyPath isEqualToString:@"contentOffset"]) {
        NSValue *value = change[NSKeyValueChangeNewKey];
        CGPoint contentOffset = [value CGPointValue];
        
        NSLog(@"%f", contentOffset.y);
        
        for (WCStickySection *section in self.sections) {
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

#pragma mark -

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
