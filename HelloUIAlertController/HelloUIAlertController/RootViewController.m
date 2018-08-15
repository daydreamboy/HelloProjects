//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

#import "TabledAlertController.h"
#import "WCAlertController.h"

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
        @"Show Tabled ActionSheet",
        @"Show alert without view controller",
        @"Show action sheet without view controller",
    ];
    _classes = @[
        @"showTabledActionSheet",
        @"showGlobalAlert",
        @"showGlobalActionSheet",
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

- (void)showTabledActionSheet {
    TabledAlertController *actionSheet = [TabledAlertController alertControllerWithTitle:@"Title" message:@"some info" preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Reset to default" style:UIAlertActionStyleDestructive handler:nil]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)showGlobalAlert {
    // need local variable for TextField to prevent retain cycle of Alert otherwise UIWindow
    // would not disappear after the Alert was dismissed
    __block UITextField *localTextField;
    WCAlertController *alert = [WCAlertController alertControllerWithTitle:@"Global Alert" message:@"Enter some text" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"do something with text:%@", localTextField.text);
        // do NOT use alert.textfields or otherwise reference the alert in the block. Will cause retain cycle
    }]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        localTextField = textField;
    }];
    [alert show];
}

- (void)showGlobalActionSheet {
    __block UITextField *localTextField;
    WCAlertController *alert = [WCAlertController alertControllerWithTitle:@"Global ActionSheet" message:@"Enter some text" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"do something with text:%@", localTextField.text);
    }]];
    [alert show];
}

@end
