//
//  GetAllLocaleIdentifiersViewController.m
//  HelloNSLocale
//
//  Created by wesley_chen on 2020/9/10.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "GetAllLocaleIdentifiersViewController.h"
#import "WCArrayTool.h"
#import "LocaleDetailInfoViewController.h"

@interface GetAllLocaleIdentifiersViewController ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSLocale *> *locales;
@end

@implementation GetAllLocaleIdentifiersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locales = [NSMutableDictionary dictionary];
    self.listData = [WCArrayTool sortedGroupsByPrefixCharWithStrings:[NSLocale availableLocaleIdentifiers]];
}

#pragma mark - Override

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"FadeInCellRowByRowViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sCellIdentifier];
    }
    
    NSString *localIdentifier = self.listData[indexPath.section][indexPath.row];
    cell.textLabel.text = localIdentifier;
    
    NSLocale *locale = self.locales[localIdentifier];
    if (!locale) {
        locale = [NSLocale localeWithLocaleIdentifier:localIdentifier];
        self.locales[localIdentifier] = locale;
    }
    
    cell.detailTextLabel.text = [self detailStringWithLocal:locale];
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *localIdentifier = self.listData[indexPath.section][indexPath.row];
    NSLocale *locale = self.locales[localIdentifier];
    
    LocaleDetailInfoViewController *vc = [[LocaleDetailInfoViewController alloc] initWithLocale:locale];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -

- (NSString *)detailStringWithLocal:(NSLocale *)local {
    if (@available(iOS 10.0, *)) {
        return [NSString stringWithFormat:@"countryCode: %@, languageCode: %@, scriptCode: %@, currencyCode: %@, currencySymbol: %@", local.countryCode, local.languageCode, local.scriptCode, local.currencyCode, local.currencySymbol];
    }
    else {
        return nil;
    }
}

@end
