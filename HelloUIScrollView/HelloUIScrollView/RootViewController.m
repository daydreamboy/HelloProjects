//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

#import "ScrollToEdgesViewController.h"
#import "ScrollToEdgesOfTableViewViewController.h"
#import "NestedScrollViewViewController.h"
#import "CheckUserScrollingViewController.h"
#import "CheckScrollingViewController.h"
#import "PullRefreshViewController.h"
#import "DisableCallScrollViewDidScrollAutomaticallyViewController.h"
#import "UIView+UserInfo.h"
#import "DetectScrollingDirectionViewController.h"
#import "StickyHeaderSectionInScrollViewViewController.h"
#import "StickySectionInScrollViewViewController.h"
#import "StickySidingSectionInScrollViewViewController.h"
#import "StickyPushSectionInScrollViewViewController.h"

typedef NS_ENUM(NSUInteger, AccessoryViewType) {
    AccessoryViewTypeDefault,
    AccessoryViewTypeSwitch,
};

@interface RootViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *classes;
@property (nonatomic, strong) NSMutableArray<id> *options;
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
        @"Scroll to edges of ScrollView/Content",
        @"Scroll to edges of TableView/Content",
        @"Handle nested UIScrollView",
        @"Check UIScrollView is dragging by user",
        @"Check UIScrollView is scrolling",
        @"Pull refresh (Vertical/Horizontal)",
        @"Disable call scrollViewDidScroll automatically",
        @"Detect scrolling direction",
        @"Sticky Section",
        @"Sticky HeaderSection",
        @"Sticky SidingSection",
        @"Sticky PushSection",
        @"call a test method",
    ];
    _classes = @[
        [ScrollToEdgesViewController class],
        [ScrollToEdgesOfTableViewViewController class],
        [NestedScrollViewViewController class],
        [CheckUserScrollingViewController class],
        [CheckScrollingViewController class],
        [PullRefreshViewController class],
        [DisableCallScrollViewDidScrollAutomaticallyViewController class],
        [DetectScrollingDirectionViewController class],
        [StickySectionInScrollViewViewController class],
        [StickyHeaderSectionInScrollViewViewController class],
        [StickySidingSectionInScrollViewViewController class],
        [StickyPushSectionInScrollViewViewController class],
        @"testMethod",
    ];
    _options = [@[
        [NSNull null],
        [NSNull null],
        [NSNull null],
        [NSNull null],
        [NSNull null],
        [NSNull null],
        [@{
            @"accessoryViewType": @(AccessoryViewTypeSwitch),
            kOptionDisableAutoCallScrollViewDidScroll: @(NO)
        } mutableCopy],
        [NSNull null],
        [NSNull null],
        [NSNull null],
        [NSNull null],
        [NSNull null],
        [NSNull null],
    ] mutableCopy];
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id options = self.options[indexPath.row];
    [self pushViewController:_classes[indexPath.row] options:options];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = nil;
    
    id option = self.options[indexPath.row];
    if (option != [NSNull null] && [option isKindOfClass:[NSDictionary class]]) {
        if ([option[@"accessoryViewType"] integerValue] == AccessoryViewTypeSwitch) {
            UISwitch *switcher = [UISwitch new];
            switcher.on = [option[kOptionDisableAutoCallScrollViewDidScroll] boolValue];
            [switcher addTarget:self action:@selector(switcherToggled:) forControlEvents:UIControlEventValueChanged];
            switcher.associatedUserObject = indexPath;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = switcher;
        }
    }

    return cell;
}

- (void)pushViewController:(id)viewControllerClass options:(id)options {
    
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
        UIViewController *vc;
        if (options != [NSNull null] && [options isKindOfClass:[NSDictionary class]] && [class conformsToProtocol:@protocol(IViewControllerInitOption)]) {
            vc = (UIViewController *)[((id<IViewControllerInitOption>)[class alloc]) initWithOptions:options];
        }
        else {
            vc = [[class alloc] init];
        }
        
        vc.title = _titles[[_classes indexOfObject:viewControllerClass]];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Action

- (void)switcherToggled:(id)sender {
    UISwitch *switcher = (UISwitch *)sender;
    NSIndexPath *indexPath = switcher.associatedUserObject;
    self.options[indexPath.row][kOptionDisableAutoCallScrollViewDidScroll] = @(![self.options[indexPath.row][kOptionDisableAutoCallScrollViewDidScroll] boolValue]);
}

#pragma mark - Test Methods

- (void)testMethod {
    NSLog(@"test something");
}

@end
