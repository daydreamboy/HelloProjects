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
#import "DrawLineBezierPathViewController.h"
#import "DrawArcBezierPathViewController.h"
#import "DrawCurveBezierPathViewController.h"

// section3
#import "ShapeRectBezierPathViewController.h"
#import "ShapeCircleBezierPathViewController.h"
#import "ShapePolygonBezierPathViewController.h"
#import "ShapeSubPathBezierPathViewController.h"
#import "ShapeOpenPathBezierPathViewController.h"
#import "ShapeFillPathBezierPathViewController.h"
#import "ShapeFillPatternImageBezierPathViewController.h"
#import "ShapeFillRuleBezierPathViewController.h"
#import "ShapeLineBezierPathViewController.h"
#import "ShapeLineDashPatternBezierPathViewController.h"
#import "ShapeLineCapBezierPathViewController.h"
#import "ShapeLineJoinBezierPathViewController.h"
#import "ShapeLineStrokeBezierPathViewController.h"
#import "ShapeLineStrokeStartEndBezierPathViewController.h"

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
          @{ kTitle: @"Draw Line Bezier Path", kClass: [DrawLineBezierPathViewController class] },
          @{ kTitle: @"Draw Arc Bezier Path", kClass: [DrawArcBezierPathViewController class] },
          @{ kTitle: @"Draw Curve Bezier Path", kClass: [DrawCurveBezierPathViewController class] },
    ];
    
    NSArray<NSDictionary *> *section3 = @[
          @{ kTitle: @"Shape Rectangle Bezier Path", kClass: [ShapeRectBezierPathViewController class] },
          @{ kTitle: @"Shape Circle Bezier Path", kClass: [ShapeCircleBezierPathViewController class] },
          @{ kTitle: @"Shape Polygon Bezier Path", kClass: [ShapePolygonBezierPathViewController class] },
          @{ kTitle: @"Shape SubPath Bezier Path", kClass: [ShapeSubPathBezierPathViewController class] },
          @{ kTitle: @"Shape OpenPath Bezier Path", kClass: [ShapeOpenPathBezierPathViewController class] },
          @{ kTitle: @"Shape Fill Bezier Path", kClass: [ShapeFillPathBezierPathViewController class] },
          @{ kTitle: @"Shape Fill Pattern Image Bezier Path", kClass: [ShapeFillPatternImageBezierPathViewController class] },
          @{ kTitle: @"Shape Fill Rule Bezier Path", kClass: [ShapeFillRuleBezierPathViewController class] },
          @{ kTitle: @"Shape Line Bezier Path", kClass: [ShapeLineBezierPathViewController class] },
          @{ kTitle: @"Shape Line Dash Pattern", kClass: [ShapeLineDashPatternBezierPathViewController class] },
          @{ kTitle: @"Shape Line Cap", kClass: [ShapeLineCapBezierPathViewController class] },
          @{ kTitle: @"Shape Line Join", kClass: [ShapeLineJoinBezierPathViewController class] },
          @{ kTitle: @"Shape Line Stroke", kClass: [ShapeLineStrokeBezierPathViewController class] },
          @{ kTitle: @"Shape Line Stroke Start & End", kClass: [ShapeLineStrokeStartEndBezierPathViewController class] },
    ];
    
    _sectionTitles = @[
        @"Create Context",
        @"Use UIBezierPath with CGContext",
        @"Use UIBezierPath with CAShapeLayer",
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
