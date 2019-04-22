//
//  WCTextFieldTool.m
//  HelloUITextField
//
//  Created by wesley_chen on 2019/4/22.
//  Copyright © 2019 chenliang-xy. All rights reserved.
//

#import "WCTextFieldTool.h"

@implementation WCTextFieldTool

#pragma mark - NSRange/UITextRange Conversion

+ (NSRange)NSRangeFromUITextRange:(UITextRange *)textRange forTextField:(UITextField *)textField {
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *start = textField.selectedTextRange.start;
    UITextPosition *end = textField.selectedTextRange.end;
    
    NSInteger location = [textField offsetFromPosition:beginning toPosition:start];
    NSInteger length = [textField offsetFromPosition:start toPosition:end];
    
    NSRange range = NSMakeRange(location, length);
    
    return range;
}

+ (UITextRange *)UITextRangeFromNSRange:(NSRange)range forTextField:(UITextField *)textField {
    UITextPosition *beginning = textField.beginningOfDocument;
    
    UITextPosition *start = [textField positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textField positionFromPosition:start offset:range.length];
    
    UITextRange *textRange = [textField textRangeFromPosition:start toPosition:end];
    
    return textRange;
}

#pragma mark - Change Text Programatically

+ (BOOL)changeTextWithTextField:(UITextField *)textField charactersInRange:(NSRange)range replacementString:(NSString *)string {
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *start = [textField positionFromPosition:beginning offset:range.location];
    
    // this will be the new cursor location after insert/paste/typing
    NSInteger cursorOffset = [textField offsetFromPosition:beginning toPosition:start] + string.length;
    
    // now apply the text changes that were typed or pasted in to the text field
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    UITextPosition *newCursorPosition = [textField positionFromPosition:textField.beginningOfDocument offset:cursorOffset];
    UITextRange *newSelectedRange = [textField textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
    [textField setSelectedTextRange:newSelectedRange];
    
    return NO;
}

#pragma mark - Cursor Management

#pragma mark > Get selected range

+ (NSRange)selectedRangeWithTextField:(UITextField *)textField {
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextRange *selectedRange = textField.selectedTextRange;
    
    if (beginning && selectedRange) {
        UITextPosition *selectionStart = selectedRange.start;
        UITextPosition *selectionEnd = selectedRange.end;
        
        const NSInteger location = [textField offsetFromPosition:beginning toPosition:selectionStart];
        const NSInteger length = [textField offsetFromPosition:selectionStart toPosition:selectionEnd];
        
        return NSMakeRange(location, length);
    }
    else {
        return NSMakeRange(NSNotFound, 0);
    }
}

@end
