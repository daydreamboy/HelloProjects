//
//  WCMacroTool.h
//  HelloNSException
//
//  Created by wesley_chen on 2020/5/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#ifndef WCMacroTool_h
#define WCMacroTool_h

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

#endif /* WCMacroTool_h */
