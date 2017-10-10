//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) NSArray *titles;
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
    self.title = @"HelloCustomXCConfig";
    
    NSString *version = [NSString stringWithFormat:@"verion (from Info.plist): %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    NSString *buildNo = [NSString stringWithFormat:@"build (from Info.plist): %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    NSString *keyFromInfoPlist = [NSString stringWithFormat:@"key (from Info.plist): %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TWITTER_CONSUMER_KEY"]];
    
    NSString *idFromPreMacro = [NSString stringWithFormat:@"key (from predefined macro): %@", APP_STORE_ID];
    NSString *keyFromPreMacro = [NSString stringWithFormat:@"key (from predefined macro): %@", APP_PUB_KEY];
    
    // MARK: Configure titles and classes for table view
    _titles = @[
        version,
        buildNo,
        keyFromInfoPlist,
        idFromPreMacro,
        keyFromPreMacro,
    ];
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
    static NSString *sCellIdentifier = @"RootViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.textLabel.text = _titles[indexPath.row];

    return cell;
}

@end
