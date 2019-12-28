//
//  WCMacroKit.h
//  HelloJavaScriptCore
//
//  Created by wesley_chen on 2019/12/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#ifndef WCMacroKit_h
#define WCMacroKit_h

#define SHOW_ALERT(title, msg, cancel, dismissCompletion) \
\
do { \
    if ([UIAlertController class]) { \
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:(title) message:(msg) preferredStyle:UIAlertControllerStyleAlert]; \
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:(cancel) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { \
            dismissCompletion; \
        }]; \
        [alert addAction:cancelAction]; \
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil]; \
    } \
} while (0)

#endif /* WCMacroKit_h */