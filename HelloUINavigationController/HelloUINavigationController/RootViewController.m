//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

// section 2
#import "ColorizeHairLineOfNavBarViewController.h"
#import "RemoveHairLineOfNavBarViewController.h"
#import "TransparentNavBarViewController.h"
#import "SolidColoredNavBarViewController.h"
#import "HideBackArrowViewController.h"
#import "PositionBarButtonItemViewController.h"
#import "WCNavigationBar.h"

// section 3
#import "NavRootViewControllerWithIssueTranslucentIsNO.h"


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
    ];
    
    NSArray<NSDictionary *> *section2 = @[
        @{ kTitle: @"Customize hair line of nav bar", kClass: [ColorizeHairLineOfNavBarViewController class] },
        @{ kTitle: @"Remvoe hair line of nav bar", kClass: [RemoveHairLineOfNavBarViewController class] },
        @{ kTitle: @"Transparent nav bar", kClass: [TransparentNavBarViewController class] },
        @{ kTitle: @"Solid colored nav bar", kClass: [SolidColoredNavBarViewController class] },
        @{ kTitle: @"Hide back arrow", kClass: [HideBackArrowViewController class] },
        @{ kTitle: @"Negative width for UIBarButtonSystemItemFixedSpace", kClass: @"presentNavController" },
    ];

    NSArray<NSDictionary *> *section3 = @[
          @{ kTitle: @"NavBar translucent=NO", kClass: @"present_navbar_translucent" },
    ];
    
    _sectionTitles = @[
        @"Navigation Controller",
        @"Navigation Bar",
        @"Navigation Controller Issues",
    ];
    
    _classes = @[
         section1,
         section2,
         section3,
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

#pragma mark -

- (void)presentNavController {
    UINavigationController *navController = [[UINavigationController alloc] initWithNavigationBarClass:[WCNavigationBar class] toolbarClass:nil];
    PositionBarButtonItemViewController *rootViewController = [PositionBarButtonItemViewController new];
    [navController pushViewController:rootViewController animated:NO];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)present_navbar_translucent {
    NavRootViewControllerWithIssueTranslucentIsNO *rootViewController = [NavRootViewControllerWithIssueTranslucentIsNO new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    [self presentViewController:navController animated:YES completion:nil];
}

@end
