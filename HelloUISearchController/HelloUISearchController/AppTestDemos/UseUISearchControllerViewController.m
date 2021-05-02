//
//  UseUISearchControllerViewController.m
//  HelloUISearchController
//
//  Created by wesley_chen on 2021/5/2.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "UseUISearchControllerViewController.h"
#import "Product.h"
#import "ResultsTableController.h"

extern const struct LocalizationStruct
{
    __unsafe_unretained NSString *ginger;
    __unsafe_unretained NSString *gladiolus;
    __unsafe_unretained NSString *orchid;
    __unsafe_unretained NSString *geranium;
    __unsafe_unretained NSString *daisy;
    __unsafe_unretained NSString *poinsettiaRed;
    __unsafe_unretained NSString *poinsettiaPink;
    __unsafe_unretained NSString *redRose;
    __unsafe_unretained NSString *whiteRose;
    __unsafe_unretained NSString *tulip;
    __unsafe_unretained NSString *carnationRed;
    __unsafe_unretained NSString *carnationWhite;
    __unsafe_unretained NSString *sunFlower;
    __unsafe_unretained NSString *gardenia;
    __unsafe_unretained NSString *daffodil;
} Localization;

const struct LocalizationStruct Localization =
{
    .ginger = @"GingerTitle",
    .gladiolus = @"Gladiolus",
    .orchid = @"Orchid",
    .geranium = @"Geranium",
    .daisy = @"Daisy",
    .poinsettiaRed = @"Poinsettia Red",
    .poinsettiaPink = @"Poinsettia Pink",
    .redRose = @"Red Rose",
    .whiteRose = @"White Rose",
    .tulip = @"Tulip",
    .carnationRed = @"Carnation Red",
    .carnationWhite = @"Carnation White",
    .sunFlower = @"Sunflower",
    .gardenia = @"Gardenia",
    .daffodil = @"Daffodil",
};

@interface UseUISearchControllerViewController () <UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>
@property (nonatomic, strong) NSArray<Product *> *products;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) ResultsTableController *resultsTableController;
@end

@implementation UseUISearchControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
        // Note: make the search bar always visible.
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
    }
    else {
        // Fallback on earlier versions
    }
    
    /**
     Note: specify that this view controller determines how the search controller is presented.
     The search controller should be presented modally and match the physical size of this view controller.
    */
    self.definesPresentationContext = YES;
    
    [self setupDataSource];
}

#pragma mark - Getter

- (UISearchController *)searchController {
    if (!_searchController) {
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
        searchController.delegate = self;
        searchController.searchResultsUpdater = self;
        searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        searchController.dimsBackgroundDuringPresentation = NO;
        searchController.searchBar.delegate = self; // Monitor when the search button is tapped.
        searchController.searchBar.scopeButtonTitles = @[
            [Product productTypeNameWithType:ProductTypeAll],
            [Product productTypeNameWithType:ProductTypeBirthdays],
            [Product productTypeNameWithType:ProductTypeWeddings],
            [Product productTypeNameWithType:ProductTypeFunerals],
        ];
        
        _searchController = searchController;
    }
    
    return _searchController;
}

- (ResultsTableController *)resultsTableController {
    if (!_resultsTableController) {
        ResultsTableController *vc = [[ResultsTableController alloc] init];
        vc.tableView.delegate = self;
        
        _resultsTableController = vc;
    }
    
    return _resultsTableController;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.searchController.searchBar.scopeButtonTitles count] - 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numInSection = 0;
    switch (section) {
        case 0:
            numInSection = [self quantityWithType:ProductTypeBirthdays];
            break;
        case 1:
            numInSection = [self quantityWithType:ProductTypeWeddings];
            break;
        case 2:
            numInSection = [self quantityWithType:ProductTypeFunerals];
            break;
        default:
            break;
    }
    
    return numInSection;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    switch (section) {
        case 0:
            title = [Product productTypeNameWithType:ProductTypeBirthdays];
            break;
        case 1:
            title = [Product productTypeNameWithType:ProductTypeWeddings];
        case 2:
            title = [Product productTypeNameWithType:ProductTypeFunerals];
        default:
            break;
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"UseUISearchControllerViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    Product *cellProduct = [self productAtIndexPath:indexPath];

    cell.textLabel.text = cellProduct.title;

    NSString *priceString = [cellProduct formattedIntroPrice];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@", priceString, @(cellProduct.yearIntroduced)];
    
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // Update the filtered array based on the search text.
    NSArray *searchResults = self.products;

    // Strip out all the leading and trailing spaces.
    NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *strippedString = [searchController.searchBar.text stringByTrimmingCharactersInSet:whitespaceCharacterSet];
    NSArray<NSString *> *searchItems = [strippedString componentsSeparatedByString:@" "];

    NSMutableArray<NSPredicate *> *andMatchPredicates = [NSMutableArray array];
    // Build all the "AND" expressions for each value in searchString.
    [searchItems enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [andMatchPredicates addObject:[self findMatchesWithSearchString:obj]];
    }];

    // Match up the fields of the Product object.
    NSCompoundPredicate *finalCompoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    
    NSArray *filteredResults = [searchResults filteredArrayUsingPredicate:finalCompoundPredicate];

    // Apply the filtered results to the search results table.
    ResultsTableController *resultsController = (ResultsTableController *)self.searchController.searchResultsController;
    if ([resultsController isKindOfClass:[ResultsTableController class]]) {
        resultsController.filteredProducts = filteredResults;
        [resultsController.tableView reloadData];
        
        resultsController.resultsLabel.text = resultsController.filteredProducts.count == 0
        ? NSLocalizedString(@"NoItemsFoundTitle", @"")
        : [NSString stringWithFormat: NSLocalizedString(@"Items found: %ld", @""), resultsController.filteredProducts.count];
    }
}

#pragma mark - Utility

- (NSInteger)quantityWithType:(ProductType)type {
    NSInteger quantity = 0;
    for (Product *product in self.products) {
        if (product.type == type) {
            quantity += 1;
        }
    }
    return quantity;
}

- (NSCompoundPredicate *)findMatchesWithSearchString:(NSString *)searchString {
    /**
     Each searchString creates an OR predicate for: name, yearIntroduced, introPrice.
     Example if searchItems contains "Gladiolus 51.99 2001":
            name CONTAINS[c] "gladiolus"
            name CONTAINS[c] "gladiolus", yearIntroduced ==[c] 2001, introPrice ==[c] 51.99
            name CONTAINS[c] "ginger", yearIntroduced ==[c] 2007, introPrice ==[c] 49.98
    */
    
    NSMutableArray<NSPredicate *> *searchItemsPredicate = [NSMutableArray array];
    
    /** Below we use NSExpression represent expressions in our predicates.
        NSPredicate is made up of smaller, atomic parts:
        two NSExpressions (a left-hand value and a right-hand value).
    */
    
    // Product title matching.
    NSExpression *titleExpression = [NSExpression expressionForKeyPath:ProductExpressionKeys.title];
    NSExpression *searchStringExpression = [NSExpression expressionForConstantValue:searchString];
    
    NSComparisonPredicate *titleSearchComparisonPredicate = [NSComparisonPredicate predicateWithLeftExpression:titleExpression rightExpression:searchStringExpression modifier:NSDirectPredicateModifier type:NSContainsPredicateOperatorType options:NSCaseInsensitivePredicateOption | NSDiacriticInsensitivePredicateOption];
    [searchItemsPredicate addObject:titleSearchComparisonPredicate];
    
    // The `searchString` may fail to convert to a number.
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterNoStyle;
    numberFormatter.formatterBehavior = NSNumberFormatterBehaviorDefault;
    
    NSNumber *targetNumber = [numberFormatter numberFromString:searchString];
    if (targetNumber) {
        // Use `targetNumberExpression` in both the following predicates.
        NSExpression *targetNumberExpression = [NSExpression expressionForConstantValue:targetNumber];
        
        // The `yearIntroduced` field matching.
        NSExpression *yearIntroducedExpression = [NSExpression expressionForKeyPath:ProductExpressionKeys.yearIntroduced];
        NSComparisonPredicate *yearIntroducedPredicate = [NSComparisonPredicate predicateWithLeftExpression:yearIntroducedExpression rightExpression:targetNumberExpression modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:NSCaseInsensitivePredicateOption | NSDiacriticInsensitivePredicateOption];
        
        [searchItemsPredicate addObject:yearIntroducedPredicate];
        
        // The `price` field matching.
    
        NSExpression *introPriceExpression = [NSExpression expressionForKeyPath:ProductExpressionKeys.introPrice];
        NSComparisonPredicate *introPricePredicate = [NSComparisonPredicate predicateWithLeftExpression:introPriceExpression rightExpression:targetNumberExpression modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:NSCaseInsensitivePredicateOption | NSDiacriticInsensitivePredicateOption];
        
        [searchItemsPredicate addObject:introPricePredicate];
    }
    

    NSCompoundPredicate *finalCompoundPredicate;

    // Handle the scoping.
    NSInteger selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex;
    if (selectedScopeButtonIndex > 0) {
        // We have a scope type to narrow our search further.
        if (searchItemsPredicate.count > 0) {
            /** We have a scope type and other fields to search on -
                so match up the fields of the Product object AND its product type.
            */
            NSPredicate *compPredicate1 = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
            NSPredicate *compPredicate2 = [NSPredicate predicateWithFormat:@"SELF.type == %ld", selectedScopeButtonIndex];

            finalCompoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[compPredicate1, compPredicate2]];
        }
        else {
            // Match up by product scope type only.
            finalCompoundPredicate = (NSCompoundPredicate *)[NSCompoundPredicate predicateWithFormat:@"SELF.type == %ld", selectedScopeButtonIndex];
        }
    }
    else {
        // No scope type specified, just match up the fields of the Product object
        finalCompoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
    }

    //Swift.debugPrint("search predicate = \(String(describing: finalCompoundPredicate))")
    return finalCompoundPredicate;
}

#pragma mark - DataSource

- (Product *)productAtIndexPath:(NSIndexPath *)indexPath {
    Product *product;
            
    NSInteger quantityForBirthdays = [self quantityWithType:ProductTypeBirthdays];

    // The table section index matches the product type.
    switch (indexPath.section) {
        case ProductTypeBirthdays - 1: {
            product = self.products[indexPath.row];
            break;
        }
        case ProductTypeWeddings - 1: {
            product = self.products[indexPath.row + quantityForBirthdays];
            break;
        }
        case ProductTypeFunerals - 1: {
            NSInteger quantityForWeddings = [self quantityWithType:ProductTypeWeddings];
            product = self.products[indexPath.row + quantityForBirthdays + quantityForWeddings];
            break;
        }
        default:
            break;
    }
    
    return product;
}

- (void)setupDataSource {
    self.products = @[
        [[Product alloc] initWithTitle:Localization.ginger yearIntroduced:2007 introPrice:48.98 type:ProductTypeBirthdays],
        [[Product alloc] initWithTitle:Localization.gladiolus yearIntroduced:2001 introPrice:51.99 type:ProductTypeBirthdays],
        [[Product alloc] initWithTitle:Localization.orchid yearIntroduced:2007 introPrice:16.99 type:ProductTypeBirthdays],
        [[Product alloc] initWithTitle:Localization.geranium yearIntroduced:2006 introPrice:16.99 type:ProductTypeBirthdays],
        [[Product alloc] initWithTitle:Localization.daisy yearIntroduced:2006 introPrice:16.99 type:ProductTypeBirthdays],
        
        [[Product alloc] initWithTitle:Localization.tulip yearIntroduced:1997 introPrice:39.99 type:ProductTypeWeddings],
        [[Product alloc] initWithTitle:Localization.carnationRed yearIntroduced:2006 introPrice:23.99 type:ProductTypeWeddings],
        [[Product alloc] initWithTitle:Localization.carnationWhite yearIntroduced:2007 introPrice:23.99 type:ProductTypeWeddings],
        [[Product alloc] initWithTitle:Localization.sunFlower yearIntroduced:2008 introPrice:25.00 type:ProductTypeWeddings],
        [[Product alloc] initWithTitle:Localization.gardenia yearIntroduced:2006 introPrice:25.00 type:ProductTypeWeddings],
        [[Product alloc] initWithTitle:Localization.daffodil yearIntroduced:2008 introPrice:24.99 type:ProductTypeWeddings],
        
        [[Product alloc] initWithTitle:Localization.poinsettiaRed yearIntroduced:2010 introPrice:31.99 type:ProductTypeFunerals],
        [[Product alloc] initWithTitle:Localization.poinsettiaPink yearIntroduced:2011 introPrice:31.99 type:ProductTypeFunerals],
        [[Product alloc] initWithTitle:Localization.redRose yearIntroduced:2010 introPrice:24.99 type:ProductTypeFunerals],
        [[Product alloc] initWithTitle:Localization.whiteRose yearIntroduced:2012 introPrice:24.99 type:ProductTypeFunerals],
    ];
}

@end
