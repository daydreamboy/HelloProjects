//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

#import "SwizzleMethodByBlockViewController.h"
#import "SwizzleMethodByCategoryMethodViewController.h"
#import "SwizzleMethodByCFunctionViewController.h"
#import "CreateClassAtRuntimeViewController.h"
#import "GetPropertiesOfClassViewController.h"

#import "CheckNSObjectIsaVariableViewController.h"
#import "SetIVarDirectlyViewController.h"

#import "IsaSwizzlingViewController.h"
#import "IsaSwizzlingIssueViewController.h"
#import "CreateClassAtRuntimeViewController.h"
#import "SimpleDynamicSubclassViewController.h"
#import "CreateDynamicParamModelViewController.h"
#import "ObtainWeakVariableViewController.h"

#import "UseWCMulticastDelegateViewController.h"

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
        @"Swizzle method by block",
        @"Swizzle method by category method",
        @"Swizzle method by C function",
        @"Create class at runtime",
        @"Get properties of a class",
        
        @"浅析NSObject的isa实例变量",
        @"Set ivar directly",
        
        @"isa swizzling",
        @"isa swizzling for overwriting (maybe cause crash)",
        @"Create Class at runtime",
        @"Simple dynamic subclass",
        @"Create dynamic delegates",
        @"Obtain weak variable by objc_loadWeakRetained()",
        @"Use WCMulticastDelegate",
    ];
    _classes = @[
        [SwizzleMethodByBlockViewController class],
        [SwizzleMethodByCategoryMethodViewController class],
        [SwizzleMethodByCFunctionViewController class],
        [CreateClassAtRuntimeViewController class],
        [GetPropertiesOfClassViewController class],
        
        [CheckNSObjectIsaVariableViewController class],
        [SetIVarDirectlyViewController class],
        
        [IsaSwizzlingViewController class],
        [IsaSwizzlingIssueViewController class],
        [CreateClassAtRuntimeViewController class],
        [SimpleDynamicSubclassViewController class],
        [CreateDynamicParamModelViewController class],
        [ObtainWeakVariableViewController class],
        [UseWCMulticastDelegateViewController class],
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

- (void)pushViewController:(id)viewControllerClass {
    
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
        vc.title = _titles[[_classes indexOfObject:viewControllerClass]];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Test Methods

- (void)testMethod {
    NSLog(@"test something");
}

@end
