//
//  MarkupParserV1.m
//  HelloCoreText
//
//  Created by wesley_chen on 13/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "MarkupParserV1.h"
#import <UIKit/UIKit.h>

@interface MarkupParserV1 ()
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) NSMutableAttributedString *attrStringM;
@property (nonatomic, strong) NSDictionary<NSString *, id> *images;
@end

@implementation MarkupParserV1

- (instancetype)init {
    self = [super init];
    if (self) {
        _color = UIColor.blackColor;
        _fontName = @"Arial";
        _attrStringM = [[NSMutableAttributedString alloc] init];
        _images = [NSDictionary dictionary];
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
    }
    NSLog(@"%@", self.attrStringM);
}

@end
