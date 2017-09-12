//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 12/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Department2ListViewController.h"
#import "CoreDataStack.h"

@interface Tests_DepartmentListViewController : XCTestCase

@end

@implementation Tests_DepartmentListViewController

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_totalEmployeesPerDepartment {
    
    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        Department2ListViewController *deparmentList = [Department2ListViewController new];
        deparmentList.coreDataStack = [[CoreDataStack alloc] initWithModelName:@"EmployeeDirectory2"];
        
        [self startMeasuring];
        
        __unused NSArray *arr = [deparmentList totalEmployeesPerDepartment];

        [self stopMeasuring];
    }];
}

- (void)test_totalEmployeesPerDepartmentFast {
    
    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        Department2ListViewController *deparmentList = [Department2ListViewController new];
        deparmentList.coreDataStack = [[CoreDataStack alloc] initWithModelName:@"EmployeeDirectory2"];
        
        [self startMeasuring];
        
        __unused NSArray *arr = [deparmentList totalEmployeesPerDepartmentFast];
        
        [self stopMeasuring];
    }];
}

@end
