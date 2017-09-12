//
//  Employee2DetailViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 09/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Employee2DetailViewController.h"
#import "Employee2PictureViewController.h"

@interface Employee2DetailViewController ()
@property (nonatomic, strong) Employee2 *employee;
@property (nonatomic, strong) NSDateFormatter *formatter;
@end

@implementation Employee2DetailViewController

- (instancetype)initWithEmployee:(Employee2 *)employee {
    self = [super init];
    if (self) {
        _employee = employee;
        _formatter = [NSDateFormatter new];
        _formatter.dateFormat = @"MM/dd/yyyy";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.tabBarController.navigationItem.title = self.employee.name;
    
    self.headShotImageView.image = [UIImage imageWithData:self.employee.pictureThumbnail];
    self.nameLabel.text = self.employee.name;
    self.departmentLabel.text = self.employee.department;
    self.emailLabel.text = self.employee.email;
    self.phoneNumberLabel.text = self.employee.phone;
    self.startDateLabel.text = [self.formatter stringFromDate:self.employee.startDate];
    self.vacationDaysLabel.text = [NSString stringWithFormat:@"%ld", (long)self.employee.vacationDays];
    self.bioTextView.text = self.employee.about;
    self.salesCountLabel.text = [self salesCountForEmployeeFast:self.employee];
}

- (NSString *)salesCountForEmployee:(Employee2 *)employee {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Sale2"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"employee == %@", employee];
    NSString *retVal = @"0";
    
    @try {
        NSError *error = nil;
        
        NSManagedObjectContext *context = employee.managedObjectContext;
        NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
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

- (NSString *)salesCountForEmployeeFast:(Employee2 *)employee {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Sale2"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"employee == %@", employee];
    NSString *retVal = @"0";
    
    @try {
        NSError *error = nil;
        
        NSManagedObjectContext *context = employee.managedObjectContext;
        NSUInteger result = [context countForFetchRequest:fetchRequest error:&error];
        if (!error) {
            retVal = [NSString stringWithFormat:@"%ld", (long)result];
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

- (NSString *)salesCountForEmployeeSimple:(Employee2 *)employee {
    NSString *retVal = @"0";
    
    @try {
        NSError *error = nil;
        
        NSUInteger result = employee.sales.count;
        if (!error) {
            retVal = [NSString stringWithFormat:@"%ld", (long)result];
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

#pragma mark - Actions

- (IBAction)headShotImageViewTapped:(id)sender {
    Employee2PictureViewController *viewController = [[Employee2PictureViewController alloc] initWithEmployee:self.employee];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
