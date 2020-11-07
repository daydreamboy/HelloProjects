//
//  WCFontTool.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/27.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCFontTool.h"
#import "WCStringTool.h"

@implementation WCFontTool

+ (nullable UIFont *)adaptiveFontWithInitialFont:(UIFont *)initialFont minimumFontSize:(NSUInteger)minimumFontSize contrainedSize:(CGSize)contrainedSize mutilpleLines:(BOOL)mutilpleLines textString:(nullable NSString *)textString {
    
    UIFont *maximumFont = [self adaptiveMaximumFontWithInitialFont:initialFont minimumFontSize:minimumFontSize contrainedSize:contrainedSize mutilpleLines:mutilpleLines textString:textString];
    
    if (!maximumFont) {
        return nil;
    }
    
    if (maximumFont.pointSize < minimumFontSize) {
        return [UIFont fontWithDescriptor:initialFont.fontDescriptor size:minimumFontSize];
    }
    
    if (maximumFont.pointSize > initialFont.pointSize) {
        if (initialFont.pointSize < minimumFontSize) {
            return [UIFont fontWithDescriptor:initialFont.fontDescriptor size:minimumFontSize];
        }
        
        return initialFont;
    }
    
    return maximumFont;
}

+ (nullable UIFont *)adaptiveMaximumFontWithInitialFont:(UIFont *)initialFont minimumFontSize:(NSUInteger)minimumFontSize contrainedSize:(CGSize)contrainedSize mutilpleLines:(BOOL)mutilpleLines textString:(nullable NSString *)textString {
    if (![initialFont isKindOfClass:[UIFont class]]) {
        return nil;
    }
    
    if (textString && ![textString isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (minimumFontSize > 256) {
        return nil;
    }
    
    UIFont *tempFont = nil;
    UIFont *fittingFont = nil;
    NSString *testingString = textString ?: @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

    NSInteger tempMin = minimumFontSize;
    NSInteger tempMax = 256;
    NSInteger mid = 0;
    NSInteger difference = 0;

    while (tempMin <= tempMax) {
        mid = tempMin + (tempMax - tempMin) / 2;
        tempFont = [UIFont fontWithDescriptor:initialFont.fontDescriptor size:mid];
        
        CGSize textSize = mutilpleLines ? [WCStringTool textSizeWithMultipleLineString:testingString width:contrainedSize.width attributes:@{ NSFontAttributeName: tempFont} widthToFit:NO] : [WCStringTool textSizeWithSingleLineString:testingString font:tempFont];
        difference = contrainedSize.height - textSize.height;

        if (mid == tempMin || mid == tempMax) {
            if (difference < 0) {
                fittingFont = [UIFont fontWithDescriptor:initialFont.fontDescriptor size:(mid - 1)];
            }
            else {
                fittingFont = [UIFont fontWithDescriptor:initialFont.fontDescriptor size:mid];
            }
            
            break;
        }

        if (difference < 0) {
            tempMax = mid - 1;
        }
        else if (difference > 0) {
            tempMin = mid + 1;
        }
        else {
            fittingFont = [UIFont fontWithDescriptor:initialFont.fontDescriptor size:mid];
            break;
        }
    }

    return fittingFont;
}


@end
