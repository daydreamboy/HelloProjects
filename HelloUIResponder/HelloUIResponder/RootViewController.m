//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

#import "GetContextMenuClickEventViewController.h"
#import "UseInputViewInUITextFieldViewController.h"
#import "TableViewCellShowContextMenuViewController.h"
#import "UseUIMenuControllerViewController.h"
#import "UIMenuControllerKeepKeyboardShowViewController.h"
#import "TableViewCellShowCustomContextMenuViewController.h"
#import "UseWCMenuItemViewController.h"
#import "ManuallySendActionViewController.h"
#import "ManuallySendActionAndPopUpwardEventViewController.h"

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
        @"Get context menu click event (paste, ...)",
        @"Use input view as keyboard",
        @"UITableViewCell show context menu",
        @"UITableViewCell show custom context menu",
        @"Use UIMenuController",
        @"UIMenuController keep keyboard show",
        @"Use WCMenuItem with block",
        @"Manually send action with UIEvent",
        @"Manually pop upward action with UIEvent",
        @"call a test method",
    ];
    _classes = @[
        [GetContextMenuClickEventViewController class],
        [UseInputViewInUITextFieldViewController class],
        [TableViewCellShowContextMenuViewController class],
        [TableViewCellShowCustomContextMenuViewController class],
        [UseUIMenuControllerViewController class],
        [UIMenuControllerKeepKeyboardShowViewController class],
        [UseWCMenuItemViewController class],
        [ManuallySendActionViewController class],
        [ManuallySendActionAndPopUpwardEventViewController class],
        @"testMethod",
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
