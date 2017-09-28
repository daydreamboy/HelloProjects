//
//  PagingFetchResultViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 29/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "PagingFetchResultViewController.h"
#import <CoreData/CoreData.h>
#import "CoreDataStack.h"
#import "Venue+CoreDataClass.h"
#import "Location+CoreDataClass.h"
#import "Category+CoreDataClass.h"
#import "PriceInfo+CoreDataClass.h"
#import "Stats+CoreDataClass.h"
#import "FilterViewController.h"

@interface LoadingMoreCell : UITableViewCell
- (void)startSpinning;
- (void)stopSpinning;
@end

@interface LoadingMoreCell ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UILabel *label;
@end

@implementation LoadingMoreCell

- (void)startSpinning {
    self.label.hidden = YES;
    [self.spinner startAnimating];
}

- (void)stopSpinning {
    [self.spinner stopAnimating];
    self.label.hidden = NO;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.center = CGPointMake(screenSize.width / 2.0, 64 / 2.0);
        
        [self addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 20)];
        label.text = @"No more data";
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.hidden = YES;
        label.center = CGPointMake(screenSize.width / 2.0, 64 / 2.0);
        [self addSubview:label];
        
        _spinner = view;
        _label = label;
    }
    return self;
}

@end

// add -com.apple.CoreData.SQLDebug 1 to "Argument Passed On Launch" (Product -> Edit Scheme)
// @see https://stackoverflow.com/questions/6428630/xcode4-and-core-data-how-to-enable-sql-debugging
@interface PagingFetchResultViewController () <UITableViewDelegate, UITableViewDataSource, FilterViewControllerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSAsynchronousFetchRequest *asyncFetchRequest;
@property (nonatomic, strong) NSBatchUpdateRequest *batchUpdateRequest;

@property (nonatomic, strong) NSMutableArray<Venue *> *venues;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSUInteger totalSize;
@property (nonatomic, assign) NSUInteger currentOffset;
@property (nonatomic, assign) NSUInteger stepSize;
@property (nonatomic, assign) BOOL isLoadingMore;
@property (nonatomic, assign) BOOL isLoadingToEnd;

@end

@implementation PagingFetchResultViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentOffset = 0;
        _stepSize = 12;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterItemClicked:)];
    self.navigationItem.rightBarButtonItem = filterItem;
    
    [self importJSONSeedDataIfNeeded];
    
    [self queryDataWithOffset:self.currentOffset limit:self.stepSize predicate:nil sortDescriptors:nil completion:nil];
}

// reset: YES, reset to initial status with specific predicate and sorts
- (void)queryDataWithOffset:(NSUInteger)offset limit:(NSUInteger)limit predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors reset:(BOOL)reset completion:(void (^)(BOOL isEnd))completion {
    
    self.fetchRequest.fetchOffset = offset;
    self.fetchRequest.fetchLimit = limit;
    self.fetchRequest.predicate = predicate;
    self.fetchRequest.sortDescriptors = sortDescriptors;
    
    __weak typeof(self) weak_self = self;
    self.asyncFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:self.fetchRequest completionBlock:^(NSAsynchronousFetchResult * _Nonnull result) {
        
        NSArray *results = result.finalResult;
        if (results.count) {
            if ([[weak_self.venues lastObject] isKindOfClass:[NSNull class]]) {
                [weak_self.venues removeLastObject];
            }
            
            NSMutableArray *arrM = [NSMutableArray array];
            if (weak_self.venues.count && !reset) {
                [arrM addObjectsFromArray:weak_self.venues];
            }
            [arrM addObjectsFromArray:result.finalResult];
            [arrM addObject:[NSNull null]];
            weak_self.venues = arrM;
            
            // @see https://stackoverflow.com/questions/25958282/uitableview-reloaddata-does-not-refresh-displayed-cells
            dispatch_async(dispatch_get_main_queue(), ^{
                [weak_self.tableView reloadData];
                weak_self.isLoadingMore = NO;
                !completion ?: completion(NO);
            });
        }
        else {
            // no more data to load
            dispatch_async(dispatch_get_main_queue(), ^{
                if (reset) {
                    [weak_self.venues removeAllObjects];
                    [weak_self.tableView reloadData];
                }
                else {
                    !completion ?: completion(YES);
                }
            });
        }
    }];
    
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

- (void)queryDataWithOffset:(NSUInteger)offset limit:(NSUInteger)limit predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors completion:(void (^)(BOOL isEnd))completion {
    
    [self queryDataWithOffset:offset limit:limit predicate:predicate sortDescriptors:sortDescriptors reset:NO completion:completion];
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

- (NSFetchRequest *)fetchRequest {
    if (!_fetchRequest) {
        _fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Venue"];
    }
    
    return _fetchRequest;
}

#pragma mark - Actions

- (void)filterItemClicked:(id)sender {
    FilterViewController *viewController = [[FilterViewController alloc] initWithContext:self.context];
    viewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark -

- (void)importJSONSeedDataIfNeeded {
    // Note: create a NSFetchRequest with entity name
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Venue"];
    NSError *error = nil;
    
    self.totalSize = [self.context countForFetchRequest:fetchRequest error:&error];
    if (!self.totalSize) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Venue *venue = self.venues[indexPath.row];
    
    UITableViewCell *cell = nil;
    
    if ([venue isKindOfClass:[Venue class]]) {
        static NSString *sCellIdentifier1 = @"PagingFetchResultViewController_sCellIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sCellIdentifier1];
        }
        
        cell.textLabel.text = venue.name;
        cell.detailTextLabel.text = venue.priceInfo.priceCategory;
    }
    else if ([venue isKindOfClass:[NSNull class]]) {
        // load more
        static NSString *sCellIdentifier2 = @"PagingFetchResultViewController_sCellIdentifier_loadMore";
        cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier2];
        if (!cell) {
            cell = [[LoadingMoreCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sCellIdentifier2];
        }
        
        LoadingMoreCell *loadingMoreCell = (LoadingMoreCell *)cell;
        if (!self.isLoadingToEnd) {
            [loadingMoreCell startSpinning];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self doLoadingMoreWithCompletion:^(BOOL isEnd) {
                    if (isEnd) {
                        self.isLoadingToEnd = YES;
                        [loadingMoreCell stopSpinning];
                    }
                }];
            });
        }
        else {
            [loadingMoreCell stopSpinning];
        }
    }

    return cell;
}

#pragma mark - FilterViewControllerDelegate

- (void)filterViewController:(FilterViewController *)viewController didSelectPredicate:(NSPredicate *)predicate sortDescriptor:(NSSortDescriptor *)sortDescriptor {
    
    NSArray *sorts = nil;
    if (sortDescriptor) {
        sorts = @[sortDescriptor];
    }
    
    // Reset venues
    self.currentOffset = 0;
    self.stepSize = 12;
    self.isLoadingToEnd = NO;
    [self queryDataWithOffset:self.currentOffset limit:self.stepSize predicate:predicate sortDescriptors:sorts reset:YES completion:nil];
}

#pragma mark - 

- (void)doLoadingMoreWithCompletion:(void (^)(BOOL isEnd))completion {
    // Note: avoid to load more twice when it's on loading
    if (!self.isLoadingMore) {
        if (self.currentOffset + self.stepSize < self.totalSize) {
            self.currentOffset = self.currentOffset + self.stepSize;
            
            self.isLoadingMore = YES;
            NSLog(@"query more");
            [self queryDataWithOffset:self.currentOffset limit:self.stepSize predicate:self.fetchRequest.predicate sortDescriptors:self.fetchRequest.sortDescriptors completion:completion];
        }
        else {
            // Note: if no more to load, just callback directly
            !completion ?: completion(YES);
        }
    }
}

@end
