//
//  Tests_Department2DetailViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 13/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Department2DetailViewController.h"
#import "CoreDataStack.h"

@interface Tests_Department2DetailViewController : XCTestCase

@end

@implementation Tests_Department2DetailViewController

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)del_test_totalEmployees {

    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        
        CoreDataStack *stack = [[CoreDataStack alloc] initWithModelName:@"EmployeeDirectory2"];
        Department2DetailViewController *viewController = [[Department2DetailViewController alloc] initWithCoreDataStack:stack department:@"Sales"];
        
        [self startMeasuring];
        
        __unused NSString *retVal = [viewController totalEmployees];
        
        [self stopMeasuring];
    }];
}

- (void)del_test_totalEmployeesFast {
    
    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        
        CoreDataStack *stack = [[CoreDataStack alloc] initWithModelName:@"EmployeeDirectory2"];
        Department2DetailViewController *viewController = [[Department2DetailViewController alloc] initWithCoreDataStack:stack department:@"Sales"];
        
        [self startMeasuring];
        
        __unused NSString *retVal = [viewController totalEmployeesFast];
        
        [self stopMeasuring];
    }];
}

- (void)test_activeEmployees {
    
    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        
        CoreDataStack *stack = [[CoreDataStack alloc] initWithModelName:@"EmployeeDirectory2"];
        Department2DetailViewController *viewController = [[Department2DetailViewController alloc] initWithCoreDataStack:stack department:@"Sales"];
        
        [self startMeasuring];
        
        __unused NSString *retVal = [viewController activeEmployees];
        
        [self stopMeasuring];
    }];
}

- (void)test_activeEmployeesFast {
    
    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        
        CoreDataStack *stack = [[CoreDataStack alloc] initWithModelName:@"EmployeeDirectory2"];
        Department2DetailViewController *viewController = [[Department2DetailViewController alloc] initWithCoreDataStack:stack department:@"Sales"];
        
        [self startMeasuring];
        
        __unused NSString *retVal = [viewController activeEmployeesFast];
        
        [self stopMeasuring];
    }];
}

@end
