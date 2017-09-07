//
//  FilterViewController.h
//  HelloCoreData
//
//  Created by wesley_chen on 30/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

- (void)filterViewController:(FilterViewController *)viewController didSelectPredicate:(NSPredicate *)predicate sortDescriptor:(NSSortDescriptor *)sortDescriptor;

@end

@interface FilterViewController : BaseViewController

@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;
@property (nonatomic, strong) NSSortDescriptor *selectedSortDescriptor;
@property (nonatomic, strong) NSPredicate *selectedPredicate;

- (instancetype)initWithContext:(NSManagedObjectContext *)context;
@end
