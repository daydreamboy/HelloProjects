//
//  UseWCAlertToolViewController.m
//  HelloUIAlertController
//
//  Created by wesley_chen on 2019/2/20.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseWCAlertToolViewController.h"
#import "WCAlertTool.h"

#define kTitle @"Title"
#define kClass @"Class"

@interface UseWCAlertToolViewController ()
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray<NSArray<NSDictionary *> *> *classes;
@property (nonatomic, assign) UIAlertControllerStyle currentStyle;
@end

@implementation UseWCAlertToolViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [self prepareForInit];
    }
    
    return self;
}

- (void)prepareForInit {
    self.title = @"Use WCAlertTool";
    
    // MARK: Configure sectionTitles and classes for table view
    NSArray<NSDictionary *> *section1 = @[
          @{ kTitle: @"Show with cancel button", kClass: NSStringFromSelector(@selector(showActionSheetWithCancelButton)) },
          @{ kTitle: @"show with other button title (not work)", kClass: NSStringFromSelector(@selector(showActionSheetWithOtherButtonTitle)) },
          @{ kTitle: @"show with other button title and callback", kClass: NSStringFromSelector(@selector(showActionSheetWithOtherButtonTitleAndCallback)) },
          @{ kTitle: @"show with other buttons", kClass: NSStringFromSelector(@selector(showActionSheetWithOtherButtons)) },
    ];

    NSArray<NSDictionary *> *section2 = @[
          @{ kTitle: @"Show with cancel button", kClass: NSStringFromSelector(@selector(showActionSheetWithCancelButton2)) },
          @{ kTitle: @"show with other button title", kClass: NSStringFromSelector(@selector(showActionSheetWithOtherButtonTitle2)) },
          @{ kTitle: @"show with other button title and callback", kClass: NSStringFromSelector(@selector(showActionSheetWithOtherButtonTitleAndCallback2)) },
          @{ kTitle: @"show with other buttons", kClass: NSStringFromSelector(@selector(showActionSheetWithOtherButtons2)) },
    ];
    
    _sectionTitles = @[
        @"by variable list",
        @"by array",
    ];
    
    _classes = @[
         section1,
         section2,
    ];
    
    _currentStyle = UIAlertControllerStyleAlert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwitch *switcher = [[UISwitch alloc] init];
    switcher.on = NO;
    [switcher addTarget:self action:@selector(switcherToggled:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:switcher];
    self.navigationItem.rightBarButtonItem = barItem;
}

#pragma mark - Actions

- (void)switcherToggled:(UISwitch *)switcher {
    switcher.on = !switcher.on;
    
    if (switcher.on) {
        self.currentStyle = UIAlertControllerStyleActionSheet;
    }
    else {
        self.currentStyle = UIAlertControllerStyleAlert;
    }
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
        cell.accessoryType = UITableViewCellAccessoryNone;
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

#pragma mark > by va_list

- (void)showActionSheetWithCancelButton {
    [WCAlertTool presentAlertWithStyle:self.currentStyle title:@"This is a title" message:@"some tip here" cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:^{
        NSLog(@"_cmd: %@, cancelButtonDidClick", NSStringFromSelector(_cmd));
    }, nil];
}

- (void)showActionSheetWithOtherButtonTitle {
    [WCAlertTool presentAlertWithStyle:self.currentStyle title:@"This is a title" message:nil cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:^{
        NSLog(@"_cmd: %@, cancelButtonDidClick", NSStringFromSelector(_cmd));
    }, @"button1", nil];
}

- (void)showActionSheetWithOtherButtonTitleAndCallback {
    [WCAlertTool presentAlertWithStyle:self.currentStyle title:@"This is a title" message:@"" cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:^{
        NSLog(@"_cmd: %@, cancelButtonDidClick", NSStringFromSelector(_cmd));
    }, @"button1", ^{
        NSLog(@"_cmd: %@, button1DidClick", NSStringFromSelector(_cmd));
    }, nil];
}

- (void)showActionSheetWithOtherButtons {
    [WCAlertTool presentAlertWithStyle:self.currentStyle title:@"This is a title" message:@"some tip here" cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:^{
        NSLog(@"_cmd: %@, cancelButtonDidClick", NSStringFromSelector(_cmd));
    }, @"button1", ^{
        NSLog(@"_cmd: %@, button1DidClick", NSStringFromSelector(_cmd));
    }, @"button2", ^{
        NSLog(@"_cmd: %@, button2DidClick", NSStringFromSelector(_cmd));
    }, nil];
}

#pragma mark > by va_list

- (void)showActionSheetWithCancelButton2 {
    void (^block)(void) = ^{
        NSLog(@"_cmd: %@, cancelButtonDidClick", NSStringFromSelector(_cmd));
    };
    
    [WCAlertTool presentAlertWithStyle:self.currentStyle title:@"This is a title" message:@"some tip here" buttonTitles:@[ @"Ok" ] buttonDidClickBlocks:@[ block ]];
}

- (void)showActionSheetWithOtherButtonTitle2 {
    void (^block1)(void) = ^{
        NSLog(@"_cmd: %@, cancelButtonDidClick", NSStringFromSelector(_cmd));
    };
    
    id block2 = [NSNull null];
    
    [WCAlertTool presentAlertWithStyle:self.currentStyle title:@"This is a title" message:@"some tip here" buttonTitles:@[ @"Ok", @"button1" ] buttonDidClickBlocks:@[ block1, block2 ]];
}

- (void)showActionSheetWithOtherButtonTitleAndCallback2 {
    void (^block1)(void) = ^{
        NSLog(@"_cmd: %@, cancelButtonDidClick", NSStringFromSelector(_cmd));
    };
    
    void (^block2)(void) = ^{
        NSLog(@"_cmd: %@, button1DidClick", NSStringFromSelector(_cmd));
    };
    
    [WCAlertTool presentAlertWithStyle:self.currentStyle title:@"This is a title" message:@"" buttonTitles:@[ @"Ok", @"button1" ] buttonDidClickBlocks:@[ block1, block2 ]];
}

- (void)showActionSheetWithOtherButtons2 {
    void (^block1)(void) = ^{
        NSLog(@"_cmd: %@, cancelButtonDidClick", NSStringFromSelector(_cmd));
    };
    
    void (^block2)(void) = ^{
        NSLog(@"_cmd: %@, button1DidClick", NSStringFromSelector(_cmd));
    };
    
    void (^block3)(void) = ^{
        NSLog(@"_cmd: %@, button2DidClick", NSStringFromSelector(_cmd));
    };
    
    NSArray *buttonTitles = @[ @"Ok", @"button1", @"button2" ];
    NSArray *blocks = @[ block1, block2, block3 ];
    
    [WCAlertTool presentAlertWithStyle:self.currentStyle title:@"This is a title" message:@"some tip here" buttonTitles:buttonTitles buttonDidClickBlocks:blocks];
}

@end
