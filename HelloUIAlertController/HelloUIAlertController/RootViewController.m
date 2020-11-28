//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"
#import "WCMacroTool.h"

// section 1
#import "AlertWithPreferredActionViewController.h"
#import "AlertWithUITextFieldViewController.h"

// section 2
#import "TabledAlertController.h"

// section 3
#import "AlertWithTextViewController.h"
#import "AlertWithTextFieldViewController.h"
#import "WCAlertController.h"

// section 4
#import "UseWCAlertToolViewController.h"


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

    // MARK: Configure titles and classes for table view
    NSArray<NSDictionary *> *section1 = @[
        @{ kTitle: @"alert with preferred action", kClass: [AlertWithPreferredActionViewController class] },
        @{ kTitle: @"alert with UITextField", kClass: [AlertWithUITextFieldViewController class] },
    ];
    
    NSArray<NSDictionary *> *section2 = @[
        @{ kTitle: @"Show Tabled ActionSheet", kClass: @"showTabledActionSheet" },
    ];

    NSArray<NSDictionary *> *section3 = @[
        @{ kTitle: @"Show alert without view controller", kClass: @"showGlobalAlert" },
        @{ kTitle: @"Show action sheet without view controller", kClass: @"showGlobalActionSheet" },
        @{ kTitle: @"alert with text", kClass: [AlertWithTextViewController class] },
        @{ kTitle: @"alert with UITextField", kClass: [AlertWithTextFieldViewController class] },
    ];

    NSArray<NSDictionary *> *section4 = @[
        @{ kTitle: @"show alert/actionSheet by WCAlertTool", kClass: [UseWCAlertToolViewController class] },
    ];
    
    _sectionTitles = @[
        @"Use UIAlertController",
        @"Use TabledAlertController",
        @"Use WCAlertController",
        @"Use WCAlertTool",
    ];
    
    _classes = @[
         section1,
         section2,
         section3,
         section4,
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

- (void)test {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Action" message:@"ActionSheet" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"index1" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SHOW_ALERT(@"JS Alert", @"message", @"Ok", nil);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"index2" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"index3" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"index4" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
