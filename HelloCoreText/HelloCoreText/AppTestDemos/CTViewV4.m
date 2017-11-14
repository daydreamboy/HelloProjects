//
//  CTViewV4.m
//  HelloCoreText
//
//  Created by wesley_chen on 13/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "CTViewV4.h"
#import <CoreText/CoreText.h>
#import "CTSettings.h"
#import "CTColumnViewV1.h"

@interface CTViewV4 ()
@end

@implementation CTViewV4

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)buildFramesWithAttrString:(NSAttributedString *)attrString images:(NSDictionary<NSString *, id> *)images {
    self.pagingEnabled = YES;
    
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
        
        CTColumnViewV1 *columnView = [[CTColumnViewV1 alloc] initWithFrame:columnFrame CTFrame:ctFrame];
        [pageView addSubview:columnView];
        
        CFRange frameRange = CTFrameGetVisibleStringRange(ctFrame);
        textPos += frameRange.length;
        
        columnIndex += 1;
    }
    
    self.contentSize = CGSizeMake(pageIndex * self.bounds.size.width, self.bounds.size.height);
}

@end
