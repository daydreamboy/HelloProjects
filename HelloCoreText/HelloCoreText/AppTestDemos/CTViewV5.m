//
//  CTViewV5.m
//  HelloCoreText
//
//  Created by wesley_chen on 14/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "CTViewV5.h"
#import <CoreText/CoreText.h>
#import "CTSettings.h"
#import "CTColumnViewV2.h"

@interface CTViewV5 ()
@property (nonatomic, assign) NSInteger imageIndex;
@end

@implementation CTViewV5

- (void)buildFramesWithAttrString:(NSAttributedString *)attrString images:(NSArray<NSDictionary<NSString *, id> *> *)images {
    self.pagingEnabled = YES;
    self.imageIndex = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    
    UIView *pageView = [[UIView alloc] initWithFrame:CGRectZero];
    NSInteger textPos = 0;
    NSInteger columnIndex = 0;
    NSInteger pageIndex = 0;
    
    CTSettings *settings = [CTSettings new];
    
    while (textPos < attrString.length) {
        if (columnIndex % settings.columnPerPage == 0) {
            columnIndex = 0;
            CGRect rect = CGRectOffset(settings.pageRect, pageIndex * self.bounds.size.width, 0);
            
            pageView = [[UIView alloc] initWithFrame:rect];
            [self addSubview:pageView];
            pageIndex += 1;
        }
        
        CGFloat columnXOrigin = pageView.frame.size.width / settings.columnPerPage;
        CGFloat columnOffset = columnIndex * columnXOrigin;
        CGRect columnFrame = CGRectOffset(settings.columnRect, columnOffset, 0);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, columnFrame.size.width, columnFrame.size.height));
        
        CTFrameRef ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        
        CTColumnViewV2 *columnView = [[CTColumnViewV2 alloc] initWithFrame:columnFrame CTFrame:ctFrame];
        if (images.count > self.imageIndex) {
            [self attachImages:images toCTFrame:ctFrame margin:settings.margin columnView:columnView];
        }
        
        [pageView addSubview:columnView];
        
        CFRange frameRange = CTFrameGetVisibleStringRange(ctFrame);
        textPos += frameRange.length;
        
        columnIndex += 1;
    }
    
    self.contentSize = CGSizeMake(pageIndex * self.bounds.size.width, self.bounds.size.height);
}

- (void)attachImages:(NSArray *)images toCTFrame:(CTFrameRef)ctFrame margin:(CGFloat)margin columnView:(CTColumnViewV2 *)columnView {
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CFIndex count = CFArrayGetCount(lines);
    CGPoint origins[count];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), origins);
    NSDictionary *nextImage = images[self.imageIndex];
    
    if (!nextImage[@"location"]) {
        return;
    }
    NSInteger imgLocation = [nextImage[@"location"] integerValue];
    
    for (NSInteger lineIndex = 0; lineIndex < count; lineIndex++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        CFArrayRef glyphRuns = CTLineGetGlyphRuns(line);
        CFIndex countOfGlyphRuns = CFArrayGetCount(glyphRuns);
        NSString *imageFilename = nextImage[@"filename"];
        UIImage *image = [UIImage imageNamed:imageFilename];
        
        for (NSInteger i = 0; i < countOfGlyphRuns; i++) {
            CTRunRef run = CFArrayGetValueAtIndex(glyphRuns, i);
            CFRange runRange = CTRunGetStringRange(run);
            if (runRange.location > imgLocation || runRange.location + runRange.length <= imgLocation) {
                continue;
            }
            CGRect imgBounds = CGRectZero;
            CGFloat ascent = 0;
            imgBounds.size.width = (CGFloat)CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, NULL, NULL);
            imgBounds.size.height = ascent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, runRange.location , NULL);
            imgBounds.origin.x = origins[lineIndex].x + xOffset;
            imgBounds.origin.y = origins[lineIndex].y;
            
            [columnView.images addObject:@[ image, NSStringFromCGRect(imgBounds) ]];
            self.imageIndex += 1;
            
            if (self.imageIndex < images.count) {
                nextImage = images[self.imageIndex];
                imgLocation = [nextImage[@"location"] integerValue];
            }
        }
    }
}

@end
