//
//  DepartmentDetailViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 09/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "DepartmentDetailViewController.h"
#import <CoreData/CoreData.h>
#import "CoreDataStack.h"

@interface DepartmentDetailViewController ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSString *department;

@property (weak, nonatomic) IBOutlet UILabel *totalEmployeesLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeEmployeesLabel;
@property (weak, nonatomic) IBOutlet UILabel *greaterThanFifteenVacationDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *greaterThanTenVacationDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *greaterThanFiveVacationDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *greaterThanZeroVacationDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *zeroVacationDaysLabel;

@end

@implementation DepartmentDetailViewController

- (instancetype)initWithCoreDataStack:(CoreDataStack *)coreDataStack department:(NSString *)department {
    self = [super init];
    if (self) {
        self.coreDataStack = coreDataStack;
        _context = coreDataStack.context;
        _department = department;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.tabBarController.tabBarItem.title = self.department;
    
    self.totalEmployeesLabel.text = [self totalEmployees];
    self.activeEmployeesLabel.text = [self activeEmployees];
    self.greaterThanFifteenVacationDaysLabel.text = [self greaterThanVacationDays:15];
}

#pragma mark - Calculation

- (NSString *)totalEmployees {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee1"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"department == %@", self.department];
    
    NSString *retVal = @"0";
    
    @try {
        NSError *error = nil;
        
        NSArray *result = [self.context executeFetchRequest:fetchRequest error:&error];
        if (!error) {
            retVal = [NSString stringWithFormat:@"%ld", (long)result.count];
        }
        else {
            NSLog(@"error: %@", error);
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    return retVal;
}

- (NSString *)activeEmployees {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee1"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(department == %@) AND (active == YES)", self.department];
    
    NSString *retVal = @"0";
    
    @try {
        NSError *error = nil;
        
        NSArray *result = [self.context executeFetchRequest:fetchRequest error:&error];
        if (!error) {
            retVal = [NSString stringWithFormat:@"%ld", (long)result.count];
        }
        else {
            NSLog(@"error: %@", error);
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    return retVal;
}

- (NSString *)greaterThanVacationDays:(NSInteger)vacationDays {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee1"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(department == %@) AND (vacationDays > %i)", self.department];
    
    NSString *retVal = @"0";
    
    @try {
        NSError *error = nil;
        
        NSArray *result = [self.context executeFetchRequest:fetchRequest error:&error];
        if (!error) {
            retVal = [NSString stringWithFormat:@"%ld", (long)result.count];
        }
        else {
            NSLog(@"error: %@", error);
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    return retVal;
}


@end
