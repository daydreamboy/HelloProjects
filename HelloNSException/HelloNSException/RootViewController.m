//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//


#import "RootViewController.h"
#include <sys/signal.h>
#import "WCUncaughtExceptionTool.h"
#import "WCCrashCaseTool.h"
#import "DisplayTextViewController.h"
#import "UseExceptionHanderViewController.h"
#import "UseSignalHandlerViewController.h"

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
                @"View Exception Log",
                @"View Signal Log",
                @"Check current exception handler",
                @"Check current signal handler",
                @"Use exception handler",
                @"Use signal handler",
                @"call a test method",
                ];
    _classes = @[
                 @"openExceptionLog",
                 @"openSignalLog",
                 @"checkCurrentExceptionHandler",
                 @"checkCurrentSignalHandler",
                 [UseExceptionHanderViewController class],
                 [UseSignalHandlerViewController class],
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

- (void)openExceptionLog {
    DisplayTextViewController *vc = [[DisplayTextViewController alloc] initWithFilePath:ExceptionLogFilePath];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openSignalLog {
    DisplayTextViewController *vc = [[DisplayTextViewController alloc] initWithFilePath:SignalLogFilePath];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)checkCurrentExceptionHandler {
    NSString *message = @"";
    NSUncaughtExceptionHandler *exceptionHandler = NSGetUncaughtExceptionHandler();
    
    if (exceptionHandler) {
        message = [NSString stringWithFormat:@"current exception handler is: %p", exceptionHandler];
    }
    else {
        message = @"not set exception handler";
    }
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
#pragma GCC diagnostic pop
}

- (void)checkCurrentSignalHandler {
    NSString *message = @"";
    
    // https://stackoverflow.com/questions/28529257/how-to-get-current-signal-handler-on-ios
    signal_handler_t current_handler = signal(SIGABRT, SIG_IGN);
    if (current_handler) {
        message = [NSString stringWithFormat:@"current signal handler is: %p", current_handler];
    }
    else {
        message = @"not set signal handler";
    }
    // Note: restore handler for SIGABRT
    signal(SIGABRT, current_handler);
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
#pragma GCC diagnostic pop
}

#pragma mark - Test Methods

- (void)testMethod {
    NSLog(@"test something");
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unhandled exception", nil)
    //                                                    message:@"test"
    //                                                   delegate:nil
    //                                          cancelButtonTitle:NSLocalizedString(@"Quit", nil)
    //                                          otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
    //    [alert show];
    
    [WCCrashCaseTool makeCrashWithNilParameter];
}

@end
