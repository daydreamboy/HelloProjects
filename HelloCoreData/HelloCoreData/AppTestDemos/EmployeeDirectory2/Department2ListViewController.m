//
//  DepartmentListViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 07/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Department2ListViewController.h"
#import "CoreDataStack.h"
#import "Employee2+CoreDataClass.h"
#import "Employee2ListViewController.h"
#import "Department2DetailViewController.h"

@interface Department2ListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSString *> *> *items;
@property (nonatomic, copy) NSString *department;
@end

@implementation Department2ListViewController

- (instancetype)initWithCoreDataStack:(CoreDataStack *)coreDataStack {
    self = [super init];
    if (self) {
        self.coreDataStack = coreDataStack;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = [self totalEmployeesPerDepartmentFast];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // @see https://stackoverflow.com/questions/9569667/uinavigationcontroller-within-a-uitabbarcontroller-setting-the-navigation-contr
    self.tabBarController.navigationItem.title = @"Department List";
}

- (NSArray<NSDictionary<NSString *, NSString *> *> *)totalEmployeesPerDepartment {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee2"];
    NSArray<Employee2 *> *results = nil;
    @try {
        results = [self.context executeFetchRequest:fetchRequest error:nil];
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
    }
    
    NSMutableDictionary *uniqueDepartment = [NSMutableDictionary dictionary];
    for (Employee2 *employee in results) {
        NSInteger employeeCountInDepartment = [uniqueDepartment[employee.department] integerValue];
        if (employeeCountInDepartment) {
            uniqueDepartment[employee.department] = @(employeeCountInDepartment + 1);
        }
        else {
            uniqueDepartment[employee.department] = @(1);
        }
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    [uniqueDepartment enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        dictM[@"department"] = key;
        dictM[@"headCount"] = [obj stringValue];
        
        [arrM addObject:dictM];
    }];
    
    return arrM;
}

- (NSArray<NSDictionary<NSString *, NSString *> *> *)totalEmployeesPerDepartmentFast {
    NSExpressionDescription *expressionDescription = [NSExpressionDescription new];
    expressionDescription.name = @"headCount";
    expressionDescription.expression = [NSExpression expressionForFunction:@"count:" arguments:@[[NSExpression expressionForKeyPath:@"department"]]];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee2"];
    fetchRequest.propertiesToFetch = @[@"department", expressionDescription];
    fetchRequest.propertiesToGroupBy = @[@"department"];
    fetchRequest.resultType = NSDictionaryResultType;
    
    NSArray *arrM = [NSArray array];
    @try {
        arrM = [self.context executeFetchRequest:fetchRequest error:nil];
    }
    @catch (NSException *exception) {    
    }
    @finally {
    }
    
    return arrM;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableView = tableView;
    }
    
    return _tableView;
}

- (NSManagedObjectContext *)context {
    if (!_context) {
        _context = self.coreDataStack.context;
    }
    
    return _context;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *department = self.items[indexPath.row][@"department"];
    Employee2ListViewController *viewController = [[Employee2ListViewController alloc] initWithDepartment:department];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
    
    NSDictionary *dict = self.items[indexPath.row];
    NSString *department = dict[@"department"];
    
    Department2DetailViewController *viewController = [[Department2DetailViewController alloc] initWithCoreDataStack:self.coreDataStack department:department];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"Department2ListViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    
    NSDictionary *dict = self.items[indexPath.row];
    
    cell.textLabel.text = dict[@"department"];
    cell.detailTextLabel.text = dict[@"headCount"];
    
    return cell;
}

@end
