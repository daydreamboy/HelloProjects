//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

// section 1
#import "MirroringUITextViewViewController.h"
#import "PagingUITextViewViewController.h"
#import "MixMirroringAndPagingUITextViewViewController.h"
#import "SyntaxHighlightUITextViewViewController.h"
#import "LinkInUITextViewViewController.h"

// section 2
#import "TextViewIssueCaretViewController.h"

// section 3
#import "UseWCPlaceholderTextViewViewController.h"

// section 4
#import "UseWCGrowingTextViewLimitedLinesViewController.h"
#import "UseWCGrowingTextViewLimitedHeightViewController.h"
#import "UseWCGrowingTextViewIssueCaretViewController.h"

// section 5
#import "UseWCMessageComposerViewViewController.h"
#import "UseWCMessageComposerViewWithItemsViewController.h"

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
          @{ kTitle: @"Mirroring UITextView", kClass: [MirroringUITextViewViewController class] },
          @{ kTitle: @"Paging UITextView", kClass: [PagingUITextViewViewController class] },
          @{ kTitle: @"Mix Mirroring & Paging UITextView", kClass: [MixMirroringAndPagingUITextViewViewController class] },
          @{ kTitle: @"Syntax highlight in UITextView", kClass: [SyntaxHighlightUITextViewViewController class] },
          @{ kTitle: @"Link in UITextView", kClass: [LinkInUITextViewViewController class] },
    ];
    
    NSArray<NSDictionary *> *section2 = @[
          @{ kTitle: @"UITextView", kClass: [TextViewIssueCaretViewController class] },
    ];
    
    NSArray<NSDictionary *> *section3 = @[
          @{ kTitle: @"Use WCPlaceholderTextView", kClass: [UseWCPlaceholderTextViewViewController class] },
    ];
    
    NSArray<NSDictionary *> *section4 = @[
          @{ kTitle: @"Use WCGrowingTextView (numberOfLines)", kClass: [UseWCGrowingTextViewLimitedLinesViewController class] },
          @{ kTitle: @"Use WCGrowingTextView (height)", kClass: [UseWCGrowingTextViewLimitedHeightViewController class] },
          @{ kTitle: @"Use WCGrowingTextView Issue", kClass: [UseWCGrowingTextViewIssueCaretViewController class] },
    ];
    
    NSArray<NSDictionary *> *section5 = @[
          @{ kTitle: @"Use WCMessageComposerView", kClass: [UseWCMessageComposerViewViewController class] },
          @{ kTitle: @"Use WCMessageComposerView with items", kClass: [UseWCMessageComposerViewWithItemsViewController class] },
    ];
    
    _sectionTitles = @[
        @"UITextView Feature",
        @"UITextView Issue",
        @"WCPlaceholderTextView",
        @"WCGrowingTextView",
        @"WCMessageComposerView",
    ];
    
    _classes = @[
         section1,
         section2,
         section3,
         section4,
         section5,
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
