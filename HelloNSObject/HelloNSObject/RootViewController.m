//
//  RootViewController.m
//  AppTest
//
//  Created by wesley chen on 15/6/26.
//
//

#import "RootViewController.h"

// section1
#import "CheckNSObjectIsaVariableViewController.h"
#import "SetIVarDirectlyViewController.h"

// section2
#import "CreateClassAtRuntimeViewController.h"
#import "GetPropertiesOfClassViewController.h"
#import "CreateDynamicDelegateViewController.h"
#import "SimpleDynamicSubclassViewController.h"
#import "CreateDynamicParamModelViewController.h"

#import "SwizzleMethodByBlockViewController.h"
#import "SwizzleMethodByCategoryMethodViewController.h"
#import "SwizzleMethodByCFunctionViewController.h"


#import "IsaSwizzlingViewController.h"
#import "IsaSwizzlingIssueViewController.h"


#import "ObtainWeakVariableViewController.h"

#import "UseWCMulticastDelegateViewController.h"

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
    self.title = @"HelloObjCRuntime";

    // MARK: Configure sectionTitles and classes for table view
    NSArray<NSDictionary *> *section1 = @[
          @{ kTitle: @"Check NSObject isa", kClass: [CheckNSObjectIsaVariableViewController class] },
          @{ kTitle: @"Set ivar directly", kClass: [SetIVarDirectlyViewController class] },
    ];

    NSArray<NSDictionary *> *section2 = @[
          @{ kTitle: @"Get properties of a class", kClass: [GetPropertiesOfClassViewController class] },
          @{ kTitle: @"Create Class at runtime", kClass: [CreateClassAtRuntimeViewController class] },
          @{ kTitle: @"Simple dynamic subclass", kClass: [SimpleDynamicSubclassViewController class] },
          @{ kTitle: @"Create dynamic delegates", kClass: [CreateDynamicDelegateViewController class] },
          @{ kTitle: @"Create dynamic param model", kClass: [CreateDynamicParamModelViewController class] },
          @{ kTitle: @"Obtain weak variable by objc_loadWeakRetained()", kClass: [ObtainWeakVariableViewController class] },
    ];
    
    NSArray<NSDictionary *> *section3 = @[
          @{ kTitle: @"Swizzle method by category method", kClass: [SwizzleMethodByCategoryMethodViewController class] },
          @{ kTitle: @"Swizzle method by block", kClass: [SwizzleMethodByBlockViewController class] },
          @{ kTitle: @"Swizzle method by C function", kClass: [SwizzleMethodByCFunctionViewController class] },
          @{ kTitle: @"isa swizzling", kClass: [IsaSwizzlingViewController class] },
          @{ kTitle: @"isa swizzling for overwriting (maybe cause crash)", kClass: [IsaSwizzlingIssueViewController class] },
    ];
    
    NSArray<NSDictionary *> *section4 = @[
          @{ kTitle: @"Use WCMulticastDelegate", kClass: [UseWCMulticastDelegateViewController class] },
    ];
    
    _sectionTitles = @[
        @"NSObject",
        @"ObjC Runtime",
        @"Swizzling",
        @"WCMultipleDelegate",
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
