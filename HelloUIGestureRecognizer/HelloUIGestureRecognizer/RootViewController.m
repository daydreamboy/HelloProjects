//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

#import "UsePanGestureRecognizer1ViewController.h"
#import "UsePanGestureRecognizer2ViewController.h"
#import "UsePanGestureRecognizer3ViewController.h"
#import "DragViewRestrictedViewController.h"
#import "DetectSwipeUsingUIPanGestureRecognizerViewController.h"
#import "DragDownAndScaleImageViewViewController.h"
#import "TapGesturesBothOnParentChildViewViewController.h"
#import "GestureRecognizerVSControlEventsViewController.h"
#import "UseCancelsTouchesInView1ViewController.h"
#import "UseCancelsTouchesInView2ViewController.h"
#import "MockTapGestureViewController.h"
#import "MirrorTapGestureViewController.h"
#import "ParentViewObserveChildViewTapEventViewController.h"

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
          @{ kTitle: @"Tap gestures both on parent view and child view", kClass: [TapGesturesBothOnParentChildViewViewController class] },
          @{ kTitle: @"ParentView Observe ChildView Tap Event", kClass: [ParentViewObserveChildViewTapEventViewController class] },
    ];
    
    NSArray<NSDictionary *> *section2 = @[
          @{ kTitle: @"Move view (1) using UIPanGestureRecognizer", kClass: [UsePanGestureRecognizer1ViewController class] },
          @{ kTitle: @"Move view (2) using UIPanGestureRecognizer", kClass: [UsePanGestureRecognizer2ViewController class] },
          @{ kTitle: @"Move view (3) using UIPanGestureRecognizer", kClass: [UsePanGestureRecognizer3ViewController class] },
          @{ kTitle: @"Drag up view and increase height", kClass: [DragViewRestrictedViewController class] },
          @{ kTitle: @"Detect swipe using UIPanGestureRecognizer", kClass: [DetectSwipeUsingUIPanGestureRecognizerViewController class] },
          @{ kTitle: @"Drag down and scale image", kClass: [DragDownAndScaleImageViewViewController class] },
    ];
    
    NSArray<NSDictionary *> *section3 = @[
          @{ kTitle: @"UIGestureRecognizer vs. UIControlEvents", kClass: [GestureRecognizerVSControlEventsViewController class] },
          @{ kTitle: @"Use cancelsTouchesInView (UIButton example)", kClass: [UseCancelsTouchesInView1ViewController class] },
          @{ kTitle: @"Use cancelsTouchesInView (UICollectionView example)", kClass: [UseCancelsTouchesInView2ViewController class] },
          @{ kTitle: @"Mock TapGesture", kClass: [MockTapGestureViewController class] },
          @{ kTitle: @"Use Mirrored TapGesture", kClass: [MirrorTapGestureViewController class] },
    ];
    
    _sectionTitles = @[
        @"UITapGestureRecognizer",
        @"UIPanGestureRecognizer",
        @"Other",
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

#pragma mark - Test Methods

- (void)testMethod {
    NSLog(@"test something");
}

@end
