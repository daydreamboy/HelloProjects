//
//  JournalEntryViewController.h
//  HelloCoreData
//
//  Created by wesley_chen on 28/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JournalEntryViewController;

@protocol JournalEntryViewControllerDelegate <NSObject>
- (void)viewControllerDidFinish:(JournalEntryViewController *)viewController saved:(BOOL)saved;
@end

@interface JournalEntryViewController : UIViewController
@property (nonatomic, weak) id<JournalEntryViewControllerDelegate> delegate;
@end
