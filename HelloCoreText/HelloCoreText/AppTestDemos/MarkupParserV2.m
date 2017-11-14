//
//  MarkupParserV2.m
//  HelloCoreText
//
//  Created by wesley_chen on 13/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "MarkupParserV2.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "CTSettings.h"

@interface MarkupParserV2 ()

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) NSMutableAttributedString *attrStringM;
@property (nonatomic, strong) NSMutableArray<NSDictionary<NSString *, id> *> *images;
@end

@implementation MarkupParserV2

- (instancetype)init {
    self = [super init];
    if (self) {
        _color = UIColor.blackColor;
        _fontName = @"Arial";
        _attrStringM = [[NSMutableAttributedString alloc] init];
        _images = [NSMutableArray array];
    }
    return self;
}

- (void)parseMarkup:(NSString *)markup {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIFont *defaultFont = [UIFont systemFontOfSize:screenSize.height / 40.0];
    
    self.attrStringM = [[NSMutableAttributedString alloc] initWithString:@""];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(.*?)(<[^>]+>|\\Z)" options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
    
    NSArray *chunks = [regex matchesInString:markup options:kNilOptions range:NSMakeRange(0, markup.length)];
    
    for (NSTextCheckingResult *result in chunks) {
        NSString *str = [markup substringWithRange:result.range];
        NSLog(@"str: %@", str);
        NSArray *parts = [str componentsSeparatedByString:@"<"];
        UIFont *font = [UIFont fontWithName:self.fontName size:screenSize.height / 40.0] ?: defaultFont;
        NSDictionary *attrs = @{
                                NSForegroundColorAttributeName: (self.color ?: UIColor.blackColor),
                                NSFontAttributeName: font,
                                };
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:parts[0] attributes:attrs];
        [self.attrStringM appendAttributedString:text];
        
        if (parts.count <= 1) {
            continue;
        }
        NSString *tag = parts[1];
        if ([tag hasPrefix:@"font"]) {
            NSRegularExpression *colorRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=color=\")\\w+" options:kNilOptions error:nil];
            [colorRegex enumerateMatchesInString:tag options:kNilOptions range:NSMakeRange(0, tag.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                NSString *colorSEL = [NSString stringWithFormat:@"%@Color", [tag substringWithRange:result.range]];
                self.color = [UIColor performSelector:NSSelectorFromString(colorSEL)];
            }];
            
            NSRegularExpression *faceRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=face=\")[^\"]+" options:kNilOptions error:nil];
            [faceRegex enumerateMatchesInString:tag options:kNilOptions range:NSMakeRange(0, tag.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                self.fontName = [tag substringWithRange:result.range];
            }];
        }
        else if ([tag hasPrefix:@"img"]) {
            __block NSString *filename = @"";
            NSRegularExpression *imageRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=src=\")[^\"]+" options:kNilOptions error:nil];
            [imageRegex enumerateMatchesInString:tag options:kNilOptions range:NSMakeRange(0, tag.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                filename = [tag substringWithRange:result.range];
            }];
            
            CTSettings *settings = [CTSettings new];
            CGFloat width = settings.columnRect.size.width;
            CGFloat height = 0;
            
            UIImage *image = [UIImage imageNamed:filename];
            height = width * (image.size.height / image.size.width);
            
            if (height > settings.columnRect.size.height - font.lineHeight) {
                height = settings.columnRect.size.height - font.lineHeight;
                width = height * (image.size.width / image.size.height);
            }
            
            [self.images addObject:@{
                                     @"width": @(width),
                                     @"height": @(height),
                                     @"filename": filename,
                                     @"location": @(self.attrStringM.length),
                                     }];
            
            NSDictionary *imageAttr = @{
                                        @"width": @(width),
                                        @"height": @(height),
                                        };
            
            CTRunDelegateCallbacks callbacks;
            callbacks.version = kCTRunDelegateVersion1;
            callbacks.getAscent = ascentCallback;
            callbacks.getDescent = descentCallback;
            callbacks.getWidth = widthCallback;
            callbacks.dealloc = deallocCallback;
            
            CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)imageAttr);
            NSDictionary *attrs = @{ (NSString *)kCTRunDelegateAttributeName: (__bridge id)delegate };
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@" " attributes:attrs];
            [self.attrStringM appendAttributedString:attrString];
        }
    }
    NSLog(@"%@", self.attrStringM);
}

/* Callbacks */
static void deallocCallback( void* ref ) {
    id obj = ((__bridge id)ref);
    obj = nil;
}
static CGFloat ascentCallback( void *ref ) {
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback( void *ref ) {
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"descent"] floatValue];
}
static CGFloat widthCallback( void* ref ) {
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

@end
