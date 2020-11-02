//
//  WCLabelTool.m
//  HelloUILabel
//
//  Created by wesley_chen on 2020/10/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCLabelTool.h"
#import <objc/runtime.h>

@interface WCLabelLinkInfo : NSObject
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, strong) UIColor *linkColor;
@property (nonatomic, strong) NSArray<NSValue *> *linkRanges;
@property (nonatomic, strong) NSValue *currentPressingLinkRangeValue;
@property (nonatomic, copy) WCLabelLinkInfoTapBlockType linkTapBlock;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong) CALayer *highlightLayer;

- (instancetype)initWithLabel:(UILabel *)label;
//- (void)linkTapped:(UITapGestureRecognizer *)recognizer;
@end

@implementation WCLabelLinkInfo

- (instancetype)initWithLabel:(UILabel *)label {
    self = [super init];
    if (self) {
        _label = label;
        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkTapped:)];
//        [label addGestureRecognizer:tapGesture];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkPressed:)];
        longPressGesture.minimumPressDuration = 0;
        [label addGestureRecognizer:longPressGesture];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

#pragma mark - Action

- (nullable NSValue *)checkIfHitLinkWithGesture:(UIGestureRecognizer *)recognizer {
    UILabel *label = self.label;
    if (!label) {
        return nil;
    }
    
    // @see https://stackoverflow.com/questions/1256887/create-tap-able-links-in-the-nsattributedstring-of-a-uilabel
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    NSTextContainer *textContainer = [NSTextContainer new];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:label.attributedText];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    // Configure textContainer
    textContainer.lineFragmentPadding = 0.0;
    textContainer.lineBreakMode = label.lineBreakMode;
    textContainer.maximumNumberOfLines = label.numberOfLines;
    textContainer.size = label.bounds.size;
    
    CGPoint locationOfTouchInLabel = [recognizer locationInView:recognizer.view];
    CGSize labelSize = recognizer.view.bounds.size;
    CGRect textBoundingBox = [layoutManager usedRectForTextContainer:textContainer];
    CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
    CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                         locationOfTouchInLabel.y - textContainerOffset.y);
    NSInteger indexOfCharacter = [layoutManager characterIndexForPoint:locationOfTouchInTextContainer
                                                            inTextContainer:textContainer
                                   fractionOfDistanceBetweenInsertionPoints:nil];
    
    if (indexOfCharacter < textStorage.length) {
        CGRect rect = [layoutManager lineFragmentUsedRectForGlyphAtIndex:indexOfCharacter effectiveRange:nil];
        if (CGRectContainsPoint(rect, locationOfTouchInTextContainer)) {
            for (NSValue *value in self.linkRanges) {
                NSRange linkRange = [value rangeValue];
                if (NSLocationInRange(indexOfCharacter, linkRange)) {
                    return value;
                }
            }
        }
    }
    
    return nil;
}

- (void)linkTapped:(UITapGestureRecognizer *)recognizer {
    UILabel *label = self.label;
    if (!label) {
        return;
    }
    
    // @see https://stackoverflow.com/questions/1256887/create-tap-able-links-in-the-nsattributedstring-of-a-uilabel
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    NSTextContainer *textContainer = [NSTextContainer new];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:label.attributedText];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    // Configure textContainer
    textContainer.lineFragmentPadding = 0.0;
    textContainer.lineBreakMode = label.lineBreakMode;
    textContainer.maximumNumberOfLines = label.numberOfLines;
    textContainer.size = label.bounds.size;
    
    CGPoint locationOfTouchInLabel = [recognizer locationInView:recognizer.view];
    CGSize labelSize = recognizer.view.bounds.size;
    CGRect textBoundingBox = [layoutManager usedRectForTextContainer:textContainer];
    CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
    CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                         locationOfTouchInLabel.y - textContainerOffset.y);
    NSInteger indexOfCharacter = [layoutManager characterIndexForPoint:locationOfTouchInTextContainer
                                                            inTextContainer:textContainer
                                   fractionOfDistanceBetweenInsertionPoints:nil];
    
    if (indexOfCharacter < textStorage.length) {
        CGRect rect = [layoutManager lineFragmentUsedRectForGlyphAtIndex:indexOfCharacter effectiveRange:nil];
        if (CGRectContainsPoint(rect, locationOfTouchInTextContainer)) {
            for (NSValue *value in self.linkRanges) {
                NSRange linkRange = [value rangeValue];
                if (NSLocationInRange(indexOfCharacter, linkRange)) {
                    !self.linkTapBlock ?: self.linkTapBlock(label, linkRange, self.userInfo);
                    break;
                }
            }
        }
    }
}

- (void)linkPressed:(UILongPressGestureRecognizer *)recognizer {
    // @see https://stackoverflow.com/questions/19611601/ios-detect-tap-down-and-touch-up-of-a-uiview
    NSLog(@"recognizer.state: %d", (int)recognizer.state);
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSValue *rangeValue = [self checkIfHitLinkWithGesture:recognizer];
        if (self.currentPressingLinkRangeValue == nil) {
            self.currentPressingLinkRangeValue = rangeValue;
            NSLog(@"detected");
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        NSValue *rangeValue = [self checkIfHitLinkWithGesture:recognizer];
        if (rangeValue == self.currentPressingLinkRangeValue) {
            NSLog(@"hitting");
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSValue *value = [self checkIfHitLinkWithGesture:recognizer];
        if (value == self.currentPressingLinkRangeValue) {
            NSRange linkRange = [value rangeValue];
            !self.linkTapBlock ?: self.linkTapBlock(self.label, linkRange, self.userInfo);
            NSLog(@"tap finished");
        }
        
        self.currentPressingLinkRangeValue = nil;
    }
    else if (recognizer.state == UIGestureRecognizerStateCancelled) {
        self.currentPressingLinkRangeValue = nil;
        NSLog(@"cancel");
    }
}

@end

@implementation WCLabelTool

const void *kAssociatedObjectKeyWCLabelLinkInfo = &kAssociatedObjectKeyWCLabelLinkInfo;

+ (BOOL)addLinkDetectionWithLabel:(UILabel *)label linkColor:(UIColor *)linkColor linkTapBlock:(void (^)(UILabel *label, NSRange linkRange, id userInfo))linkTapBlock userInfo:(nullable id)userInfo forceReplace:(BOOL)forceReplace {
    if (![label isKindOfClass:[UILabel class]]) {
        return NO;
    }
    
    WCLabelLinkInfo *linkInfo = objc_getAssociatedObject(label, kAssociatedObjectKeyWCLabelLinkInfo);
    if (linkInfo && !forceReplace) {
        return NO;
    }
    
    NSAttributedString *attributedText = nil;
    if (label.attributedText.length) {
        attributedText = label.attributedText;
    }
    else if (label.text.length) {
        attributedText = [[NSAttributedString alloc] initWithString:label.text];
    }
    
    NSMutableArray *linkRangesM = [NSMutableArray array];
    
    NSMutableAttributedString *attributedStringM = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    NSString *text = attributedText.string;
    NSDataDetector *detector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    [detector enumerateMatchesInString:text options:kNilOptions range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        [attributedStringM addAttribute:NSForegroundColorAttributeName value:linkColor range:result.range];
        [linkRangesM addObject:[NSValue valueWithRange:result.range]];
    }];
    
    label.attributedText = attributedStringM;
    
    linkInfo = [[WCLabelLinkInfo alloc] initWithLabel:label];
    linkInfo.linkColor = linkColor;
    linkInfo.linkTapBlock = linkTapBlock;
    linkInfo.linkRanges = linkRangesM;
    linkInfo.userInfo = userInfo;
    
    objc_setAssociatedObject(label, kAssociatedObjectKeyWCLabelLinkInfo, linkInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return YES;
}

@end
