//
//  WCLabel.m
//  HelloUILabel
//
//  Created by wesley_chen on 2020/11/2.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCLabel.h"

@interface WCLabel_LayoutManager : NSLayoutManager

@end

@implementation WCLabel_LayoutManager

- (void)drawUnderlineForGlyphRange:(NSRange)glyphRange
                     underlineType:(NSUnderlineStyle)underlineVal
                    baselineOffset:(CGFloat)baselineOffset
                  lineFragmentRect:(CGRect)lineRect
            lineFragmentGlyphRange:(NSRange)lineGlyphRange
                   containerOrigin:(CGPoint)containerOrigin {
    // ignore underlines
}

- (void)showCGGlyphs:(const CGGlyph *)glyphs
           positions:(const CGPoint *)positions
               count:(NSUInteger)glyphCount
                font:(UIFont *)font
              matrix:(CGAffineTransform)textMatrix
          attributes:(NSDictionary *)attributes
           inContext:(CGContextRef)graphicsContext {
   UIColor *foregroundColor = attributes[NSForegroundColorAttributeName];
 
   if (foregroundColor) {
      CGContextSetFillColorWithColor(graphicsContext, foregroundColor.CGColor);
   }
 
   [super showCGGlyphs:glyphs
             positions:positions
                 count:glyphCount
                  font:font
                matrix:textMatrix
            attributes:attributes
             inContext:graphicsContext];
}

- (void)fillBackgroundRectArray:(const CGRect *)rectArray count:(NSUInteger)rectCount forCharacterRange:(NSRange)charRange color:(UIColor *)color {
    // @see https://stackoverflow.com/questions/21857408/how-to-set-nsstrings-background-cornerradius-on-ios7
    // @see https://stackoverflow.com/questions/16362407/nsattributedstring-background-color-and-rounded-corners
    CGFloat halfLineWidth = 4.; // change this to change corners radius

    CGMutablePathRef path = CGPathCreateMutable();

    if (rectCount == 1 || (rectCount == 2 && (CGRectGetMaxX(rectArray[1]) < CGRectGetMinX(rectArray[0])))) {
        // 1 rect or 2 rects without edges in contact

         CGPathAddRect(path, NULL, CGRectInset(rectArray[0], halfLineWidth, halfLineWidth));
         if (rectCount == 2)
             CGPathAddRect(path, NULL, CGRectInset(rectArray[1], halfLineWidth, halfLineWidth));
    }
    else {
        // 2 or 3 rects
        NSUInteger lastRect = rectCount - 1;

        CGPathMoveToPoint(path, NULL, CGRectGetMinX(rectArray[0]) + halfLineWidth, CGRectGetMaxY(rectArray[0]) + halfLineWidth);

        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rectArray[0]) + halfLineWidth, CGRectGetMinY(rectArray[0]) + halfLineWidth);
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[0]) - halfLineWidth, CGRectGetMinY(rectArray[0]) + halfLineWidth);

        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[0]) - halfLineWidth, CGRectGetMinY(rectArray[lastRect]) - halfLineWidth);
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[lastRect]) - halfLineWidth, CGRectGetMinY(rectArray[lastRect]) - halfLineWidth);

        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[lastRect]) - halfLineWidth, CGRectGetMaxY(rectArray[lastRect]) - halfLineWidth);
        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rectArray[lastRect]) + halfLineWidth, CGRectGetMaxY(rectArray[lastRect]) - halfLineWidth);

        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rectArray[lastRect]) + halfLineWidth, CGRectGetMaxY(rectArray[0]) + halfLineWidth);

        CGPathCloseSubpath(path);
        
    }
    
    [color set]; // set fill and stroke color

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, halfLineWidth * 2.);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);

    CGContextAddPath(ctx, path);
    CGPathRelease(path);

    CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end

@interface WCLabel_TouchGestureRecognizer : UIGestureRecognizer

@end

@implementation WCLabel_TouchGestureRecognizer
 
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   self.state = UIGestureRecognizerStateBegan;
}
 
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
   self.state = UIGestureRecognizerStateChanged;
}
 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
   self.state = UIGestureRecognizerStateEnded;
}
 
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
   self.state = UIGestureRecognizerStateCancelled;
}
 
@end

@interface WCLabel () <NSLayoutManagerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;
@property (nonatomic, assign) NSRange selectedRange;
@end

@implementation WCLabel

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
}
 
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
  
    CGSize size = frame.size;
    size.width = MIN(size.width, self.preferredMaxLayoutWidth);
    size.height = 0;
    self.textContainer.size = size;
}
 
- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
  
    CGSize size = bounds.size;
    size.width = MIN(size.width, self.preferredMaxLayoutWidth);
    size.height = 0;
    self.textContainer.size = size;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    // Pass the text to the super class first
    [super setAttributedText:attributedText];
 
    [self.textStorage setAttributedString:attributedText];
}

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
    [super setPreferredMaxLayoutWidth:preferredMaxLayoutWidth];
  
    CGSize size = self.bounds.size;
    size.width = MIN(size.width, self.preferredMaxLayoutWidth);
    self.textContainer.size = size;
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
  
    // Drawing code
    [self.layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:textOffset];
  
    // for debugging the following 2 line should produce the same results
    [self.layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:textOffset];
    //[super drawTextInRect:rect];
}

#pragma mark -

- (void)setupCommon {
    // Make sure user interaction is enabled so we can accept touches
    self.userInteractionEnabled = YES;
  
    // Default background colour looks good on a white background
    self.linkBackgroundColor = [UIColor greenColor];// [UIColor colorWithWhite:0.95 alpha:1.0];
  
    WCLabel_TouchGestureRecognizer *touch = [[WCLabel_TouchGestureRecognizer alloc] initWithTarget:self action:@selector(labelTouched:)];
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
       _layoutManager = [[WCLabel_LayoutManager alloc] init];
       _layoutManager.delegate = self;
       [_layoutManager addTextContainer:self.textContainer];
    }

    return _layoutManager;
}
 
- (NSTextContainer *)textContainer {
   if (!_textContainer) {
      _textContainer = [[NSTextContainer alloc] init];
      _textContainer.lineFragmentPadding = 0;
      _textContainer.maximumNumberOfLines = self.numberOfLines;
      _textContainer.lineBreakMode = self.lineBreakMode;
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
    NSRange glyphRange = [self.layoutManager
                          glyphRangeForTextContainer:self.textContainer];
    textOffset = [self textOffsetForGlyphRange:glyphRange];
  
    // Get the touch location and use text offset to convert to text cotainer coords
    location.x -= textOffset.x;
    location.y -= textOffset.y;
  
    NSUInteger glyphIndex = [self.layoutManager glyphIndexForPoint:location
                                         inTextContainer:self.textContainer];
  
    // If the touch is in white space after the last glyph on the line we don't
    // count it as a hit on the text
    NSRange lineRange;
    CGRect lineRect = [self.layoutManager lineFragmentUsedRectForGlyphAtIndex:glyphIndex
                                                              effectiveRange:&lineRange];
  
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

- (void)labelTouched:(WCLabel_TouchGestureRecognizer *)gesture {
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
           if (touchedUrlString && self.linkTappedBlock) {
               self.linkTappedBlock(touchedUrlString);
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

#pragma mark - NSLayoutManagerDelegate


@end
