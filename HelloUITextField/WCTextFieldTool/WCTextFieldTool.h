//
//  WCTextFieldTool.h
//  HelloUITextField
//
//  Created by wesley_chen on 2019/4/22.
//  Copyright © 2019 chenliang-xy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCTextFieldTool : NSObject

#pragma mark - NSRange/UITextRange Conversion

/**
 UITextRange to NSRange

 @param textRange the UITextRange
 @param textField the text field
 @return the NSRange
 @see http://stackoverflow.com/questions/9126709/create-uitextrange-from-nsrange
 */
+ (NSRange)NSRangeFromUITextRange:(UITextRange *)textRange forTextField:(UITextField *)textField;

/**
 NSRange to UITextRange

 @param range the NSRange
 @param textField the text field
 @return the UITextRange
 */
+ (UITextRange *)UITextRangeFromNSRange:(NSRange)range forTextField:(UITextField *)textField;

#pragma mark - Change Text Programatically

/**
 Change UITextField's text by programmatically and leave cursor stay in place

 @param textField the text field
 @param range the range to be replaced
 @param string the string to place
 @return return always NO, textField.text is changed, should NOT change it again
 @warning This method should be called in textField:shouldChangeCharactersInRange:replacementString: delegate method
 @see http://stackoverflow.com/questions/11157791/how-to-move-cursor-in-uitextfield-after-setting-its-value
 @see http://stackoverflow.com/questions/7305538/uitextfield-with-secure-entry-always-getting-cleared-before-editing
 */
+ (BOOL)changeTextWithTextField:(UITextField *)textField charactersInRange:(NSRange)range replacementString:(NSString *)string;

#pragma mark - Cursor Management

#pragma mark > Get selected range

/**
 Get the range of selected text or the cursor

 @param textField the text field
 @return the range of selected text or the cursor. Return (NSNotFound, 0) if no selected text or no cursor exists
 @see http://stackoverflow.com/questions/21149767/convert-selectedtextrange-uitextrange-to-nsrange
 */
+ (NSRange)selectedRangeWithTextField:(UITextField *)textField;

@end

NS_ASSUME_NONNULL_END
