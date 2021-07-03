//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

// Thread
#import "CreateThreadByNSThreadViewController.h"
#import "CreateThreadByNSObjectViewController.h"
#import "CreateThreadByPOSIXViewController.h"
#import "KeepThreadLongAliveViewController.h"
#import "PerformDispatchBlockOnThreadViewController.h"
#import "CreateResidentThreadViewController.h"

// Lock
#import "MultiThreadExampleViewController.h"
#import "UseNSLockViewController.h"
#import "UseNSLockWithTryLockViewController.h"
#import "UseNSLockWithTimeoutViewController.h"
#import "UseNSLockWithDeadlockViewController.h"
#import "UseNSLockIssueWithUnpairLockUnlockViewController.h"
#import "UseNSRecursiveLockViewController.h"
#import "UseNSConditionLockViewController.h"

// callStack
#import "GetSymbolicCallStackViewController.h"

// test
#import "TestWCAsyncTaskExecutorViewController.h"
#import "TestWCConcurrentTaskExecutorViewController.h"

#define kTitle @"Title"
#define kClass @"Class"

@interface RootViewController ()
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray<NSArray<NSDictionary *> *> *classes;
@property (nonatomic, strong) dispatch_queue_t queue;
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
          @{ kTitle: @"Create thread using NSThread", kClass: [CreateThreadByNSThreadViewController class] },
          @{ kTitle: @"Create thread using NSObject category", kClass: [CreateThreadByNSObjectViewController class] },
          @{ kTitle: @"Create thread using pthread", kClass: [CreateThreadByPOSIXViewController class] },
          @{ kTitle: @"Keep thread long alive", kClass: [KeepThreadLongAliveViewController class] },
          @{ kTitle: @"Call block on thread", kClass: [PerformDispatchBlockOnThreadViewController class] },
          @{ kTitle: @"Create resident thread", kClass: [CreateResidentThreadViewController class] },
    ];

    NSArray<NSDictionary *> *section2 = @[
          @{ kTitle: @"MultiThread Example", kClass: [MultiThreadExampleViewController class] },
          @{ kTitle: @"Use NSLock", kClass: [UseNSLockViewController class] },
          @{ kTitle: @"Use NSLock with tryLock", kClass: [UseNSLockWithTryLockViewController class] },
          @{ kTitle: @"Use NSLock with timeout", kClass: [UseNSLockWithTimeoutViewController class] },
          @{ kTitle: @"Use NSLock to deadlock", kClass: [UseNSLockWithDeadlockViewController class] },
          @{ kTitle: @"Use NSLock unpaired", kClass: [UseNSLockIssueWithUnpairLockUnlockViewController class] },
          @{ kTitle: @"Use NSRecursiveLock", kClass: [UseNSRecursiveLockViewController class] },
          @{ kTitle: @"Use NSConditionLock", kClass: [UseNSConditionLockViewController class] },
    ];
    
    NSArray<NSDictionary *> *section3 = @[
          @{ kTitle: @"Get symbolic call stack", kClass: [GetSymbolicCallStackViewController class] },
    ];
    
    NSArray<NSDictionary *> *section4 = @[
          @{ kTitle: @"Test WCAsyncTaskExecutor", kClass: [TestWCAsyncTaskExecutorViewController class] },
          @{ kTitle: @"Test WCConcurrentTaskExecutor", kClass: [TestWCConcurrentTaskExecutorViewController class] },
    ];
    
    _sectionTitles = @[
        @"Thread",
        @"Lock",
        @"callStack",
        @"test",
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

- (void)testMethod {
    NSLog(@"test something");
}

@end
