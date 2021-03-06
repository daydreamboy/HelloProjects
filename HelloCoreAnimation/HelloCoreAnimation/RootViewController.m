//
//  RootViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/1/24.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "RootViewController.h"

// section1
#import "UseCAShapeLayerToShowViewWithTwoCornersViewController.h"
#import "DrawGradientViewViewController.h"
#import "DrawRadialGradientViewViewController.h"
#import "UseCAGradientLayerWithTwoColorsViewController.h"
#import "UseCAGradientLayerWithMultipleColorsViewController.h"
#import "StretchImageInLayerViewController.h"
#import "AddShadowBorderToImageViewController.h"
#import "AddBorderToImageViewController.h"
#import "TwoAdjacentShadowBorderViewController.h"

// section2
#import "ScaleViewController.h"
#import "FadeViewController.h"
#import "ExpandViewController.h"
#import "FadeWithLabelViewController.h"
#import "RotationViewController.h"
#import "BorderWidthViewController.h"
#import "BackgroundColorViewController.h"
#import "BorderColorViewController.h"
#import "ContentsViewController.h"
#import "CornerRadiusViewController.h"
#import "CardViewControler.h"
#import "BallViewController.h"
#import "FlipImageViewViewController.h"
#import "AnimationImagesViewController.h"
#import "GroupAnimationViewController.h"
#import "ParticleFadeViewController.h"
#import "Uberworks1ViewController.h"
#import "ShrinkViewController.h"

// secion3
#import "LayerAnimateWithPositionController.h"

// section4
#import "ShapeAnimateWithPathViewController.h"
#import "ShapeAnimateWithFillColorViewController.h"
#import "ShapeAnimateWithStrokeColorViewController.h"
#import "ShapeAnimateWithStrokeStartEndViewController.h"
#import "ShapeAnimateWithLineDashPhaseViewController.h"
#import "ShapeAnimateWithLineWidthViewController.h"
#import "ShapeAnimateWithMiterLimitViewController.h"

// section5
#import "BasicAnimationViewController.h"
#import "TimingFunctionAnimationViewController.h"

// section6
#import "KeyframeAnimationViewController.h"

// section7
#import "AnimationGroupViewController.h"
#import "AnimationCircleMenuViewController.h"

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
    
    NSArray<NSDictionary *> *section1 = @[
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

    // MARK: Configure titles and classes for table view
    NSArray<NSDictionary *> *section2 = @[
          @{ kTitle: @"Scale (UIView animation)", kClass: [ScaleViewController class], },
          @{ kTitle: @"Fade (UIView animation)", kClass: [FadeViewController class],},
          @{ kTitle: @"Expand", kClass: [ExpandViewController class], },
          @{ kTitle: @"Fade with UILabel (UIView animation)", kClass: [FadeWithLabelViewController class], },
          @{ kTitle: @"Rotation", kClass: [RotationViewController class], },
          @{ kTitle: @"borderWidth", kClass: [BorderWidthViewController class], },
          @{ kTitle: @"backgroundColor", kClass: [BackgroundColorViewController class], },
          @{ kTitle: @"borderColor", kClass: [BorderColorViewController class], },
          @{ kTitle: @"contents", kClass: [ContentsViewController class], },
          @{ kTitle: @"cornerRadius", kClass: [CornerRadiusViewController class], },
          @{ kTitle: @"rotate card", kClass: [CardViewControler class], },
          @{ kTitle: @"play with ball", kClass: [BallViewController class], },
          @{ kTitle: @"Flip image view", kClass: [FlipImageViewViewController class], },
          @{ kTitle: @"@animationImages (UIImageView)", kClass: [AnimationImagesViewController class], },
          @{ kTitle: @"Group Animation", kClass: [GroupAnimationViewController class], },
          @{ kTitle: @"Particle Animation", kClass: [ParticleFadeViewController class], },
          @{ kTitle: @"Uberworks1", kClass: [Uberworks1ViewController class], },
          @{ kTitle: @"Shrink", kClass: [ShrinkViewController class], },
    ];
    
    NSArray<NSDictionary *> *section3 = @[
          @{ kTitle: @"Position", kClass: [LayerAnimateWithPositionController class] },
    ];
    
    NSArray<NSDictionary *> *section4 = @[
          @{ kTitle: @"Path", kClass: [ShapeAnimateWithPathViewController class] },
          @{ kTitle: @"Fill Color", kClass: [ShapeAnimateWithFillColorViewController class] },
          @{ kTitle: @"Stroke Color", kClass: [ShapeAnimateWithStrokeColorViewController class] },
          @{ kTitle: @"Stroke Start/End", kClass: [ShapeAnimateWithStrokeStartEndViewController class] },
          @{ kTitle: @"Line Dash Phase", kClass: [ShapeAnimateWithLineDashPhaseViewController class] },
          @{ kTitle: @"Line Width", kClass: [ShapeAnimateWithLineWidthViewController class] },
          @{ kTitle: @"Miter Limit", kClass: [ShapeAnimateWithMiterLimitViewController class] },
    ];
    
    NSArray<NSDictionary *> *section5 = @[
          @{ kTitle: @"Basic", kClass: [BasicAnimationViewController class] },
          @{ kTitle: @"Timing Function", kClass: [TimingFunctionAnimationViewController class] },
    ];
    
    NSArray<NSDictionary *> *section6 = @[
          @{ kTitle: @"Keyframe", kClass: [KeyframeAnimationViewController class] },
    ];
    
    NSArray<NSDictionary *> *section7 = @[
          @{ kTitle: @"Animation Group", kClass: [AnimationGroupViewController class] },
          @{ kTitle: @"Animation Circle Menu", kClass: [AnimationCircleMenuViewController class] },          
    ];

    _sectionTitles = @[
        @"CALayer Presentation",
        @"UIView Animation",
        @"CALayer Animation",
        @"CAShapeLayer Animation",
        @"CABasicAnimation Animation",
        @"CAKeyframeAnimation Animation",
        @"CAAnimationGroup Animation",
    ];
    
    _classes = @[
         section1,
         section2,
         section3,
         section4,
         section5,
         section6,
         section7,
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
