//
//  DepartmentListViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 07/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Department1ListViewController.h"
#import "CoreDataStack.h"
#import "Employee1+CoreDataClass.h"
#import "Employee1ListViewController.h"

@interface Department1ListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSString *> *> *items;
@property (nonatomic, copy) NSString *department;
@end

@implementation Department1ListViewController

- (instancetype)initWithCoreDataStack:(CoreDataStack *)coreDataStack {
    self = [super init];
    if (self) {
        self.coreDataStack = coreDataStack;
        _context = coreDataStack.context;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = [self totalEmployeesPerDepartment];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // @see https://stackoverflow.com/questions/9569667/uinavigationcontroller-within-a-uitabbarcontroller-setting-the-navigation-contr
    self.tabBarController.navigationItem.title = @"Department List";
}

- (NSArray<NSDictionary<NSString *, NSString *> *> *)totalEmployeesPerDepartment {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee1"];
    NSArray<Employee1 *> *results = nil;
    @try {
        results = [self.context executeFetchRequest:fetchRequest error:nil];
    }
    @catch (NSException *exception) {
        return nil;
    }
    @finally {
    }
    
    NSMutableDictionary *uniqueDepartment = [NSMutableDictionary dictionary];
    for (Employee1 *employee in results) {
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
    Employee1ListViewController *viewController = [[Employee1ListViewController alloc] initWithDepartment:department];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"Department1ListViewController_sCellIdentifier";
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
