//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

// section 1
#import "PlainTableViewViewController.h"
#import "GroupedTableViewViewController.h"

// section 2
#import "CompatiblePlainTableViewViewController.h"
#import "CompatibleGroupedTableViewViewController.h"

// section 3
#import "MoveMeViewController.h"
#import "DeleteMeViewController.h"
#import "SelectMeViewController.h"
#import "InsertMeViewController.h"
#import "CombineInsertionAndDeletionViewController.h"

// section 4
#import "FadeInCellRowByRowViewController.h"
#import "ScrollTopBottomCellsToFadeInViewController.h"
#import "PlainTableViewRemoveRedundantSeparatorsViewController.h"
#import "PlainTableViewWithFullSeparatorsViewController.h"
#import "TableViewHeaderWithExtendedViewViewController.h"
#import "PlainTableViewWithNonFloatSectionViewController.h"
#import "PlainTableViewWithExpandableSectionHeaderViewController.h"
#import "DetectUserScrollViewController.h"
#import "HorizontalTableViewViewController.h"
#import "LoadMoreFromBottomViewController.h"
#import "LoadMoreFromTopViewController.h"
#import "ShowContextMenuInCellViewController.h"
#import "ShowEmptyTipViewInUITableViewViewController.h"
#import "CustomizeSelectMeViewController.h"
#import "DetectCellOffscreenViewController.h"
#import "CustomizeHighlightCellViewController.h"
#import "CheckNumberOfCellOnFirstRenderViewController.h"
#import "TintSystemCheckmarkCellViewController.h"
#import "GroupedSingleSectionViewController.h"
#import "IndexedTableViewViewController.h"
#import "SearchBarTableViewViewController.h"
#import "IndexedSearchBarTableViewViewController.h"
#import "CustomizedIndexedTableViewViewController.h"

// section 5
#import "StaticCellHeightAboveiOS11IssuesViewController.h"
#import "ReloadRowsWithEmptyListViewController.h"
#import "CallReloadDataInsideCellForRowAtIndexPathViewController.h"
#import "CellContentIssueAboveiOS14ViewController.h"
#import "TableViewHeaderIssueCircularCallViewController.h"
#import "TableViewBeginEndUpdatesNotPairedViewController.h"
#import "TableViewEndUpdatesExceptionViewController.h"

#define kTitle @"Title"
#define kClass @"Class"

@interface RootViewController ()
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray<NSArray<NSDictionary *> *> *classes;
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
    
    // MARK: Configure sectionTitles and classes for table view
    NSArray<NSDictionary *> *section1 = @[
          @{ kTitle: @"Plain UITableView", kClass: [PlainTableViewViewController class] },
          @{ kTitle: @"Grouped UITableView", kClass: [GroupedTableViewViewController class] },
    ];

    NSArray<NSDictionary *> *section2 = @[
          @{ kTitle: @"Compatible Plain UITableView", kClass: [CompatiblePlainTableViewViewController class] },
          @{ kTitle: @"Compatible Grouped UITableView", kClass: [CompatibleGroupedTableViewViewController class] },
    ];
    
    NSArray<NSDictionary *> *section3 = @[
          @{ kTitle: @"Move Me", kClass: [MoveMeViewController class] },
          @{ kTitle: @"Delete Me", kClass: [DeleteMeViewController class] },
          @{ kTitle: @"Select Me", kClass: [SelectMeViewController class] },
          @{ kTitle: @"Insert Me", kClass: [InsertMeViewController class] },
          @{ kTitle: @"Combine insertion and deletion", kClass: [CombineInsertionAndDeletionViewController class] },
    ];
    
    NSArray<NSDictionary *> *section4 = @[
          @{ kTitle: @"Fade in cell row by row", kClass: [FadeInCellRowByRowViewController class] },
          @{ kTitle: @"Scroll cells out with fade in", kClass: [ScrollTopBottomCellsToFadeInViewController class] },
          @{ kTitle: @"Remove redundant separators for plain table view", kClass: [PlainTableViewRemoveRedundantSeparatorsViewController class] },
          @{ kTitle: @"Compatible full separators for plain table view", kClass: [PlainTableViewWithFullSeparatorsViewController class] },
          @{ kTitle: @"Table header view with extended view", kClass: [TableViewHeaderWithExtendedViewViewController class] },
          @{ kTitle: @"Plain Table with non-float section view", kClass: [PlainTableViewWithNonFloatSectionViewController class] },
          @{ kTitle: @"Plain Table with expandable section header", kClass: [PlainTableViewWithExpandableSectionHeaderViewController class] },
          @{ kTitle: @"Detect user scrolling", kClass: [DetectUserScrollViewController class] },
          @{ kTitle: @"Horizontal table view", kClass: [HorizontalTableViewViewController class] },
          @{ kTitle: @"Table view load more from bottom", kClass: [LoadMoreFromBottomViewController class] },
          @{ kTitle: @"Table view load more from top", kClass: [LoadMoreFromTopViewController class] },
          @{ kTitle: @"Show context menu in cell", kClass: [ShowContextMenuInCellViewController class] },
          @{ kTitle: @"Show empty tip in table view", kClass: [ShowEmptyTipViewInUITableViewViewController class] },
          @{ kTitle: @"Customize select mode of table view", kClass: [CustomizeSelectMeViewController class] },
          @{ kTitle: @"Detect cell offscreen event", kClass: [DetectCellOffscreenViewController class] },
          @{ kTitle: @"Check number of cell on first render", kClass: [CheckNumberOfCellOnFirstRenderViewController class] },
          @{ kTitle: @"Customize highlight cell", kClass: [CustomizeHighlightCellViewController class] },
          @{ kTitle: @"Tint system checkmark cell", kClass: [TintSystemCheckmarkCellViewController class] },
          @{ kTitle: @"Grouped single section", kClass: [GroupedSingleSectionViewController class] },
          @{ kTitle: @"Indexed table view", kClass: [IndexedTableViewViewController class] },
          @{ kTitle: @"SearchBar table view", kClass: [SearchBarTableViewViewController class] },
          @{ kTitle: @"Indexed searchable table view", kClass: [IndexedSearchBarTableViewViewController class] },
          @{ kTitle: @"Customized indexed table view", kClass: [CustomizedIndexedTableViewViewController class] },
    ];
    
    NSArray<NSDictionary *> *section5 = @[
          @{ kTitle: @"Static cell height iOS11+", kClass: [StaticCellHeightAboveiOS11IssuesViewController class] },
          @{ kTitle: @"Reload rows with empty list", kClass: [ReloadRowsWithEmptyListViewController class] },
          @{ kTitle: @"Cell content issue iOS14+", kClass: [CellContentIssueAboveiOS14ViewController class] },
          @{ kTitle: @"Test", kClass: [CallReloadDataInsideCellForRowAtIndexPathViewController class] },
          @{ kTitle: @"TableViewHeader circular call", kClass: [TableViewHeaderIssueCircularCallViewController class] },
          @{ kTitle: @"TableView begin/endUpdates not paired", kClass: [TableViewBeginEndUpdatesNotPairedViewController class] },
          @{ kTitle: @"TableView endUpdates exception", kClass: [TableViewEndUpdatesExceptionViewController class] },
    ];
    
    NSArray<NSDictionary *> *section6 = @[
          // TODO
    ];
    
    _sectionTitles = @[
        @"System Default TableViews",
        @"System Compatible TableViews (both iOS 10- and iOS 11+)",
        @"System Editable TableViews",
        @"UITableView customizations",
        @"UITableView issues",
        @"WCTableView",
    ];
    
    _classes = @[
         section1,
         section2,
         section3,
         section4,
         section5,
         section6,
    ];
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = _classes[indexPath.section][indexPath.row];
    [self pushViewController:dict];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionTitles[section];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_classes count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_classes[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"RootViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *cellTitle = [_classes[indexPath.section][indexPath.row] objectForKey:kTitle];
    cell.textLabel.text = cellTitle;
    
    return cell;
}

- (void)pushViewController:(NSDictionary *)dict {
    id viewControllerClass = dict[kClass];
    
    id class = viewControllerClass;
    if ([class isKindOfClass:[NSString class]]) {
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
    else if (class && [class isSubclassOfClass:[UIViewController class]]) {
        UIViewController *vc = [[class alloc] init];
        vc.title = dict[kTitle];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Test Methods

- (void)testMethod {
    NSLog(@"test something");
}

@end
