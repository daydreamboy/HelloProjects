//
//  Employee2ListViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 11/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Employee2ListViewController.h"
#import "CoreDataStack.h"
#import "Employee2+CoreDataClass.h"
#import "Sale2+CoreDataClass.h"
#import "Employee2Picture+CoreDataClass.h"
#import "EmployeeTableViewCell.h"
#import "Employee2DetailViewController.h"

@interface Employee2ListViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, assign) NSUInteger amountToImport;
@property (nonatomic, assign) BOOL addSalesRecords;
@property (nonatomic, copy) NSString *deparment;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation Employee2ListViewController

- (instancetype)initWithDepartment:(NSString *)department {
    self = [self init];
    if (self) {
        _deparment = department;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _amountToImport = 50;
        _addSalesRecords = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(navBackItemClicked:)];
    
    [self importJSONSeedDataIfNeeded];
    
    // @see https://stackoverflow.com/a/13629655
    UINib *nib = [UINib nibWithNibName:@"EmployeeTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"EmployeeTableViewCell_Identifier"];
    
    [self.view addSubview:self.tableView];
}

- (void)navBackItemClicked:(id)sender {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)prepareContextAndCoreData {
    [self context]; // Note: initialize the coreData and context
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.navigationItem.title = @"Employee List";
}

#pragma mark - Getter

- (NSManagedObjectContext *)context {
    if (!_context) {
        CoreDataStack *coreDataStack = [[CoreDataStack alloc] initWithModelName:@"EmployeeDirectory2"];
        self.coreDataStack = coreDataStack;
        _context = coreDataStack.context;
    }
    
    return _context;
}

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

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee2"];
        fetchRequest.sortDescriptors = @[sort];
        //fetchRequest.fetchBatchSize = 10;
        
        if (self.deparment.length) {
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"department == %@", self.deparment];
        }
        
        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
        controller.delegate = self;
        
        @try {
            NSLog(@"start: %f", CACurrentMediaTime());
            [controller performFetch:nil];
            NSLog(@"end: %f", CACurrentMediaTime());
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        _fetchedResultsController = controller;
    }
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Employee2 *employee = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Employee2DetailViewController *viewController = [[Employee2DetailViewController alloc] initWithEmployee:employee];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160.0;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EmployeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmployeeTableViewCell_Identifier"];
    
    Employee2 *employee = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.nameLabel.text = employee.name;
    cell.departmentLabel.text = employee.department;
    cell.emailLabel.text = employee.email;
    cell.phoneNumberLabel.text = employee.phone;
    cell.pictureImageView.image = [UIImage imageWithData:employee.pictureThumbnail];
    
    return cell;
}

#pragma mark - Import Seed Data

- (void)importJSONSeedDataIfNeeded {
    // Note: create a NSFetchRequest with entity name
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee2"];
    NSError *error = nil;
    
    BOOL importRequired = NO;
    NSUInteger count = [self.context countForFetchRequest:fetchRequest error:&error];
    if (count != self.amountToImport) {
        importRequired = YES;
    }
    
    if (!importRequired && self.addSalesRecords) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Sale2"];
        
        NSUInteger countForSale = [self.context countForFetchRequest:fetchRequest error:nil];
        if (!countForSale) {
            importRequired = YES;
        }
    }
    
    if (importRequired) {
        @try {
            NSBatchDeleteRequest *batchDelete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"Employee2"]];
            batchDelete.resultType = NSCountResultType;
            
            NSBatchDeleteResult *result = [self.context executeRequest:batchDelete error:nil];
            NSInteger deletedObjectCount = [result.result integerValue];
            NSLog(@"Removed %ld objects", (long)deletedObjectCount);
            
            [self saveContext];
            
            NSUInteger numberOfRecords = MAX(0, MIN(500, self.amountToImport));
            [self importJSONSeedData:numberOfRecords];
        }
        @catch (NSException *exception) {
            NSLog(@"exception: %@", exception);
        }
        @finally {
            
        }
    }
}

- (void)saveContext {
    [self.coreDataStack saveContext];
}

- (void)importJSONSeedData:(NSUInteger)numberOfRecords {
    NSURL *jsonURL = [[NSBundle mainBundle] URLForResource:@"EmployeeDirectory2_seed" withExtension:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSEntityDescription *Employee2Entity = [NSEntityDescription entityForName:@"Employee2" inManagedObjectContext:self.context];
    NSEntityDescription *employeePictureEntity = [NSEntityDescription entityForName:@"Employee2Picture" inManagedObjectContext:self.context];
    
    @try {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        NSInteger counter = 0;
        
        for (NSDictionary *dict in arr) {
            counter += 1;
            
            NSString *guid = dict[@"guid"];
            BOOL active = [dict[@"active"] boolValue];
            int32_t vacationDays = [dict[@"vacationDays"] intValue];
            NSString *department = dict[@"department"];
            NSString *startDate = dict[@"startDate"];
            NSString *name = dict[@"name"];
            NSString *email = dict[@"email"];
            NSString *phone = dict[@"phone"];
            NSString *address = dict[@"address"];
            NSString *about = dict[@"about"];
            NSString *picture = dict[@"picture"];
            NSArray *pictureComponents = [picture componentsSeparatedByString:@"."];
            NSString *pictureFileName = pictureComponents[0];
            NSString *pictureFileExtension = pictureComponents[1];
            NSURL *pictureURL = [[NSBundle mainBundle] URLForResource:pictureFileName withExtension:pictureFileExtension];
            NSData *pictureData = [NSData dataWithContentsOfURL:pictureURL];
            
            Employee2 *employee = [[Employee2 alloc] initWithEntity:Employee2Entity insertIntoManagedObjectContext:self.context];
            employee.guid = guid;
            employee.active = active;
            employee.name = name;
            employee.vacationDays = vacationDays;
            employee.department = department;
            employee.startDate = [formatter dateFromString:startDate];
            employee.email = email;
            employee.phone = phone;
            employee.address = address;
            employee.about = about;
            employee.pictureThumbnail = [self imageDataWithData:pictureData scaledToHeight:120];
            
            Employee2Picture *pictureObject = [[Employee2Picture alloc] initWithEntity:employeePictureEntity insertIntoManagedObjectContext:self.context];
            pictureObject.picture = pictureData;
            
            employee.picture = pictureObject;
            
            if (self.addSalesRecords) {
                [self addSalesRecordsToEmployee:employee];
            }
            
            if (counter == numberOfRecords) {
                break;
            }
            
            if (counter % 20 == 0) {
                [self saveContext];
                // Note: `reset` will clear all registeredObjects for the context
                [self.context reset];
            }
        }
        
        [self saveContext];
        [self.context reset];
        NSLog(@"Imported %ld employees", (long)counter);
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
    @finally {
        
    }
}

- (void)addSalesRecordsToEmployee:(Employee2 *)employee {
    
    NSEntityDescription *saleEnity = [NSEntityDescription entityForName:@"Sale2" inManagedObjectContext:self.context];
    
    NSInteger numberOfSales = 1000 + arc4random_uniform(5000);
    for (NSInteger i = 0; i < numberOfSales; i++) {
        Sale2 *sale = [[Sale2 alloc] initWithEntity:saleEnity insertIntoManagedObjectContext:self.context];
        sale.employee = employee;
        sale.amount = 3000 + arc4random_uniform(20000);
    }
    NSLog(@"added %ld sales", (long)employee.sales.count);
}

- (NSData *)imageDataWithData:(NSData *)data scaledToHeight:(CGFloat)height {
    UIImage *image = [UIImage imageWithData:data];
    CGFloat oldHeight = image.size.height;
    CGFloat scaleFactor = height / oldHeight;
    CGFloat newWidth = image.size.width * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, height);
    CGRect newRect = CGRectMake(0, 0, newWidth, height);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImageJPEGRepresentation(newImage, 0.8);
}

@end
