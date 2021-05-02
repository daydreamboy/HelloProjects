//
//  ResultsTableController.h
//  HelloUISearchController
//
//  Created by wesley_chen on 2021/5/2.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResultsTableController : UIViewController
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) NSArray<Product *> *filteredProducts;
@property (nonatomic, strong) UILabel *resultsLabel;
@end

NS_ASSUME_NONNULL_END
