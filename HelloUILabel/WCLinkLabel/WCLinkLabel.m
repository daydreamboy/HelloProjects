//
//  WCLinkLabel.m
//  HelloUILabel
//
//  Created by wesley_chen on 2020/11/2.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCLinkLabel.h"
#import "WCLinkLabel_GestureRecognizer.h"
#import "WCLinkLabel_LayoutManager.h"

@interface WCLinkLabel () <NSLayoutManagerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) WCLinkLabel_LayoutManager *layoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;
@property (nonatomic, assign) NSRange selectedRange;
@end

@implementation WCLinkLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCommon];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupCommon];
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
  
    // Update our container size when the view frame changes
    self.textContainer.size = self.bounds.size;
    self.textContainer.maximumNumberOfLines = self.numberOfLines;
    self.textContainer.lineBreakMode = self.lineBreakMode;
    self.layoutManager.backgroundCornerRadius = self.linkBackgroundCornerRadius;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
 
    [self.textStorage setAttributedString:attributedText];
}

#pragma mark - Drawing

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    // Use our text container to calculate the bounds required. First save our
    // current text container setup
    CGSize savedTextContainerSize = self.textContainer.size;
    NSInteger savedTextContainerNumberOfLines = self.textContainer.maximumNumberOfLines;
   
    // Apply the new potential bounds and number of lines
    self.textContainer.size = bounds.size;
    self.textContainer.maximumNumberOfLines = numberOfLines;
   
    // Measure the text with the new state
    CGRect textBounds;
    @try {
        NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:self.textContainer];
        textBounds = [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];
   
        // Position the bounds and round up the size for good measure
        textBounds.origin = bounds.origin;
        textBounds.size.width = ceilf(textBounds.size.width);
        textBounds.size.height = ceilf(textBounds.size.height);
    }
    @finally {
        // Restore the old container state before we exit under any circumstances
        self.textContainer.size = savedTextContainerSize;
        self.textContainer.maximumNumberOfLines = savedTextContainerNumberOfLines;
    }
   
    return textBounds;
}

- (void)drawTextInRect:(CGRect)rect {
    // Calculate the offset of the text in the view
    CGPoint textOffset;
    NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:self.textContainer];
    textOffset = [self textOffsetForGlyphRange:glyphRange];
    
    [self.layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:textOffset];
  
    [super drawTextInRect:rect];
}

#pragma mark -

- (void)setupCommon {
    // Default background colour looks good on a white background
    self.linkBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
  
    WCLinkLabel_GestureRecognizer *touch = [[WCLinkLabel_GestureRecognizer alloc] initWithTarget:self action:@selector(labelTouched:)];
    touch.delegate = self;
    [self addGestureRecognizer:touch];
}

- (CGPoint)textOffsetForGlyphRange:(NSRange)glyphRange {
    CGPoint textOffset = CGPointZero;
  
    CGRect textBounds = [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];
    CGFloat paddingHeight = (self.bounds.size.height - textBounds.size.height) / 2.0f;
    if (paddingHeight > 0) {
        textOffset.y = paddingHeight;
    }
  
    return textOffset;
}

#pragma mark - Getters

- (NSTextStorage *)textStorage {
   if (!_textStorage) {
      _textStorage = [[NSTextStorage alloc] init];
      [_textStorage addLayoutManager:self.layoutManager];
      [self.layoutManager setTextStorage:_textStorage];
   }
 
   return _textStorage;
}

- (NSLayoutManager *)layoutManager {
    if (!_layoutManager) {
       // Create a layout manager for rendering
       _layoutManager = [[WCLinkLabel_LayoutManager alloc] init];
       [_layoutManager addTextContainer:self.textContainer];
    }

    return _layoutManager;
}
 
- (NSTextContainer *)textContainer {
   if (!_textContainer) {
      _textContainer = [[NSTextContainer alloc] init];
      _textContainer.lineFragmentPadding = 0;
      _textContainer.widthTracksTextView = YES;
      _textContainer.size = self.frame.size;
 
      [_textContainer setLayoutManager:self.layoutManager];
   }
 
   return _textContainer;
}

#pragma mark - Touching

- (NSUInteger)stringIndexAtLocation:(CGPoint)location {
    // Do nothing if we have no text
    if (self.textStorage.string.length == 0) {
       return NSNotFound;
    }
  
    // Work out the offset of the text in the view
    CGPoint textOffset;
    NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:self.textContainer];
    textOffset = [self textOffsetForGlyphRange:glyphRange];
  
    // Get the touch location and use text offset to convert to text cotainer coords
    location.x -= textOffset.x;
    location.y -= textOffset.y;
  
    NSUInteger glyphIndex = [self.layoutManager glyphIndexForPoint:location inTextContainer:self.textContainer];
  
    // If the touch is in white space after the last glyph on the line we don't
    // count it as a hit on the text
    NSRange lineRange;
    CGRect lineRect = [self.layoutManager lineFragmentUsedRectForGlyphAtIndex:glyphIndex effectiveRange:&lineRange];
  
    if (!CGRectContainsPoint(lineRect, location)) {
       return NSNotFound;
    }
  
    return [self.layoutManager characterIndexForGlyphAtIndex:glyphIndex];
}

- (void)setSelectedRange:(NSRange)range {
    // Remove the current selection if the selection is changing
    if (self.selectedRange.length && !NSEqualRanges(self.selectedRange, range)) {
        [self.textStorage removeAttribute:NSBackgroundColorAttributeName range:self.selectedRange];
    }
  
    // Apply the new selection to the text
    if (range.length) {
        [self.textStorage addAttribute:NSBackgroundColorAttributeName value:self.linkBackgroundColor range:range];
    }
  
    // Save the new range
    _selectedRange = range;
  
    [self setNeedsDisplay];
}

- (void)labelTouched:(WCLinkLabel_GestureRecognizer *)gesture {
   // Get the info for the touched link if there is one
   CGPoint touchLocation = [gesture locationInView:self];
   NSInteger index = [self stringIndexAtLocation:touchLocation];
 
   NSRange effectiveRange = NSMakeRange(NSNotFound, 0);
   NSString *touchedUrlString = nil;
 
   if (index != NSNotFound) {
      touchedUrlString = [self.attributedText attribute:NSLinkAttributeName atIndex:index effectiveRange:&effectiveRange];
   }
 
   switch (gesture.state) {
       case UIGestureRecognizerStateBegan: {
          if (touchedUrlString) {
             self.selectedRange = effectiveRange;
          }
          else {
             // no URL, cancel gesture
             gesture.enabled = NO;
             gesture.enabled = YES;
          }
  
          break;
       }
       case UIGestureRecognizerStateChanged: {
           break;
       }
       case UIGestureRecognizerStateEnded: {
           if (touchedUrlString && self.linkTappedBlock && NSEqualRanges(self.selectedRange, effectiveRange)) {
               self.linkTappedBlock(touchedUrlString, self.selectedRange);
           }
           self.selectedRange = NSMakeRange(0, 0);
           break;
       }
       default: {
           self.selectedRange = NSMakeRange(0, 0);
           break;
       }
   }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
   shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
   return YES;
}
 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchLocation = [touch locationInView:self];
  
    NSInteger index = [self stringIndexAtLocation:touchLocation];
  
    NSRange effectiveRange;
    NSString *touchedUrl = nil;
  
    if (index != NSNotFound) {
       touchedUrl = [self.attributedText attribute:NSLinkAttributeName atIndex:index effectiveRange:&effectiveRange];
    }
  
    if (touchedUrl) {
       return YES;
    }
  
    return NO;
}

@end
