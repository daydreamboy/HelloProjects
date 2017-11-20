//
//  PagingFilterViewController.h
//  HelloCoreData
//
//  Created by wesley_chen on 30/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class PagingFilterViewController;

@protocol PagingFilterViewControllerDelegate <NSObject>

- (void)PagingFilterViewController:(PagingFilterViewController *)viewController didSelectPredicate:(NSPredicate *)predicate sortDescriptor:(NSSortDescriptor *)sortDescriptor;

@end

@interface PagingFilterViewController : BaseViewController

@property (nonatomic, weak) id<PagingFilterViewControllerDelegate> delegate;
@property (nonatomic, strong) NSSortDescriptor *selectedSortDescriptor;
@property (nonatomic, strong) NSPredicate *selectedPredicate;

- (instancetype)initWithContext:(NSManagedObjectContext *)context;
@end
