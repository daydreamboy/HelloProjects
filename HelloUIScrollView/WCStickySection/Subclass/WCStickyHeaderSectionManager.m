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

@interface WCStickySection (Header)
/**
 The priority of sorting. Default is 0
 
 @discussion If the priority is bigger, this header section is possibly arranged at the topmost than other sections
 */
@property (nonatomic, assign) NSInteger priority;
@end

@implementation WCStickySection (Header)
SYNTHESIZE_ASSOCIATED_PRIMITIVE(priority, setPriority, NSInteger);

- (NSString *)description {
    return [NSString stringWithFormat:@"<WCStickyHeaderSection: %p; frame = %@; layer = <CALayer: %p>; priority = %d; sticky = %@>", self, NSStringFromCGRect(self.frame), self.layer, (int)self.priority, self.sticky ? @"YES": @"NO"];
}

@end

@interface WCStickyHeaderSectionManager ()
/// sorted section which priority from high to low
@property (nonatomic, strong, readwrite) NSMutableArray<WCStickySection *> *sortedSections;
@property (nonatomic, assign) CGFloat headerHeight;
@end

@implementation WCStickyHeaderSectionManager

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    self = [super initWithScrollView:scrollView];
    if (self) {
        _headerHeight = 0;
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
    
    [self.sortedSections insertObject:section atIndex:indexToInsert];
    
    self.headerHeight += section.height;
    CGFloat startY = -self.headerHeight;
    for (WCStickySection *section in self.sortedSections) {
        [super addStickySection:section atInitialY:startY];
        startY += section.height;
    }
    
    self.scrollView.contentInset = UIEdgeInsetsMake(self.headerHeight, 0, 0, 0);

    return YES;
}

- (void)viewDidLayoutSubviews {
    self.scrollView.contentOffset = CGPointMake(0, -self.headerHeight);
}

@end
