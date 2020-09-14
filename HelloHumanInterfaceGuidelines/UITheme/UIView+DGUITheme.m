//
//  UIView+DGUITheme.m
//  
//
//  Created by wesley chen on 2020/8/9.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "UIView+DGUITheme.h"
#import "DGUIThemeManager.h"
#import "DGUIThemeUtil.h"
#import "UIColor+DGUITheme.h"


@implementation UIView (DGUITheme)

QMUISynthesizeIdStrongProperty(dguiTheme_backgroundColor, setDguiTheme_backgroundColor)
QMUISynthesizeIdCopyProperty(dguiTheme_identifier, setDguiTheme_identifier)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ExtendImplementationOfNonVoidMethodWithSingleArgument([UIView class], @selector(initWithFrame:), CGRect, UIView *, ^UIView *(UIView *selfObject, CGRect frame, UIView *originReturnValue) {
            selfObject.dguiTheme_identifier = DGUIThemeManager.sharedManager.currentThemeIdentifier;
            return originReturnValue;
        });
        
        ExtendImplementationOfVoidMethodWithSingleArgument([UIView class], @selector(setBackgroundColor:), UIColor *, ^(UIView *selfObject, UIColor *color) {

                selfObject.dguiTheme_backgroundColor = color;
        });
        ExtendImplementationOfNonVoidMethodWithoutArguments([UIView class], @selector(backgroundColor), UIColor *, ^UIColor *(UIView *selfObject, UIColor *originReturnValue) {


                return selfObject.dguiTheme_backgroundColor ?: originReturnValue;
        });
        
        OverrideImplementation([UIView class], @selector(setHidden:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, BOOL firstArgv) {

                BOOL valueChanged = selfObject.hidden != firstArgv;

                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);

                if (!firstArgv && valueChanged && [NSThread currentThread].isMainThread) {
                    NSString *identifier = DGUIThemeManager.sharedManager.currentThemeIdentifier;
                    if(![selfObject.dguiTheme_identifier isEqualToString:identifier]) {
                         [selfObject dgui_themeDidChangeByProvider:DGUIThemeManager.sharedManager.themeProvider identifier:DGUIThemeManager.sharedManager.currentThemeIdentifier];
                    }
                }
            };
        });
        
        OverrideImplementation([UIView class], @selector(setAlpha:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, CGFloat firstArgv) {
                
                BOOL willShow = selfObject.alpha <= 0 && firstArgv > 0.01;
                
                void (*originSelectorIMP)(id, SEL, CGFloat);
                originSelectorIMP = (void (*)(id, SEL, CGFloat))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
                
                if (willShow && [NSThread currentThread].isMainThread) {
                    NSString *identifier = DGUIThemeManager.sharedManager.currentThemeIdentifier;
                    if(![selfObject.dguiTheme_identifier isEqualToString:identifier]) {
                         [selfObject dgui_themeDidChangeByProvider:DGUIThemeManager.sharedManager.themeProvider identifier:DGUIThemeManager.sharedManager.currentThemeIdentifier];
                    }
                }
            };
        });
        
       
        NSArray<Class> *classes = @[UIView.class,
                                    UICollectionView.class,
                                    UITextField.class,
                                    UISearchBar.class];
               [classes enumerateObjectsUsingBlock:^(Class  _Nonnull class, NSUInteger idx, BOOL * _Nonnull stop) {
                   OverrideImplementation([UIView class], @selector(didMoveToSuperview), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                       return ^(UIView *selfObject) {
                           
                           void (*originSelectorIMP)(id, SEL);
                           originSelectorIMP = (void (*)(id, SEL))originalIMPProvider();
                           originSelectorIMP(selfObject, originCMD);
                           
                           if([NSThread currentThread].isMainThread) {
                               if (selfObject._qmui_visible) {
                                   NSString *identifier = DGUIThemeManager.sharedManager.currentThemeIdentifier;
                                   if(![selfObject.dguiTheme_identifier isEqualToString:identifier]) {
                                        [selfObject dgui_themeDidChangeByProvider:DGUIThemeManager.sharedManager.themeProvider identifier:DGUIThemeManager.sharedManager.currentThemeIdentifier];
                                   }
                               }
                           }
                       };
                   });
               }];
    });
}


- (void)dgui_themeDidChangeByProvider:(NSObject<WCColorProvider> *)provider identifier:(__kindof NSString *)identifier {
    if ([self _qmui_visible]) {
        if(![self.dguiTheme_identifier isEqualToString:identifier]) {
            self.dguiTheme_identifier = identifier;
            [self _processThemeStyle];
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj dgui_themeDidChangeByProvider:DGUIThemeManager.sharedManager.themeProvider identifier:DGUIThemeManager.sharedManager.currentThemeIdentifier];
            }];
        }
    }
}


- (void)_processThemeStyle {
    
    if(self.backgroundColor.dgui_isDynamicColor) {
        self.backgroundColor = self.backgroundColor.copy;
    }

    if([self isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self;
        if(label.textColor.dgui_isDynamicColor) {
            [label setNeedsDisplay];
        }
    }
    
    if([self isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)self;
        if(textView.textColor.dgui_isDynamicColor) {
            [textView setNeedsDisplay];
        }
    }
    
    if([self isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)self;
        if(textField.textColor.dgui_isDynamicColor) {
            textField.attributedText = textField.attributedText;
        }
    }
    
}


- (BOOL)_qmui_visible {
    BOOL hidden = self.hidden;
    if ([self respondsToSelector:@selector(prepareForReuse)]) { /// collectionViewCell
        hidden = NO;
    }
    return !hidden && self.alpha > 0.01 && self.window;
}

@end
