//
//  GetAllDynamicLibrariesViewController.m
//  HelloNSBundle
//
//  Created by wesley_chen on 22/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "GetAllDynamicLibrariesViewController.h"
#import "WCBundleTool.h"

@interface GetAllDynamicLibrariesViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSDictionary *dict;
@end

@implementation GetAllDynamicLibrariesViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [self prepareForInit];
    }
    
    return self;
}

- (void)prepareForInit {
    self.title = @"All Dynamic Libraries";
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    NSMutableArray *keys = [NSMutableArray array];
    
    NSArray *libraries = [WCBundleTool allDynamicLibraries];
    for (NSString *path in libraries) {
        NSString *key = [path lastPathComponent];
        [keys addObject:key];
        dictM[key] = path;
    }
    
    _titles = [keys sortedArrayUsingSelector:@selector(localizedCompare:)];
    _dict = dictM;
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
    static NSString *sCellIdentifier = @"GetAllClassNamesOfMainBundleViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sCellIdentifier];
    }
    
    cell.textLabel.text = _titles[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor redColor];
    
    cell.detailTextLabel.text = self.dict[cell.textLabel.text];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    
    return cell;
}
@end
