//
//  WCLinkLabel_GestureRecognizer.m
//  HelloUILabel
//
//  Created by wesley_chen on 2020/11/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCLinkLabel_GestureRecognizer.h"

@implementation WCLinkLabel_GestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   self.state = UIGestureRecognizerStateBegan;
}
 
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
   self.state = UIGestureRecognizerStateChanged;
}
 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
   self.state = UIGestureRecognizerStateEnded;
}
 
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
   self.state = UIGestureRecognizerStateCancelled;
}

@end
