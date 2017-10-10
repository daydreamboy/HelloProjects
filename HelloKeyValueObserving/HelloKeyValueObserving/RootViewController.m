//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

#import "AutomaticChangeNotifyViewController.h"
#import "ManualChangeNotifyViewController.h"
#import "ToggleOptionPriorViewController.h"
#import "DependentKeyToOneRelationshipViewController.h"
#import "DependentKeyToManyRelationshipViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *classes;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *switcherOnStatuses;
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
    self.title = @"Hello KVO";

    // MARK: Configure titles and classes for table view
    _titles = @[
        @"Automatic change notify for KVO",
        @"Manual change notify for KVO",
        @"Dependent key (to-one relationship)",
        @"Dependent key (to-many relationship)",
    ];
    _classes = @[
        @"AutomaticChangeNotifyViewController",
        @"ManualChangeNotifyViewController",
        @"DependentKeyToOneRelationshipViewController",
        @"DependentKeyToManyRelationshipViewController",
    ];
    _switcherOnStatuses = [@[
                            @(NO),
                            @(NO),
                            @(NO),
                            @(NO),
                            ] mutableCopy];
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushViewController:_classes[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    BOOL isOn = [_switcherOnStatuses[indexPath.row] boolValue];
    ToggleOptionPriorViewController *vc = [[ToggleOptionPriorViewController alloc] initWithSwitcherOn:isOn switcherToggled:^(BOOL isOn) {
        _switcherOnStatuses[indexPath.row] = @(isOn);
    }];
    vc.title = @"Toggle OptionPrior for KVO register";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }

    cell.textLabel.text = _titles[indexPath.row];

    return cell;
}

- (void)pushViewController:(NSString *)viewControllerClass {
    NSAssert([viewControllerClass isKindOfClass:[NSString class]], @"%@ is not NSString", viewControllerClass);
    
    Class class = NSClassFromString(viewControllerClass);
    if (class && [class isSubclassOfClass:[UIViewController class]]) {
        
        UIViewController *vc = nil;
        if ([viewControllerClass isEqualToString:@"AutomaticChangeNotifyViewController"]) {
            BOOL isOn = [_switcherOnStatuses[[_classes indexOfObject:viewControllerClass]] boolValue];
            vc = [[AutomaticChangeNotifyViewController alloc] initWithOptionPrior:isOn];
        }
        else if ([viewControllerClass isEqualToString:@"ManualChangeNotifyViewController"]) {
            BOOL isOn = [_switcherOnStatuses[[_classes indexOfObject:viewControllerClass]] boolValue];
            vc = [[ManualChangeNotifyViewController alloc] initWithOptionPrior:isOn];
        }
        else if ([viewControllerClass isEqualToString:@"DependentKeyToOneRelationshipViewController"]) {
            BOOL isOn = [_switcherOnStatuses[[_classes indexOfObject:viewControllerClass]] boolValue];
            vc = [[DependentKeyToOneRelationshipViewController alloc] initWithOptionPrior:isOn];
        }
        else if ([viewControllerClass isEqualToString:@"DependentKeyToManyRelationshipViewController"]) {
            BOOL isOn = [_switcherOnStatuses[[_classes indexOfObject:viewControllerClass]] boolValue];
            vc = [[DependentKeyToManyRelationshipViewController alloc] initWithOptionPrior:isOn];
        }
        else {
            vc = [[class alloc] init];
        }
        
        vc.title = _titles[[_classes indexOfObject:viewControllerClass]];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
