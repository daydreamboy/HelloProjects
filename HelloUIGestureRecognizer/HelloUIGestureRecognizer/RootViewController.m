//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

#import "DragViewDemo1UsingUIPanGestureRecognizerViewController.h"
#import "DragViewDemo2UsingUIPanGestureRecognizerViewController.h"
#import "DragViewRestrictedViewController.h"
#import "DetectSwipeUsingUIPanGestureRecognizerViewController.h"
#import "DragDownAndScaleImageViewViewController.h"
#import "TapGesturesBothOnParentChildViewViewController.h"
#import "GestureRecognizerVSControlEventsViewController.h"
#import "UseCancelsTouchesInView1ViewController.h"
#import "UseCancelsTouchesInView2ViewController.h"

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
        @"Move view (1) using UIPanGestureRecognizer",
        @"Move view (2) using UIPanGestureRecognizer",
        @"Drag up view and increase height",
        @"Detect swipe using UIPanGestureRecognizer",
        @"Drag down and scale image",
        @"Tap gestures both on parent view and child view",
        @"UIGestureRecognizer vs. UIControlEvents",
        @"Use cancelsTouchesInView (UIbutton example)",
        @"Use cancelsTouchesInView (UICollectionView example)",
        @"call a test method",
    ];
    _classes = @[
        [DragViewDemo1UsingUIPanGestureRecognizerViewController class],
        [DragViewDemo2UsingUIPanGestureRecognizerViewController class],
        [DragViewRestrictedViewController class],
        [DetectSwipeUsingUIPanGestureRecognizerViewController class],
        [DragDownAndScaleImageViewViewController class],
        [TapGesturesBothOnParentChildViewViewController class],
        [GestureRecognizerVSControlEventsViewController class],
        [UseCancelsTouchesInView1ViewController class],
        [UseCancelsTouchesInView2ViewController class],
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
