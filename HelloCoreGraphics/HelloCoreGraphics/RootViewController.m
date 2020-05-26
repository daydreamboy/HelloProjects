//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

// section1
#import "CreatePDFGraphicsContext1ViewController.h"
#import "CreatePDFGraphicsContext2ViewController.h"
#import "CreateBitmapGraphicsContext1ViewController.h"
#import "CreateBitmapGraphicsContext2ViewController.h"
#import "CreateAttachedBubbleLayerViewController.h"
#import "ExamplesOfWAttachedBubbleViewViewController.h"
#import "CreateCircleProgressViewViewController.h"

// section2
#import "DrawArcBezierPathViewController.h"
#import "DrawCurveBezierPathViewController.h"

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
          @{ kTitle: @"Create PDF graphics context by CGPDFContextCreateWithURL", kClass: [CreatePDFGraphicsContext1ViewController class] },
          @{ kTitle: @"Create PDF graphics context by CGPDFContextCreate", kClass: [CreatePDFGraphicsContext2ViewController class] },
          @{ kTitle: @"Create Bitmap graphics context by CGBitmapContextCreate", kClass: [CreateBitmapGraphicsContext1ViewController class] },
          @{ kTitle: @"Create Bitmap graphics context by UIGraphicsBeginImageContextWithOptions", kClass: [CreateBitmapGraphicsContext2ViewController class] },
          @{ kTitle: @"Create bubble layer", kClass: [CreateAttachedBubbleLayerViewController class] },
          @{ kTitle: @"Examples of WCAttachedBubbleView", kClass: [ExamplesOfWAttachedBubbleViewViewController class] },
          @{ kTitle: @"CreateCircleProgressViewViewController", kClass: [CreateCircleProgressViewViewController class] },
    ];
    
    NSArray<NSDictionary *> *section2 = @[
          @{ kTitle: @"Draw Arc Bezier Path", kClass: [DrawArcBezierPathViewController class] },
          @{ kTitle: @"Draw Curve Bezier Path", kClass: [DrawCurveBezierPathViewController class] },
    ];
    
    _sectionTitles = @[
        @"Create Context",
        @"Use UIBezierPath",
    ];
    
    _classes = @[
         section1,
         section2,
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
