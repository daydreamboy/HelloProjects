//
//  WeakStrongDanceViewController.m
//  HelloBlocks
//
//  Created by wesley_chen on 2019/1/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WeakStrongDanceViewController.h"

@interface MyObject : NSObject
@property (nonatomic, copy) void (^block)(void);
@end

@implementation MyObject

- (void)dealloc {
    NSLog(@"deallocating %@", self);
}

@end

@interface WeakStrongDanceViewController ()
@property (nonatomic, strong) NSMutableDictionary *dictM;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *classes;
@end

@implementation WeakStrongDanceViewController

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
                @"Always use weak in block",
                @"Use weak-strong dance for block",
                ];
    _classes = @[
                 NSStringFromSelector(@selector(test_1_always_use_weak_object)),
                 NSStringFromSelector(@selector(test_2_use_weak_strong_dance)),
                 ];
}

#pragma mark - Test Methods

- (void)test_1_always_use_weak_object {
    self.dictM = [NSMutableDictionary dictionary];
    
    MyObject *object = [MyObject new];
    self.dictM[@"object"] = object;
    
    __weak typeof(object) weak_object = object;
    [NSThread detachNewThreadWithBlock:^{
        NSLog(@"1. %@ (%p)", weak_object, [NSThread currentThread]);
        
        [NSThread sleepForTimeInterval:5];
        
        NSLog(@"2. %@ (%p)", weak_object, [NSThread currentThread]);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 100; i++) {
            [NSThread detachNewThreadWithBlock:^{
                self.dictM[@"object"] = nil;
                NSLog(@"set nil (%p %d)", [NSThread currentThread], (int)i);
            }];
        }
    });
}

- (void)test_2_use_weak_strong_dance {
    self.dictM = [NSMutableDictionary dictionary];
    
    MyObject *object = [MyObject new];
    self.dictM[@"object"] = object;
    
    __weak typeof(object) weak_object = object;
    [NSThread detachNewThreadWithBlock:^{
        typeof(object) strong_object = weak_object;
        NSLog(@"1. %@ (%p)", strong_object, [NSThread currentThread]);

        [NSThread sleepForTimeInterval:5];

        NSLog(@"2. %@ (%p)", strong_object, [NSThread currentThread]);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 100; i++) {
            [NSThread detachNewThreadWithBlock:^{
                self.dictM[@"object"] = nil;
                NSLog(@"set nil (%p %d)", [NSThread currentThread], (int)i);
            }];
        }
    });
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

@end
