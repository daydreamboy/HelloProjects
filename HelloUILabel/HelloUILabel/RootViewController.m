//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

#import "UseYYLabelWithAttachmentViewController.h"
#import "UseUILabelViewController.h"
#import "UseYYLabelWithLinkViewController.h"
#import "UseYYWLabelWithEmoticonViewController.h"

// section 1
#import "LabelWithMaximumLinesViewController.h"
#import "LabelWithHyphenationViewController.h"
#import "LabelWithLinkViewController.h"
#import "TextAlignmentViewController.h"
#import "AutoFontSizeNotWorkViewController.h"
#import "AutoFontSizeViewController.h"

#import "UseYYTextViewViewController.h"

// section 4
#import "ShowLinkWithWCLabelViewController.h"

#define kTitle @"Title"
#define kClass @"Class"

@interface RootViewController ()
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray<NSArray<NSDictionary *> *> *classes;
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
    self.title = @"AppTest";
    
    // MARK: Configure sectionTitles and classes for table view
    NSArray<NSDictionary *> *section1 = @[
          @{ kTitle: @"TestUILabelViewController", kClass: [UseUILabelViewController class] },
          @{ kTitle: @"LabelWithMaximumLinesViewController", kClass: [LabelWithMaximumLinesViewController class] },
          @{ kTitle: @"LabelWithHyphenationViewController", kClass: [LabelWithHyphenationViewController class] },
          @{ kTitle: @"Label with link", kClass: [LabelWithLinkViewController class] },          
          @{ kTitle: @"TextAlignmentViewController", kClass: [TextAlignmentViewController class] },
          @{ kTitle: @"Auto font size (not work)", kClass: [AutoFontSizeNotWorkViewController class] },
          @{ kTitle: @"Auto font size", kClass: [AutoFontSizeViewController class] },
    ];

    NSArray<NSDictionary *> *section2 = @[
          @{ kTitle: @"YYLabel with Attachment", kClass: [UseYYLabelWithAttachmentViewController class] },
          @{ kTitle: @"YYLabel with Link", kClass: [UseYYLabelWithLinkViewController class] },
          @{ kTitle: @"YYLabel with Emoticon", kClass: [UseYYWLabelWithEmoticonViewController class] },
    ];
    
    NSArray<NSDictionary *> *section3 = @[
        @{ kTitle: @"YYTextView", kClass: [UseYYTextViewViewController class] },
    ];
    
    NSArray<NSDictionary *> *section4 = @[
        @{ kTitle: @"Show link", kClass: [ShowLinkWithWCLabelViewController class] },
    ];
    
    NSArray<NSDictionary *> *section5 = @[
    ];
    
    NSArray<NSDictionary *> *section6 = @[
          // TODO
    ];
    
    _sectionTitles = @[
        @"UILabel",
        @"YYLabel",
        @"YYTextView",
        @"WCLabel",
    ];
    
    _classes = @[
         section1,
         section2,
         section3,
         section4,
    ];
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = _classes[indexPath.section][indexPath.row];
    [self pushViewController:dict];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionTitles[section];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_classes count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_classes[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"RootViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *cellTitle = [_classes[indexPath.section][indexPath.row] objectForKey:kTitle];
    cell.textLabel.text = cellTitle;
    
    return cell;
}

- (void)pushViewController:(NSDictionary *)dict {
    id viewControllerClass = dict[kClass];
    
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
        vc.title = dict[kTitle];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Test Methods

- (void)testMethod {
    NSLog(@"test something");
}

@end
