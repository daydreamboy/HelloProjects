//
//  FetchResultViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 29/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "FetchResultViewController.h"
#import <CoreData/CoreData.h>
#import "CoreDataStack.h"
#import "Venue+CoreDataClass.h"
#import "Location+CoreDataClass.h"
#import "Category+CoreDataClass.h"
#import "PriceInfo+CoreDataClass.h"
#import "Stats+CoreDataClass.h"
#import "FilterViewController.h"

// add -com.apple.CoreData.SQLDebug 1 to "Argument Passed On Launch" (Product -> Edit Scheme)
// @see https://stackoverflow.com/questions/6428630/xcode4-and-core-data-how-to-enable-sql-debugging
@interface FetchResultViewController () <UITableViewDelegate, UITableViewDataSource, FilterViewControllerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSAsynchronousFetchRequest *asyncFetchRequest;
@property (nonatomic, strong) NSBatchUpdateRequest *batchUpdateRequest;

@property (nonatomic, strong) NSArray<Venue *> *venues;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FetchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.batchUpdateRequest = [NSBatchUpdateRequest batchUpdateRequestWithEntityName:@"Venue"];
    self.batchUpdateRequest.propertiesToUpdate = @{ @"favorite": @(YES) };
    self.batchUpdateRequest.affectedStores = self.context.persistentStoreCoordinator.persistentStores;
    self.batchUpdateRequest.resultType = NSUpdatedObjectsCountResultType;
    
    @try {
        [self.context performBlockAndWait:^{
            NSBatchUpdateResult *result = [self.context executeRequest:self.batchUpdateRequest error:nil];
            NSLog(@"Records updated %@", result.result);
        }];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    [self.view addSubview:self.tableView];
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterItemClicked:)];
    self.navigationItem.rightBarButtonItem = filterItem;
    
    [self importJSONSeedDataIfNeeded];
    
    /*
    NSManagedObjectModel *model = self.context.persistentStoreCoordinator.managedObjectModel;
    // Note: get NSFetchRequest from template (.momd)
    self.fetchRequest = [model fetchRequestTemplateForName:@"FetchRequest"];
     */
    self.fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Venue"];
    
    __weak typeof(self) weak_self = self;
    self.asyncFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:self.fetchRequest completionBlock:^(NSAsynchronousFetchResult * _Nonnull result) {
        weak_self.venues = result.finalResult;
        [weak_self.tableView reloadData];
    }];
    
    /*
    [self fetchAndReload];
     */
    [self asyncFetchAndReload];
}

#pragma mark - Getters

- (NSManagedObjectContext *)context {
    if (!_context) {
        CoreDataStack *coreDataStack = [[CoreDataStack alloc] initWithModelName:@"Bubble_Tea_Finder"];
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

#pragma mark - Actions

- (void)filterItemClicked:(id)sender {
    FilterViewController *viewController = [[FilterViewController alloc] initWithContext:self.context];
    viewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark -

- (void)fetchAndReload {
    @try {
        self.venues = [self.context executeFetchRequest:self.fetchRequest error:nil];
        [self.tableView reloadData];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)asyncFetchAndReload {
    @try {
        [self.context performBlockAndWait:^{
            NSError *error = nil;
            // Note: not executeFetchRequest: instead of executeRequest:
            [self.context executeRequest:self.asyncFetchRequest error:&error];
            if (error) {
                NSLog(@"error: %@", error);
            }
        }];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)importJSONSeedDataIfNeeded {
    // Note: create a NSFetchRequest with entity name
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Venue"];
    NSError *error = nil;
    
    NSUInteger count = [self.context countForFetchRequest:fetchRequest error:&error];
    if (!count) {
        @try {
            NSError *error2 = nil;
            NSArray<Venue *> *arr = [self.context executeFetchRequest:fetchRequest error:&error2];
            
            for (Venue *venue in arr) {
                [self.context deleteObject:venue];
            }
            
            [self saveContext];
            [self importJSONSeedData];
        }
        @catch (NSException *exception) {
            NSLog(@"exception: %@", exception);
        }
        @finally {
            
        }
    }
}

- (void)importJSONSeedData {
    NSURL *jsonURL = [[NSBundle mainBundle] URLForResource:@"BubbleTeaFinder_seed" withExtension:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    NSEntityDescription *venueEntity = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:self.context];
    NSEntityDescription *locationEntity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:self.context];
    NSEntityDescription *categoryEntity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.context];
    NSEntityDescription *priceEntity = [NSEntityDescription entityForName:@"PriceInfo" inManagedObjectContext:self.context];
    NSEntityDescription *statsEntity = [NSEntityDescription entityForName:@"Stats" inManagedObjectContext:self.context];
    
    @try {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        NSArray *arr = [dict valueForKeyPath:@"response.venues"];
        
        for (NSDictionary *item in arr) {
            NSString *venueName = item[@"name"];
            NSString *venuePhone = [item valueForKeyPath:@"contact.phone"];
            NSNumber *specialCount = [item valueForKeyPath:@"specials.count"];
            
            NSDictionary *locationDict = item[@"location"];
            NSDictionary *priceDict = item[@"price"];
            NSDictionary *statsDict = item[@"stats"];
            
            Location *location = [[Location alloc] initWithEntity:locationEntity insertIntoManagedObjectContext:self.context];
            location.address = locationDict[@"address"];
            location.city = locationDict[@"city"];
            location.state = locationDict[@"state"];
            location.zipcode = locationDict[@"postalCode"];
            location.distance = [locationDict[@"distance"] floatValue];
            
            Category *category = [[Category alloc] initWithEntity:categoryEntity insertIntoManagedObjectContext:self.context];
            
            PriceInfo *priceInfo = [[PriceInfo alloc] initWithEntity:priceEntity insertIntoManagedObjectContext:self.context];
            priceInfo.priceCategory = priceDict[@"currency"];
            
            Stats *stats = [[Stats alloc] initWithEntity:statsEntity insertIntoManagedObjectContext:self.context];
            stats.checkingsCount = [statsDict[@"checkinsCount"] intValue];
            stats.usersCount = [statsDict[@"userCount"] intValue];
            stats.tipCount = [statsDict[@"tipCount"] intValue];
            
            Venue *venue = [[Venue alloc] initWithEntity:venueEntity insertIntoManagedObjectContext:self.context];
            venue.name = venueName;
            venue.phone = venuePhone;
            venue.specialCount = [specialCount intValue];
            venue.location = location;
            venue.category = category;
            venue.priceInfo = priceInfo;
            venue.stats = stats;
        }
        
        [self saveContext];
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
    @finally {
        
    }
}

- (void)saveContext {
    [self.coreDataStack saveContext];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.venues.count;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"FetchResultViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sCellIdentifier];
    }
    
    Venue *venue = self.venues[indexPath.row];
    cell.textLabel.text = venue.name;
    cell.detailTextLabel.text = venue.priceInfo.priceCategory;
    
    return cell;
}

#pragma mark - FilterViewControllerDelegate

- (void)filterViewController:(FilterViewController *)viewController didSelectPredicate:(NSPredicate *)predicate sortDescriptor:(NSSortDescriptor *)sortDescriptor {
    self.fetchRequest.predicate = nil;
    self.fetchRequest.sortDescriptors = nil;
    
    if (predicate) {
        self.fetchRequest.predicate = predicate;
    }
    
    if (sortDescriptor) {
        self.fetchRequest.sortDescriptors = @[sortDescriptor];
    }
    
    [self fetchAndReload];
}

@end
