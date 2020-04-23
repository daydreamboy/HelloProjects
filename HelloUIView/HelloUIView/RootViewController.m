//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

#import "UseCAShapeLayerToShowViewWithTwoCornersViewController.h"
#import "ObserveViewGeometryChangeEventViewController.h"
#import "TouchThroughPartRegionOfViewViewController.h"
#import "MappingRectFromViewToViewViewController.h"
#import "DrawGradientViewViewController.h"
#import "DrawRadialGradientViewViewController.h"
#import "UseCAGradientLayerWithTwoColorsViewController.h"
#import "UseCAGradientLayerWithMultipleColorsViewController.h"
#import "StretchImageInLayerViewController.h"
#import "DottedLineViewViewController.h"
#import "UseSafeAreaInsetsViewController.h"

#import "HitTestInViewViewController.h"
#import "AddShadowBorderToImageViewController.h"
#import "AddBorderToImageViewController.h"
#import "TwoAdjacentShadowBorderViewController.h"
#import "TouchThroughToUnderneathViewViewController.h"
#import "BlurAnyViewViewController.h"
#import "TraverseSubviewsInViewViewController.h"
#import "GroupSubviewsByWrapperViewViewController.h"
#import "GroupSubviewsByRelayoutSubviewsViewController.h"

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
          @{ kTitle: @"Observer UIView change event", kClass: [ObserveViewGeometryChangeEventViewController class] },
          @{ kTitle: @"Touch through part of view", kClass: [TouchThroughPartRegionOfViewViewController class] },
          @{ kTitle: @"Pass touch through to underneath view", kClass: [TouchThroughToUnderneathViewViewController class] },
          @{ kTitle: @"Mapping rect from view to view", kClass: [MappingRectFromViewToViewViewController class] },
          @{ kTitle: @"Demonstrate HitTest", kClass: [HitTestInViewViewController class] },
          @{ kTitle: @"Blur a view", kClass: [BlurAnyViewViewController class] },
          @{ kTitle: @"Traverse view hierachy", kClass: [TraverseSubviewsInViewViewController class] },
          @{ kTitle: @"Group all subviews by wrapper view", kClass: [GroupSubviewsByWrapperViewViewController class] },
          @{ kTitle: @"Group all subviews by relayout subviews", kClass: [GroupSubviewsByRelayoutSubviewsViewController class] },
          @{ kTitle: @"Dotted line views", kClass: [DottedLineViewViewController class] },
          @{ kTitle: @"safeAreaInsets", kClass: [UseSafeAreaInsetsViewController class] },
    ];

    NSArray<NSDictionary *> *section2 = @[
          @{ kTitle: @"UIView with two corners", kClass: [UseCAShapeLayerToShowViewWithTwoCornersViewController class] },
          @{ kTitle: @"Draw gradient view", kClass: [DrawGradientViewViewController class] },
          @{ kTitle: @"Draw radial gradient view", kClass: [DrawRadialGradientViewViewController class] },
          @{ kTitle: @"Gradient with two colors (Use CAGradientLayer)", kClass: [UseCAGradientLayerWithTwoColorsViewController class] },
          @{ kTitle: @"Use CAGradientLayer", kClass: [UseCAGradientLayerWithMultipleColorsViewController class] },
          @{ kTitle: @"Add shadow border to image", kClass: [AddShadowBorderToImageViewController class] },
          @{ kTitle: @"Add border to image", kClass: [AddBorderToImageViewController class] },
          @{ kTitle: @"Two adjacent shadow border", kClass: [TwoAdjacentShadowBorderViewController class] },
          @{ kTitle: @"Stretch image by CALayer", kClass: [StretchImageInLayerViewController class] },
    ];
    
    _sectionTitles = @[
        @"UIView",
        @"CALayer",
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
