//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

// section 1
#import "GlobalConcurrentQueueViewController.h"
#import "CreateDispatchQueuesViewController.h"
#import "GetCommonQueuesViewController.h"
#import "SetSingleContextDataToQueueViewController.h"
#import "AddTaskToQueueViewController.h"
#import "AddCompletionBlockToQueueViewController.h"
#import "ConcurrentLoopViewController.h"
#import "SuspendAndResumeQueueViewController.h"
#import "UseDispatchSemaphoreViewController.h"
#import "CreateQueueInactiveViewController.h"
#import "AddBarrierTaskToConcurrentQueueViewController.h"
#import "GetCurrentQueueViewController.h"

// section 2
#import "UseDispatchGroupViewController.h"

// section 3
#import "CreateADispatchSourceViewController.h"
#import "CreateTimerDispatchSourceViewController.h"
#import "CreateReadDispatchSourceViewController.h"
#import "CreateWriteDispatchSourceViewController.h"
#import "CreateVNodeDispatchSourceViewController.h"
#import "CreateDataBufferDispatchSourceViewController.h"
#import "UseDispatchBenchmarkViewController.h"
#import "UseDispatchIOViewController.h"

// section 4
#import "ExampleOfBatchDownloadImagesViewController.h"

// section 5
#import "DispatchOnceIssueCallStackViewController.h"

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
          @{ kTitle: @"Get Global Concurrent Queues", kClass: [GlobalConcurrentQueueViewController class] },
          @{ kTitle: @"Create Serial Dispatch Queues", kClass: [CreateDispatchQueuesViewController class] },
          @{ kTitle: @"Get Common Queues", kClass: [GetCommonQueuesViewController class] },
          @{ kTitle: @"Set Single Context Data to Queues", kClass: [SetSingleContextDataToQueueViewController class] },
          @{ kTitle: @"Add Task to Queue", kClass: [AddTaskToQueueViewController class] },
          @{ kTitle: @"Add barrier Task to Concurrent Queue", kClass: [AddBarrierTaskToConcurrentQueueViewController class] },
          @{ kTitle: @"Add Completion Block to Queue", kClass: [AddCompletionBlockToQueueViewController class] },
          @{ kTitle: @"Use Concurrent Loop", kClass: [ConcurrentLoopViewController class] },
          @{ kTitle: @"Suspend & Resume Queue", kClass: [SuspendAndResumeQueueViewController class] },
          @{ kTitle: @"Use dispatch semaphore", kClass: [UseDispatchSemaphoreViewController class] },
          @{ kTitle: @"Create queue inactive", kClass: [CreateQueueInactiveViewController class] },
          @{ kTitle: @"Get Current Queue", kClass: [GetCurrentQueueViewController class] },
    ];
    
    NSArray<NSDictionary *> *section2 = @[
          @{ kTitle: @"Use dispatch group", kClass: [UseDispatchGroupViewController class] },
    ];
   
    /*
     #define DISPATCH_SOURCE_TYPE_DATA_ADD
     #define DISPATCH_SOURCE_TYPE_DATA_OR
     #define DISPATCH_SOURCE_TYPE_MACH_RECV
     #define DISPATCH_SOURCE_TYPE_MACH_SEND
     #define DISPATCH_SOURCE_TYPE_PROC
     #define DISPATCH_SOURCE_TYPE_READ
     #define DISPATCH_SOURCE_TYPE_SIGNAL
     #define DISPATCH_SOURCE_TYPE_TIMER
     #define DISPATCH_SOURCE_TYPE_VNODE
     #define DISPATCH_SOURCE_TYPE_WRITE
     */
    NSArray<NSDictionary *> *section3 = @[
          @{ kTitle: @"Create a Dispatch Source", kClass: [CreateADispatchSourceViewController class] },
          @{ kTitle: @"Create Timer Dispatch Source", kClass: [CreateTimerDispatchSourceViewController class] },
          @{ kTitle: @"Create Read Dispatch Source", kClass: [CreateReadDispatchSourceViewController class] },
          @{ kTitle: @"Create Write Dispatch Source", kClass: [CreateWriteDispatchSourceViewController class] },
          @{ kTitle: @"Create VNODE Dispatch Source", kClass: [CreateVNodeDispatchSourceViewController class] },
          @{ kTitle: @"Usage of Dispatch Data", kClass: [CreateDataBufferDispatchSourceViewController class] },
          @{ kTitle: @"Usage of Dispatch Benchmark", kClass: [UseDispatchBenchmarkViewController class] },
          @{ kTitle: @"Usage of Dispatch I/O (TODO)", kClass: [UseDispatchIOViewController class] },
    ];
    
    NSArray<NSDictionary *> *section4 = @[
          @{ kTitle: @"Example Of Batch Download Images", kClass: [ExampleOfBatchDownloadImagesViewController class] },
    ];
    
    NSArray<NSDictionary *> *section5 = @[
          @{ kTitle: @"Crash happen in dispatch_once", kClass: [DispatchOnceIssueCallStackViewController class] },
    ];
    
    _sectionTitles = @[
        @"dispatch queue",
        @"dispatch group",
        @"dispatch source",
        @"operation queue",
        @"GCD issues"
    ];
    
    _classes = @[
         section1,
         section2,
         section3,
         section4,
         section5,
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
