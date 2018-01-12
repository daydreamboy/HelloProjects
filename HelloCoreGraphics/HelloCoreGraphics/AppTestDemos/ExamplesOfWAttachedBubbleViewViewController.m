//
//  ExamplesOfWAttachedBubbleViewViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 11/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "ExamplesOfWAttachedBubbleViewViewController.h"
#import "AttachedBubbleWithUpArrowViewController.h"
#import "AttachedBubbleWithDownArrowViewController.h"
#import "AttachedBubbleWithLeftArrowViewController.h"
#import "AttachedBubbleWithRightArrowViewController.h"

@interface ExamplesOfWAttachedBubbleViewViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *classes;
@end

@implementation ExamplesOfWAttachedBubbleViewViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"Examples of WCAttachedBubbleView";
        
        // MARK: Configure titles and classes for table view
        _titles = @[
                    @"Attached bubble with up arrow",
                    @"Attached bubble with down arrow",
                    @"Attached bubble with left arrow",
                    @"Attached bubble with right arrow",
                    ];
        _classes = @[
                     [AttachedBubbleWithUpArrowViewController class],
                     [AttachedBubbleWithDownArrowViewController class],
                     [AttachedBubbleWithLeftArrowViewController class],
                     [AttachedBubbleWithRightArrowViewController class],
                     ];
    }
    
    return self;
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
    if ([class isKindOfClass:[NSString class]]){
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

@end
