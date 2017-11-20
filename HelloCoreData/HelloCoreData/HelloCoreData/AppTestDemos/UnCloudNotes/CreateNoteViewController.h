//
//  CreateNoteViewController.h
//  HelloCoreData
//
//  Created by wesley_chen on 12/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol CreateNoteViewControllerDelegate <NSObject>
- (void)viewControllerDidDismiss:(UIViewController *)viewController;
@end

@interface CreateNoteViewController : UIViewController
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, weak) id<CreateNoteViewControllerDelegate> delegate;
@end
