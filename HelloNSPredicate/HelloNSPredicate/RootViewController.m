//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

#import "SubstitutionViewController.h"
#import "BasicComparisonViewController.h"
#import "BasicCompoundViewController.h"
#import "StringComparisonViewController.h"
#import "AggregateOperationViewController.h"
#import "NSCompoundPredicateViewController.h"
#import "NSComparisonPredicateViewController.h"
#import "BlockPredicateViewController.h"

@interface RootViewController ()

// section 1
@property (nonatomic, strong) NSArray *titles1;
@property (nonatomic, strong) NSArray *classes1;

// section 2
@property (nonatomic, strong) NSArray *titles2;
@property (nonatomic, strong) NSArray *classes2;

@end

@implementation RootViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [self prepareForInit];
    }
    
    return self;
}

- (void)prepareForInit {
    self.title = @"AppTest";

    // MARK: Configure titles and classes1 for table view
    _titles1 = @[
        @"use Substitutions (%@, %K, $VAR_NAME)",
        @"basic comparision (=, ==; >=, =>; <=, =<; >, <; !=, <>; BETWEEN)",
        @"basic compound (AND, &&; OR, ||; NOT, !)",
        @"string comparison (BEGINSWITH, CONTAINS, ENDSWITH, LIKE, MATCHES)",
        @"aggregation (ANY, SOME; ALL; NONE; IN; array[index]; array[FIRST]; array[LAST]; array[SIZE]); TRUEPREDICATE, FALSEPREDICATE",
        @"use NSCompoundPredicate for AND, OR, NOT",
        @"use NSComparisonPredicate with NSExpression",
        @"use block to predicate",
    ];
    _classes1 = @[
        @"SubstitutionViewController",
        @"BasicComparisonViewController",
        @"BasicCompoundViewController",
        @"StringComparisonViewController",
        @"AggregateOperationViewController",
        @"NSCompoundPredicateViewController",
        @"NSComparisonPredicateViewController",
        @"BlockPredicateViewController",
    ];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"use NSPredicate with Collections";
    }
    else if (section == 1) {
        return @"use NSPredicate with CoreData";
    }
    else {
        return @"<should never show>";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self pushViewControllerAtIndexPath:indexPath];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [_titles1 count];
    }
    else if (section == 1) {
        return [_titles2 count];
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"RootViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    if (indexPath.section == 0) {
        cell.textLabel.text = _titles1[indexPath.row];
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = _titles2[indexPath.row];
    }
    

    return cell;
}

- (void)pushViewControllerAtIndexPath:(NSIndexPath *)indexPath {
    NSString *viewControllerClass = nil;
    if (indexPath.section == 0) {
        viewControllerClass = _classes1[indexPath.row];
    }
    else if (indexPath.section == 1) {
        viewControllerClass = _classes2[indexPath.row];
    }
    
    if (!viewControllerClass) {
        return;
    }
    
    NSAssert([viewControllerClass isKindOfClass:[NSString class]], @"%@ is not NSString", viewControllerClass);
    
    Class class = NSClassFromString(viewControllerClass);
    if (class && [class isSubclassOfClass:[UIViewController class]]) {
        
        UIViewController *vc = [[class alloc] init];
        
        if (indexPath.section == 0) {
            vc.title = _titles1[[_classes1 indexOfObject:viewControllerClass]];
        }
        else if (indexPath.section == 1) {
            vc.title = _titles2[[_classes2 indexOfObject:viewControllerClass]];
        }
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        SEL selector = NSSelectorFromString(viewControllerClass);
        if ([self respondsToSelector:selector]) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:selector];
#pragma GCC diagnostic pop
        }
        else {
            NSAssert(NO, @"can't handle selector `%@`", viewControllerClass);
        }
    }
}

#pragma mark - Test Methods

- (void)testMethod {
    NSLog(@"test something");
}

@end
