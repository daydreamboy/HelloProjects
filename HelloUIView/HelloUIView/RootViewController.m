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
#import "HitTestInViewViewController.h"
#import "AddShadowBorderToImageViewController.h"

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
          @{ kTitle: @"UIView with two corners", kClass: [UseCAShapeLayerToShowViewWithTwoCornersViewController class] },
          @{ kTitle: @"observer UIView change event", kClass: [ObserveViewGeometryChangeEventViewController class] },
          @{ kTitle: @"touch through part of view", kClass: [TouchThroughPartRegionOfViewViewController class] },
          @{ kTitle: @"mapping rect from view to view", kClass: [MappingRectFromViewToViewViewController class] },
          @{ kTitle: @"Demonstrate HitTest", kClass: [HitTestInViewViewController class] },
    ];

    NSArray<NSDictionary *> *section2 = @[
          @{ kTitle: @"Draw gradient view", kClass: [DrawGradientViewViewController class] },
          @{ kTitle: @"Draw radial gradient view", kClass: [DrawRadialGradientViewViewController class] },
          @{ kTitle: @"gradient with two colors (Use CAGradientLayer)", kClass: [UseCAGradientLayerWithTwoColorsViewController class] },
          @{ kTitle: @"Use CAGradientLayer", kClass: [UseCAGradientLayerWithMultipleColorsViewController class] },
          @{ kTitle: @"Add shadow border to image", kClass: [AddShadowBorderToImageViewController class] },
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
