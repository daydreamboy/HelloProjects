//
//  WCStickyHeaderSectionManager.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCStickyHeaderSectionManager.h"
#import "WCStickySection_Internal.h"
#import <objc/runtime.h>

#define SYNTHESIZE_ASSOCIATED_PRIMITIVE(getterName, setterName, type)                                           \
- (void)setterName:(type)value {                                                                                \
    NSValue *nsValue = [NSValue value:&value withObjCType:@encode(type)];                                       \
    objc_setAssociatedObject(self, @selector(getterName), nsValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);          \
}                                                                                                               \
- (type)getterName {                                                                                            \
    type value;                                                                                                 \
    memset(&value, 0, sizeof(type));                                                                            \
    NSValue *nsValue = objc_getAssociatedObject(self, @selector(getterName));                                   \
    [nsValue getValue:&value];                                                                                  \
    return value;                                                                                               \
}

@implementation WCStickySection (Header)
SYNTHESIZE_ASSOCIATED_PRIMITIVE(priority, setPriority, NSInteger);
SYNTHESIZE_ASSOCIATED_PRIMITIVE(autoFixed, setAutoFixed, BOOL);

- (NSString *)description {
    return [NSString stringWithFormat:@"<WCStickyHeaderSection: %p; frame = %@; layer = <CALayer: %p>; priority = %d; sticky = %@; initialY = %f; fixedY = %f>", self, NSStringFromCGRect(self.frame), self.layer, (int)self.priority, self.sticky ? @"YES": @"NO", self.initialY, self.fixedY];
}

@end

@interface WCStickyHeaderSectionManager ()
/// sorted section which priority from high to low
@property (nonatomic, strong, readwrite) NSMutableArray<WCStickySection *> *sortedSections;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat sectionsTotalHeight;
@end

@implementation WCStickyHeaderSectionManager

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    self = [super initWithScrollView:scrollView];
    if (self) {
        _headerHeight = 0;
        _sectionsTotalHeight = 0;
        _sortedSections = [NSMutableArray array];
    }
    return self;
}

- (BOOL)addStickyHeaderSection:(WCStickySection *)section {
    return [self addStickyHeaderSection:section priority:0];
}

- (BOOL)addStickyHeaderSection:(WCStickySection *)section priority:(NSInteger)priority {
    section.priority = priority;
    
    NSInteger indexToInsert = self.sortedSections.count;
    for (NSInteger i = 0; i < self.sortedSections.count; ++i) {
        WCStickySection *currentSection = self.sortedSections[i];
        if (section.priority > currentSection.priority) {
            indexToInsert = i;
            break;
        }
    }
    
    if (section.autoFixed) {
        WCStickySection *firstStickySection = nil;
        CGFloat totalFixedHeight = 0;
        
        for (WCStickySection *section in self.sortedSections) {
            if (section.sticky) {
                if (!firstStickySection) {
                    firstStickySection = section;
                }
                
                totalFixedHeight += CGRectGetHeight(section.bounds);
            }
        }
        if (firstStickySection) {
            section.fixedY = firstStickySection.fixedY + totalFixedHeight;
        }
    }
    
    [self.sortedSections insertObject:section atIndex:indexToInsert];
    
    self.sectionsTotalHeight += section.height;
    self.headerHeight = self.sectionsTotalHeight + [self.sortedSections firstObject].fixedY;
    
    CGFloat startY = -self.sectionsTotalHeight;
    for (WCStickySection *section in self.sortedSections) {
        [super addStickySection:section atInitialY:startY];
        startY += section.height;
        [self.scrollView sendSubviewToBack:section];
    }
    
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.top = self.headerHeight;
    self.scrollView.contentInset = contentInset;
    
    return YES;
}

- (void)changeStickyHeaderSection:(WCStickySection *)section toHeight:(CGFloat)height {
    CGFloat sectionOldHeight = section.height;
    section.height = height >= 0 ? height : 0;
    self.sectionsTotalHeight = section.height - sectionOldHeight + self.sectionsTotalHeight;
    
    CGFloat startY = -self.sectionsTotalHeight;
    
    WCStickySection *previousStickySection = nil;
    for (NSInteger i = 0; i < self.sortedSections.count; ++i) {
        WCStickySection *sectionToUpdate = self.sortedSections[i];
        sectionToUpdate.initialY = startY;
        startY += sectionToUpdate.height;
        
        if (sectionToUpdate.sticky && sectionToUpdate.autoFixed) {
            sectionToUpdate.fixedY = previousStickySection ? previousStickySection.fixedY + previousStickySection.height : sectionToUpdate.fixedY;
        }
        
        if (sectionToUpdate.sticky) {
            previousStickySection = sectionToUpdate;
        }
    }
    
    self.headerHeight = self.sectionsTotalHeight + [self.sortedSections firstObject].fixedY;
    
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.top = self.headerHeight;
    self.scrollView.contentInset = contentInset;
    self.scrollView.contentOffset = CGPointMake(0, -self.headerHeight);
}

- (void)viewDidLayoutSubviews {
    self.scrollView.contentOffset = CGPointMake(0, -self.headerHeight);
}

@end
