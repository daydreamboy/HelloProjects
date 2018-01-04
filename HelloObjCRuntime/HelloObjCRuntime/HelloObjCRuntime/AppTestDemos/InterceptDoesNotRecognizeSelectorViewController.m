//
//  InterceptDoesNotRecognizeSelectorViewController.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 17/3/31.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "InterceptDoesNotRecognizeSelectorViewController.h"
#import "WCCrashTool.h"

@interface InterceptDoesNotRecognizeSelectorViewController ()
@property (nonatomic, strong) NSArray *titles;

@end

@implementation InterceptDoesNotRecognizeSelectorViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [self prepareForInit];
    }
    
    return self;
}

- (void)prepareForInit {
    self.title = @"HelloObjCRuntime";
    
    // MARK: Configure titles and classes for table view
    _titles = @[
                @"使用performSelector",
                @"[NSClassFromString(@\"UIView\") alloc] initWithXXX:]调用",
                ];
}

#pragma mark - Test Methods

- (void)test_method_0 {
    id returnVal = [self performSelector:@selector(noneExistedMethod2:arg2:test:) withObject:self];
    NSLog(@"returnVal: %@", returnVal);
}

- (void)test_method_1 {
    UIView *obj = [[NSClassFromString(@"UIView") alloc] initWithBounds:CGRectMake(0, 0, 100, 100)];
    NSLog(@"obj: %@", obj);
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
    NSString *selector = [NSString stringWithFormat:@"test_method_%ld", indexPath.row];
    [self performSelector:NSSelectorFromString(selector)];
#pragma GCC diagnostic pop
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

@end
