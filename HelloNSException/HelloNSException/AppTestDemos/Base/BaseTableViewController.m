//
//  BaseTableViewController.m
//  HelloCrash
//
//  Created by wesley_chen on 23/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "BaseTableViewController.h"
#import "WCCrashCaseTool.h"

@interface BaseTableViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *classes;
@end

@implementation BaseTableViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // MARK: Configure titles and classes for table view
        _titles = @[
                    @"crash with nil parameter",
                    @"crash with array out of bound",
                    @"crash with null pointer",
                    @"crash with released object",
                    ];
        _classes = @[
                     NSStringFromSelector(@selector(makeCrashWithNilParameter)),
                     NSStringFromSelector(@selector(makeCrashWithArrayOutOfBound)),
                     NSStringFromSelector(@selector(makeCrashWithBadAccessNullPointer)),
                     NSStringFromSelector(@selector(makeCrashWithBadAccessReleasedPointer)),
                     ];
    }
    
    return self;
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id class = _classes[indexPath.row];
    if ([class isKindOfClass:[NSString class]]) {
        SEL selector = NSSelectorFromString(class);
        if ([WCCrashCaseTool respondsToSelector:selector]) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
            [WCCrashCaseTool performSelector:selector];
#pragma GCC diagnostic pop
        }
        else {
            NSAssert(NO, @"can't handle selector `%@`", class);
        }
    }
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
    }
    
    cell.textLabel.text = _titles[indexPath.row];
    
    return cell;
}

@end
