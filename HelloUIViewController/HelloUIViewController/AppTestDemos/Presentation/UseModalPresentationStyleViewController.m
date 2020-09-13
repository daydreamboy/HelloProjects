//
//  UseModalPresentationStyleViewController.m
//  HelloUIViewController
//
//  Created by wesley_chen on 2020/9/13.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseModalPresentationStyleViewController.h"
#import "DummyModalViewController.h"

@interface UseModalPresentationStyleViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *classes;
@end

@implementation UseModalPresentationStyleViewController

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
        @"UIModalPresentationAutomatic",
        @"UIModalPresentationNone (Don't use it)",
        @"UIModalPresentationFullScreen",
        @"UIModalPresentationPageSheet",
        @"UIModalPresentationFormSheet",
        @"UIModalPresentationCurrentContext",
        @"UIModalPresentationCustom",
        @"UIModalPresentationOverFullScreen",
        @"UIModalPresentationOverCurrentContext",
        @"UIModalPresentationPopover",
    ];
    _classes = @[
        @"test_UIModalPresentationAutomatic",
        @"test_UIModalPresentationNone",
        @"test_UIModalPresentationFullScreen",
        @"test_UIModalPresentationPageSheet",
        @"test_UIModalPresentationFormSheet",
        @"test_UIModalPresentationCurrentContext",
        @"test_UIModalPresentationCustom",
        @"test_UIModalPresentationOverFullScreen",
        @"test_UIModalPresentationOverCurrentContext",
        @"test_UIModalPresentationPopover",
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

- (void)test_UIModalPresentationAutomatic {
    DummyModalViewController *modalViewController = [DummyModalViewController new];
    if (@available(iOS 13.0, *)) {
        modalViewController.modalPresentationStyle = UIModalPresentationAutomatic;
        modalViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    }
    else {
        modalViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    
    [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
}

- (void)test_UIModalPresentationNone {
    DummyModalViewController *modalViewController = [DummyModalViewController new];
    // !!!: Crash
    // Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'The specified modal presentation style doesn't have a corresponding presentation controller.'
    modalViewController.modalPresentationStyle = UIModalPresentationNone;
    
    [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
}

- (void)test_UIModalPresentationFullScreen {
    DummyModalViewController *modalViewController = [DummyModalViewController new];
    modalViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
}

- (void)test_UIModalPresentationPageSheet {
    DummyModalViewController *modalViewController = [DummyModalViewController new];
    modalViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    
    [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
}

- (void)test_UIModalPresentationFormSheet {
    DummyModalViewController *modalViewController = [DummyModalViewController new];
    modalViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
}

- (void)test_UIModalPresentationCurrentContext {
    DummyModalViewController *modalViewController = [DummyModalViewController new];
    modalViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
}

- (void)test_UIModalPresentationCustom {
    DummyModalViewController *modalViewController = [DummyModalViewController new];
    modalViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
}

- (void)test_UIModalPresentationOverFullScreen {
    DummyModalViewController *modalViewController = [DummyModalViewController new];
    modalViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
}

- (void)test_UIModalPresentationOverCurrentContext {
    DummyModalViewController *modalViewController = [DummyModalViewController new];
    modalViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
}

- (void)test_UIModalPresentationPopover {
    DummyModalViewController *modalViewController = [DummyModalViewController new];
    modalViewController.modalPresentationStyle = UIModalPresentationPopover;
    
    [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
}

@end
