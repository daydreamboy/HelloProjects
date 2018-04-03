//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

#import "GetPropertiesOfClassViewController.h"
#import "CheckNSObjectIsaVariableViewController.h"
#import "SwizzleMethodByBlockViewController.h"
#import "SwizzleMethodByMethodViewController.h"
#import "IsaSwizzlingViewController.h"
#import "IsaSwizzlingIssueViewController.h"
#import "CreateClassAtRuntimeViewController.h"
#import "SimpleDynamicSubclassViewController.h"
#import "InterceptDoesNotRecognizeSelectorViewController.h"
#import "SetIVarDirectlyViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *classes;
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
    self.title = @"HelloObjCRuntime";

    // MARK: Configure titles and classes for table view
    _titles = @[
        @"Get properties of a class",
        @"浅析NSObject的isa实例变量",
        @"Swizzle method by block",
        @"Swizzle method by method",
        @"isa swizzling",
        @"isa swizzling for overwriting (maybe cause crash)",
        @"Create Class at runtime",
        @"Simple dynamic subclass",
        @"Swizzle Usage (Capture unrecognized methods)",
        @"Create dynamic delegates",
        @"Skip unsafe method",
        @"Set ivar directly",
    ];
    _classes = @[
        @"GetPropertiesOfClassViewController",
        @"CheckNSObjectIsaVariableViewController",
        @"SwizzleMethodByBlockViewController",
        @"SwizzleMethodByMethodViewController",
        @"IsaSwizzlingViewController",
        @"IsaSwizzlingIssueViewController",
        @"CreateClassAtRuntimeViewController",
        @"SimpleDynamicSubclassViewController",
        @"InterceptDoesNotRecognizeSelectorViewController",
        @"CreateDynamicParamModelViewController",
        @"SkipUnsafeMethodViewController",
//        @"CreateDynamicDelegateViewController.xib",
        @"SetIVarDirectlyViewController",
    ];
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

- (void)pushViewController:(NSString *)viewControllerClass {
    NSAssert([viewControllerClass isKindOfClass:[NSString class]], @"%@ is not NSString", viewControllerClass);
    
    BOOL useXib = NO;
    NSString *className = viewControllerClass;
    if ([className hasSuffix:@".xib"]) {
        className = [className stringByDeletingPathExtension];
        useXib = YES;
    }
    
    Class class = NSClassFromString(className);
    if (class && [class isSubclassOfClass:[UIViewController class]]) {
        UIViewController *vc = useXib ? [[class alloc] initWithNibName:className bundle:nil] : [[class alloc] init];
        vc.title = _titles[[_classes indexOfObject:viewControllerClass]];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
