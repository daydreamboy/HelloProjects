//
//  GetAllClassNamesOfLazyLoadFrameworkViewController.m
//  HelloNSBundle
//
//  Created by wesley_chen on 17/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "GetAllClassNamesOfLazyLoadFrameworkViewController.h"
#import "WCBundleTool.h"

@interface GetAllClassNamesOfLazyLoadFrameworkViewController ()
@property (nonatomic, strong) NSArray *titles;
@end

@implementation GetAllClassNamesOfLazyLoadFrameworkViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [self prepareForInit];
    }
    
    return self;
}

- (void)prepareForInit {
    self.title = @"AppTest";
    
    NSString *frameworkName = @"LazyLoadFramework";
    NSError *error = nil;
    BOOL success = [WCBundleTool loadFrameworkWithName:frameworkName error:&error];
    if (success) {
        _titles = [WCBundleTool classNamesWithFrameworkImage:frameworkName];
    }
    else {
        NSLog(@"load framework failed: %@", error);
    }
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"GetAllClassNamesOfFrameworkViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    cell.textLabel.text = _titles[indexPath.row];
    
    return cell;
}

@end
