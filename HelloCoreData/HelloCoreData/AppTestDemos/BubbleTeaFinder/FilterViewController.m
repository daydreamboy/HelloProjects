//
//  FilterViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 30/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "FilterViewController.h"
#import <CoreData/CoreData.h>

@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSPredicate *predicateCheapVenue;
@property (nonatomic, strong) NSPredicate *predicateModerateVenue;
@property (nonatomic, strong) NSPredicate *predicateExpensiveVenue;

@property (nonatomic, strong) NSPredicate *predicateOfferingDeal;
@property (nonatomic, strong) NSPredicate *predicateWalkingDistance;
@property (nonatomic, strong) NSPredicate *predicateHasUserTips;

@property (nonatomic, strong) NSSortDescriptor *sortDescriptorName;
@property (nonatomic, strong) NSSortDescriptor *sortDescriptorDistance;
@property (nonatomic, strong) NSSortDescriptor *sortDescriptorPrice;

@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray *cellTitles;

@end

@implementation FilterViewController

- (instancetype)initWithContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        _context = context;
        _sectionTitles = @[
                           @"PRICE",
                           @"MOST POPULAR",
                           @"SORT BY",
                           ];
        _cellTitles = @[
                        @[@"$", @"$$", @"$$$"],
                        @[@"Offering a deal", @"Within walking distance", @"Has User Tips"],
                        @[@"Name (A-Z)", @"Name (Z-A)", @"Distance", @"Price"]
                        ];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Filters";
    [self.view addSubview:self.tableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(searchItemClicked:)];
}

- (NSString *)priceCategoryLabelStringWithPredicate:(NSPredicate *)predicate {
    NSString *retVal = @"";
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Venue"];
    fetchRequest.predicate = predicate;
    
    // Note: Fetching counts instead of objects is mainly a performance optimization.
    if (predicate == self.predicateExpensiveVenue) {
        // Note: 1. use countForFetchRequest: method
        NSUInteger count = [self.context countForFetchRequest:fetchRequest error:nil];
        if (count != NSNotFound) {
            retVal = [NSString stringWithFormat:@"%ld bubble tea places", (long)count];
        }
    }
    else {
        // Note: 2. use @resultType
        fetchRequest.resultType = NSCountResultType;
        
        @try {
            NSArray<NSNumber *> *results = [self.context executeFetchRequest:fetchRequest error:nil];
            NSInteger count = [[results firstObject] integerValue];
            
            retVal = [NSString stringWithFormat:@"%ld bubble tea places", (long)count];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    
    return retVal;
}

- (NSString *)dealsCountLabelString {
    NSString *retVal = @"";
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Venue"];
    fetchRequest.resultType = NSDictionaryResultType; // Note: configure the fetch result is a NSDictionary
    
    NSExpressionDescription *sumExprDescription = [NSExpressionDescription new];
    sumExprDescription.name = @"sumDeals"; // Note: must give a name, so fetch the result by the name
    sumExprDescription.expression = [NSExpression expressionForFunction:@"sum:" arguments:@[[NSExpression expressionForKeyPath:@"specialCount"]]];
    sumExprDescription.expressionResultType = NSInteger32AttributeType; // Note: set result type of function `sum:`
    
    fetchRequest.propertiesToFetch = @[sumExprDescription];
    
    @try {
        NSArray<NSDictionary *> *results = [self.context executeFetchRequest:fetchRequest error:nil];
        NSDictionary *result = [results firstObject];
        NSInteger count = [result[@"sumDeals"] integerValue];
        
        retVal = [NSString stringWithFormat:@"%ld total deals", (long)count];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return retVal;
}

- (void)clearAllCheckmarkOfCellsAtSection:(NSInteger)section {
    NSInteger numberOfRows = [self tableView:self.tableView numberOfRowsInSection:section];
    for (NSInteger i = 0; i < numberOfRows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark - Getters

- (NSPredicate *)predicateCheapVenue {
    if (!_predicateCheapVenue) {
        _predicateCheapVenue = [NSPredicate predicateWithFormat:@"priceInfo.priceCategory == %@", @"$"];
    }
    
    return _predicateCheapVenue;
}

- (NSPredicate *)predicateModerateVenue {
    if (!_predicateModerateVenue) {
        _predicateModerateVenue = [NSPredicate predicateWithFormat:@"priceInfo.priceCategory == %@", @"$$"];
    }
    
    return _predicateModerateVenue;
}

- (NSPredicate *)predicateExpensiveVenue {
    if (!_predicateExpensiveVenue) {
        _predicateExpensiveVenue = [NSPredicate predicateWithFormat:@"priceInfo.priceCategory == %@", @"$$$"];
    }
    
    return _predicateExpensiveVenue;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableView = tableView;
    }
    
    return _tableView;
}

- (NSPredicate *)predicateOfferingDeal {
    if (!_predicateOfferingDeal) {
        _predicateOfferingDeal = [NSPredicate predicateWithFormat:@"specialCount > 0"];
    }
    
    return _predicateOfferingDeal;
}

- (NSPredicate *)predicateWalkingDistance {
    if (!_predicateWalkingDistance) {
        _predicateWalkingDistance = [NSPredicate predicateWithFormat:@"location.distance < 500"];
    }
    
    return _predicateWalkingDistance;
}

- (NSPredicate *)predicateHasUserTips {
    if (!_predicateHasUserTips) {
        _predicateHasUserTips = [NSPredicate predicateWithFormat:@"stats.tipCount > 0"];
    }
    
    return _predicateHasUserTips;
}

- (NSSortDescriptor *)sortDescriptorName {
    if (!_sortDescriptorName) {
        _sortDescriptorName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)];
    }
    
    return _sortDescriptorName;
}

- (NSSortDescriptor *)sortDescriptorDistance {
    if (!_sortDescriptorDistance) {
        _sortDescriptorDistance = [NSSortDescriptor sortDescriptorWithKey:@"location.distance" ascending:YES];
    }
    
    return _sortDescriptorDistance;
}

- (NSSortDescriptor *)sortDescriptorPrice {
    if (!_sortDescriptorPrice) {
        _sortDescriptorPrice = [NSSortDescriptor sortDescriptorWithKey:@"priceInfo.priceCategory" ascending:YES];
    }
    
    return _sortDescriptorPrice;
}

#pragma mark - Actions

- (void)cancelItemClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchItemClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(filterViewController:didSelectPredicate:sortDescriptor:)]) {
        [self.delegate filterViewController:self didSelectPredicate:self.selectedPredicate sortDescriptor:self.selectedSortDescriptor];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellTitles[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0: {
                    self.selectedPredicate = self.predicateCheapVenue;
                    break;
                }
                case 1: {
                    self.selectedPredicate = self.predicateModerateVenue;
                    break;
                }
                case 2: {
                    self.selectedPredicate = self.predicateExpensiveVenue;
                    break;
                }
                default:
                    break;
            }
        }
        else if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0: {
                    self.selectedPredicate = self.predicateOfferingDeal;
                    break;
                }
                case 1: {
                    self.selectedPredicate = self.predicateWalkingDistance;
                    break;
                }
                case 2: {
                    self.selectedPredicate = self.predicateHasUserTips;
                    break;
                }
                default:
                    break;
            }
        }
        
        // clear all cells's accessoryType at section 0
        [self clearAllCheckmarkOfCellsAtSection:0];
        
        // clear all cells's accessoryType at section 1
        [self clearAllCheckmarkOfCellsAtSection:1];
        
        UITableViewCell *selecedCell = [self.tableView cellForRowAtIndexPath:indexPath];
        selecedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: {
                self.selectedSortDescriptor = self.sortDescriptorName;
                break;
            }
            case 1: {
                self.selectedSortDescriptor = self.sortDescriptorName.reversedSortDescriptor;
                break;
            }
            case 2: {
                self.selectedSortDescriptor = self.sortDescriptorDistance;
                break;
            }
            case 3: {
                self.selectedSortDescriptor = self.sortDescriptorPrice;
                break;
            }
            default:
                break;
        }
        
        // clear all cells's accessoryType at section 2
        [self clearAllCheckmarkOfCellsAtSection:indexPath.section];
        
        UITableViewCell *selecedCell = [self.tableView cellForRowAtIndexPath:indexPath];
        selecedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier1 = @"FilterViewController_sCellIdentifier1";
    static NSString *sCellIdentifier2 = @"FilterViewController_sCellIdentifier2";
    UITableViewCell *cell = nil;
    
    if (indexPath.section < 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sCellIdentifier1];
        }
        
        NSString *detailText = @"";
        if (indexPath.section == 0 && indexPath.row == 0) {
            detailText = [self priceCategoryLabelStringWithPredicate:self.predicateCheapVenue];
        }
        else if (indexPath.section == 0 && indexPath.row == 1) {
            detailText = [self priceCategoryLabelStringWithPredicate:self.predicateModerateVenue];
        }
        else if (indexPath.section == 0 && indexPath.row == 2) {
            detailText = [self priceCategoryLabelStringWithPredicate:self.predicateExpensiveVenue];
        }
        else if (indexPath.section == 1 && indexPath.row == 0) {
            detailText = [self dealsCountLabelString];
        }
        
        cell.detailTextLabel.text = detailText;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier2];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier2];
        }
    }
    
    cell.textLabel.text = self.cellTitles[indexPath.section][indexPath.row];
    
    return cell;
}


@end
