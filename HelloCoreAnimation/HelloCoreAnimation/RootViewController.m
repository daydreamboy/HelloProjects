//
//  RootViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/1/24.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "RootViewController.h"

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
    self.title = @"Core Animations";
    _titles = @[
                @"Scale (UIView animation)",
                @"Fade (UIView animation)",
                @"Expand",
                @"Fade with UILabel (UIView animation)",
                @"Rotation",
                @"borderWidth",
                @"backgroundColor",
                @"borderColor",
                @"contents",
                @"cornerRadius",
                @"rotate card",
                @"play with ball",
                @"Flip image view",
                @"@animationImages (UIImageView)",
                @"Group Animation",
                @"Particle Animation",
                @"Uberworks1",
                ];
    _classes = @[
                 [ScaleViewController class],
                 [FadeViewController class],
                 [ExpandViewController class],
                 [FadeWithLabelViewController class],
                 [RotationViewController class],
                 [BorderWidthViewController class],
                 [BackgroundColorViewController class],
                 [BorderColorViewController class],
                 [ContentsViewController class],
                 [CornerRadiusViewController class],
                 [CardViewControler class],
                 [BallViewController class],
                 [FlipImageViewViewController class],
                 [AnimationImagesViewController class],
                 [GroupAnimationViewController class],
                 [ParticleFadeViewController class],
                 [Uberworks1ViewController class],
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
    static NSString *TableViewCellIdentifier = @"TableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _titles[indexPath.row];
    
    return cell;
}

- (void)pushViewController:(Class)viewControllerClass {
    NSAssert([viewControllerClass isSubclassOfClass:[UIViewController class]], @"%@ is not sublcass of UIViewController", NSStringFromClass(viewControllerClass));
    
    UIViewController *vc = [[viewControllerClass alloc] init];
    vc.title = _titles[[_classes indexOfObject:viewControllerClass]];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
