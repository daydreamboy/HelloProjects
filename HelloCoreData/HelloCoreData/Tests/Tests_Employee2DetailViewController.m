//
//  Tests_Employee2DetailViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 12/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Employee2DetailViewController.h"
#import "CoreDataStack.h"

@interface Tests_Employee2DetailViewController : XCTestCase

@end

@implementation Tests_Employee2DetailViewController

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_salesCountForEmployee {
    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        Employee2 *employee = [self getEmployee];
        Employee2DetailViewController *viewController = [Employee2DetailViewController new];
        [self startMeasuring];
        
        __unused NSString *retVal = [viewController salesCountForEmployee:employee];
        
        [self stopMeasuring];
    }];
}

- (void)test_salesCountForEmployeeFast {
    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        Employee2 *employee = [self getEmployee];
        Employee2DetailViewController *viewController = [Employee2DetailViewController new];
        [self startMeasuring];
        
        __unused NSString *retVal = [viewController salesCountForEmployeeFast:employee];
        
        [self stopMeasuring];
    }];
}

- (void)test_salesCountForEmployeeSimple {
    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        Employee2 *employee = [self getEmployee];
        Employee2DetailViewController *viewController = [Employee2DetailViewController new];
        [self startMeasuring];
        
        __unused NSString *retVal = [viewController salesCountForEmployeeSimple:employee];
        
        [self stopMeasuring];
    }];
}

- (Employee2 *)getEmployee {
    CoreDataStack *coreDataStack = [[CoreDataStack alloc] initWithModelName:@"EmployeeDirectory2"];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee2"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"guid" ascending:YES]];
    fetchRequest.fetchBatchSize = 1;
    
    NSArray *arr = nil;
    @try {
        arr = [coreDataStack.context executeFetchRequest:fetchRequest error:nil];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
    }
    
    if (arr.count) {
        return arr[0];
    }
    else {
        return nil;
    }
}

@end
