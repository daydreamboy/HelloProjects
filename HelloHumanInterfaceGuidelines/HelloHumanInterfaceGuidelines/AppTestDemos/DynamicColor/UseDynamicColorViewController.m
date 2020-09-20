//
//  UseDynamicColorViewController.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/2.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseDynamicColorViewController.h"
#import "DGUITheme.h"
#import "WCMacroTool.h"
#import "DGIMUIThemeProvider.h"

#define font_color        @"font_color"
#define unread_font_color @"unread_font_color"

@interface UseDynamicColorViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation UseDynamicColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [DGUIThemeManager sharedManager].themeProvider = [[DGIMUIThemeProvider alloc]init];
    [DGUIThemeManager sharedManager].currentThemeIdentifier = ThemeID1;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UISwitch *switcher = [UISwitch new];
        [switcher addTarget:self action:@selector(switcherToggled:) forControlEvents:UIControlEventValueChanged];
        switcher;
    })];
    self.navigationItem.rightBarButtonItem = refreshItem;
}

#pragma mark - Getter

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
        label.attributedText = [self getAttributedString];
        
        _label = label;
    }
    
    return _label;
}

#pragma mark -

- (NSMutableAttributedString *)getAttributedString {
    NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = ({
        [UIColor dgui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof NSString * _Nullable colorKey, __kindof NSString * _Nullable defaultHexValue) {
            return [[DGUIThemeManager sharedManager] themeColorForKey:colorKey defaultHexValue:defaultHexValue];
        }
                                    colorKey:font_color defaultColorHexValue:@"#x111F2C66"];
        
    });//UICOLOR_RGBA(0x111F2C66);
    
    NSString *formatedValue = [NSString stringWithFormat:@"%@ ", @"[未读]"];
    [attrStringM appendAttributedString:ASTR2(formatedValue, attributes)];
    
    NSMutableDictionary *attributesM = [NSMutableDictionary dictionaryWithDictionary:attributes];
    attributesM[NSForegroundColorAttributeName] = ({
        [UIColor dgui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof NSString * _Nullable colorKey, __kindof NSString * _Nullable defaultHexValue) {
            return [[DGUIThemeManager sharedManager] themeColorForKey:colorKey defaultHexValue:defaultHexValue];
        }
                                    colorKey:unread_font_color defaultColorHexValue:@"#0089FF"];
        
    });
    
    [attrStringM appendAttributedString:ASTR2(@"为什么面膜", attributesM)];
    
    return attrStringM;
}

#pragma mark - Action

- (void)switcherToggled:(id)sender {
    UISwitch *switcher = (UISwitch *)sender;
    
    if (switcher.on) {
        [DGUIThemeManager sharedManager].currentThemeIdentifier = ThemeID2;
    }
    else {
        [DGUIThemeManager sharedManager].currentThemeIdentifier = ThemeID1;
    }
}

@end
