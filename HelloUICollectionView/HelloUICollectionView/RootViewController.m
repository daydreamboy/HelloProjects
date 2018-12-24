//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

#import "FlowLayoutViewController.h"
#import "CustomCollectionViewCellViewController.h"
#import "PagableCollectionViewViewController.h"
#import "DifferentSizeCellViewController.h"
#import "SeparatorsBetweenCell1ViewController.h"
#import "SeparatorsBetweenCell2ViewController.h"
#import "CellSelectionAndHighlightViewController.h"
#import "UseWCHorizontalPageBrowserViewControllerViewController.h"
#import "SupplementaryViewOfSectionViewController.h"
#import "UseWCCrossDirectionEmotionPickerViewViewController.h"
#import "ManyRoundedImageViewViewController.h"
#import "DraggableLayoutViewController.h"
#import "AutoFitHeightCollectionViewViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *classes;
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

    // MARK: Configure titles and classes for table view
    _titles = @[
        @"Flow layout (horizontal/vertical)",
        @"Custom UICollectionViewCell",
        @"Pagable UICollectionView",
        @"Different size cells",
        @"Separators between cells (solution 1)",
        @"Separators between cells (solution 2)",
        @"Cell highlight and selection",
        @"Supplementary view of section",
        @"Horizontal page browser",
        @"Use WCCrossDirectionEmotionPickerView",
        @"Many rounded image view in UICollectionView",
        @"Drag cell",
        @"Auto fit content height",
    ];
    _classes = @[
        [FlowLayoutViewController class],
        [CustomCollectionViewCellViewController class],
        [PagableCollectionViewViewController class],
        [DifferentSizeCellViewController class],
        [SeparatorsBetweenCell1ViewController class],
        [SeparatorsBetweenCell2ViewController class],
        [CellSelectionAndHighlightViewController class],
        [SupplementaryViewOfSectionViewController class],
        [UseWCHorizontalPageBrowserViewControllerViewController class],
        [UseWCCrossDirectionEmotionPickerViewViewController class],
        [ManyRoundedImageViewViewController class],
        [DraggableLayoutViewController class],
        [AutoFitHeightCollectionViewViewController class],
    ];
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushViewController:_classes[indexPath.row]];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"RootViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = _titles[indexPath.row];

    return cell;
}

- (void)pushViewController:(id)viewControllerClass {
    
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
        vc.title = _titles[[_classes indexOfObject:viewControllerClass]];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Test Methods

- (void)testMethod {
    NSLog(@"test something");
}

@end
