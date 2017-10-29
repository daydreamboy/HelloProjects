//
//  JournalListViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 18/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "JournalListViewController.h"
#import "CoreDataStack.h"
#import "SurfEntryTableViewCell.h"
#import "JournalEntry.h"
#import "JournalEntryViewController.h"
#import <AvailabilityMacros.h>

#ifndef IOS10_OR_LATER
#define IOS10_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

#define SEED_NAME   @"SurfJournalDatabase"

@interface JournalListViewController () <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, JournalEntryViewControllerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchRequest *fetchRequestSurfJournal;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JournalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self importSeedDataIfNeeded];
    
    UINib *nib = [UINib nibWithNibName:@"SurfEntryTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"JournalListViewController_sCellIdentifier"];
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItems = [self normalRightBarItems];
}

#pragma mark -

- (UIBarButtonItem *)createExportItem {
    UIBarButtonItem *exportItem = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(exportItemClicked:)];
    return exportItem;
}

- (UIBarButtonItem *)createActivityIndicatorItem {
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *activityIndicatorItem = [[UIBarButtonItem alloc] initWithCustomView:loadingView];
    [loadingView startAnimating];
    return activityIndicatorItem;
}

- (UIBarButtonItem *)createAddItem {
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItemClicked:)];
    return addItem;
}

- (UIBarButtonItem *)createScollToBottomItem {
    UIBarButtonItem *scrollToBottomItem = [[UIBarButtonItem alloc] initWithTitle:@"⬇︎" style:UIBarButtonItemStylePlain target:self action:@selector(scrollToBottomItemClicked:)];
    return scrollToBottomItem;
}

- (NSArray<UIBarButtonItem *> *)normalRightBarItems {
    return @[[self createScollToBottomItem], [self createAddItem], [self createExportItem]];
}

- (void)exportCSVFile {
    self.navigationItem.rightBarButtonItem = [self createActivityIndicatorItem];
    
    NSError *error = nil;
    NSArray *results = nil;
    @try {
        NSTimeInterval start = CACurrentMediaTime();
        results = [self.context executeFetchRequest:self.fetchRequestSurfJournal error:&error];
        NSTimeInterval end = CACurrentMediaTime();
        
        NSLog(@"fetch all data time: %f", end - start);
    }
    @catch (NSException *exception) {
        results = nil;
    }
    
    if (results) {
        NSString *exportFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"export.csv"];
        [[NSFileManager defaultManager] createFileAtPath:exportFilePath contents:nil attributes:nil];
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:exportFilePath];
        for (JournalEntry *journalEntry in results) {
            [fileHandle seekToEndOfFile];
            
            NSData *data = [[journalEntry csv] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
            [fileHandle writeData:data];
        }
        
        [fileHandle closeFile];
        
        NSLog(@"Export path: %@", exportFilePath);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:exportFilePath message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        self.navigationItem.rightBarButtonItems = [self normalRightBarItems];
    }
    else {
        self.navigationItem.rightBarButtonItems = [self normalRightBarItems];
    }
}

- (void)exportCSVFileUsingTemporaryManagedObjectContext {
    self.navigationItem.rightBarButtonItem = [self createActivityIndicatorItem];
    
    // Note: 临时创建一个privateContext并指定使用private queue，这样privateContext执行performBlock在单独的线程不会阻塞主线程
    NSManagedObjectContext *privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    // Note: 设置privateContext的persistentStoreCoordinator属性到现有的NSPersistentStoreCoordinator
    privateContext.persistentStoreCoordinator = self.context.persistentStoreCoordinator;
    
    [privateContext performBlock:^{
        NSError *error = nil;
        NSArray *results = nil;
        @try {
            NSTimeInterval start = CACurrentMediaTime();
            results = [self.context executeFetchRequest:self.fetchRequestSurfJournal error:&error];
            NSTimeInterval end = CACurrentMediaTime();
            
            NSLog(@"fetch all data time: %f", end - start);
        }
        @catch (NSException *exception) {
            results = nil;
        }
        
        if (results) {
            NSString *exportFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"export.csv"];
            [[NSFileManager defaultManager] createFileAtPath:exportFilePath contents:nil attributes:nil];
            
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:exportFilePath];
            for (JournalEntry *journalEntry in results) {
                [fileHandle seekToEndOfFile];
                
                NSData *data = [[journalEntry csv] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
                [fileHandle writeData:data];
            }
            
            [fileHandle closeFile];
            
            NSLog(@"Export path: %@", exportFilePath);
            
            // Note: 非主线程是不能操作UI
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:exportFilePath message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                self.navigationItem.rightBarButtonItem = [self createExportItem];
            });
        }
        else {
            // Note: 非主线程是不能操作UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.rightBarButtonItem = [self createExportItem];
            });
        }
    }];
}

- (void)importSeedDataIfNeeded {
    NSString *extension = @"sqlite";
    NSURL *sourceURL = [[NSBundle mainBundle] URLForResource:SEED_NAME withExtension:extension];
    NSURL *destinationURL = [[self documentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", SEED_NAME, extension]];
    
    NSURL *sqliteURL = [destinationURL copy];
    
    BOOL copied = [[NSFileManager defaultManager] copyItemAtURL:sourceURL toURL:destinationURL error:nil];
    if (copied) {
        extension = @"sqlite-shm";
        sourceURL = [[NSBundle mainBundle] URLForResource:SEED_NAME withExtension:extension];
        destinationURL = [[self documentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", SEED_NAME, extension]];
        
        [[NSFileManager defaultManager] removeItemAtURL:destinationURL error:nil];
        copied = [[NSFileManager defaultManager] copyItemAtURL:sourceURL toURL:destinationURL error:nil];
        if (!copied) {
            NSLog(@"copy %@ failed", extension);
            abort();
        }
        
        extension = @"sqlite-wal";
        sourceURL = [[NSBundle mainBundle] URLForResource:SEED_NAME withExtension:extension];
        destinationURL = [[self documentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", SEED_NAME, extension]];
        
        [[NSFileManager defaultManager] removeItemAtURL:destinationURL error:nil];
        copied = [[NSFileManager defaultManager] copyItemAtURL:sourceURL toURL:destinationURL error:nil];
        if (!copied) {
            NSLog(@"copy %@ failed", extension);
            abort();
        }
    }
    
    CoreDataStack *coreDataStack = [[CoreDataStack alloc] initWithModelName:@"SurfJournalModel" databaseURL:sqliteURL concurrentType:NSMainQueueConcurrencyType];
    self.coreDataStack = coreDataStack;
    _context = coreDataStack.context;
}

- (NSURL *)documentsDirectory {
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return URLs[URLs.count - 1];
}

- (void)configureRate:(NSInteger)rating forCell:(SurfEntryTableViewCell *)cell {
    switch (rating) {
        case 1: {
            cell.starOneFilledImageView.hidden = NO;
            cell.starTwoFilledImageView.hidden = YES;
            cell.starThreeFilledImageView.hidden = YES;
            cell.starFourFilledImageView.hidden = YES;
            cell.starFiveFilledImageView.hidden = YES;
            break;
        }
        case 2: {
            cell.starOneFilledImageView.hidden = NO;
            cell.starTwoFilledImageView.hidden = NO;
            cell.starThreeFilledImageView.hidden = YES;
            cell.starFourFilledImageView.hidden = YES;
            cell.starFiveFilledImageView.hidden = YES;
            break;
        }
        case 3: {
            cell.starOneFilledImageView.hidden = NO;
            cell.starTwoFilledImageView.hidden = NO;
            cell.starThreeFilledImageView.hidden = NO;
            cell.starFourFilledImageView.hidden = YES;
            cell.starFiveFilledImageView.hidden = YES;
            break;
        }
        case 4: {
            cell.starOneFilledImageView.hidden = NO;
            cell.starTwoFilledImageView.hidden = NO;
            cell.starThreeFilledImageView.hidden = NO;
            cell.starFourFilledImageView.hidden = NO;
            cell.starFiveFilledImageView.hidden = YES;
            break;
        }
        case 5: {
            cell.starOneFilledImageView.hidden = NO;
            cell.starTwoFilledImageView.hidden = NO;
            cell.starThreeFilledImageView.hidden = NO;
            cell.starFourFilledImageView.hidden = NO;
            cell.starFiveFilledImageView.hidden = NO;
            break;
        }
        default: {
            cell.starOneFilledImageView.hidden = YES;
            cell.starTwoFilledImageView.hidden = YES;
            cell.starThreeFilledImageView.hidden = YES;
            cell.starFourFilledImageView.hidden = YES;
            cell.starFiveFilledImageView.hidden = YES;
            break;
        }
    }
}

- (void)gotoJournalEntryViewControllerWithIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath) {
        // view existing journal entry
        JournalEntry *journalEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        JournalEntryViewController *vc = [JournalEntryViewController new];
        vc.delegate = self;
        vc.journalEntry = journalEntry;
        vc.context = self.context;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navController animated:YES completion:nil];
    }
    else {
        // create a new journal entry
        JournalEntry *newJournalEntry;
        if (IOS10_OR_LATER) {
            newJournalEntry = [[JournalEntry alloc] initWithContext:self.context];
        }
        else {
            NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"JournalEntry" inManagedObjectContext:self.context];
            newJournalEntry = [[JournalEntry alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.context];
        }
        
        // Note: 为了方便查看数据，这里设置时间戳
        newJournalEntry.date = [NSDate date];
        
        JournalEntryViewController *vc = [JournalEntryViewController new];
        vc.delegate = self;
        vc.journalEntry = newJournalEntry;
        vc.context = self.context;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (void)gotoJournalEntryViewControllerUsingTemporaryManagedObjectContextWithIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath) {
        // view existing journal entry
        JournalEntry *journalEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        childContext.parentContext = self.context;
        JournalEntry *childJournalEntry = [childContext objectWithID:journalEntry.objectID];
        
        JournalEntryViewController *vc = [JournalEntryViewController new];
        vc.delegate = self;
        vc.journalEntry = childJournalEntry;
        vc.context = childContext;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navController animated:YES completion:nil];
    }
    else {
        NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        childContext.parentContext = self.context;
        
        JournalEntry *newJournalEntry;
        if (IOS10_OR_LATER) {
            newJournalEntry = [[JournalEntry alloc] initWithContext:childContext];
        }
        else {
            NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"JournalEntry" inManagedObjectContext:childContext];
            newJournalEntry = [[JournalEntry alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:childContext];
        }
        
        // Note: 为了方便查看数据，这里设置时间戳
        newJournalEntry.date = [NSDate date];
        
        JournalEntryViewController *vc = [JournalEntryViewController new];
        vc.delegate = self;
        vc.journalEntry = newJournalEntry;
        vc.context = childContext;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

#pragma mark - Getters

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
        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequestSurfJournal managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
        controller.delegate = self;
        
        NSError *error = nil;
        @try {
            [controller performFetch:&error];
        }
        @catch (NSException *exception) {
            NSLog(@"exception: %@", exception);
        }
        
        _fetchedResultsController = controller;
    }
    
    return _fetchedResultsController;
}

- (NSFetchRequest *)fetchRequestSurfJournal {
    if (!_fetchRequestSurfJournal) {
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"JournalEntry"];
        fetchRequest.fetchBatchSize = 20;
        fetchRequest.sortDescriptors = @[sort];
        
        _fetchRequestSurfJournal = fetchRequest;
    }
    
    return _fetchRequestSurfJournal;
}

#pragma mark - Actions

- (void)exportItemClicked:(id)sender {
    // REMARK: 切换代码
    // Note: 切换下面两个方法，对比效果
    //[self exportCSVFile];
    [self exportCSVFileUsingTemporaryManagedObjectContext];
}

- (void)addItemClicked:(id)sender {
    // REMARK: 切换代码
    //[self gotoJournalEntryViewControllerWithIndexPath:nil];
    [self gotoJournalEntryViewControllerUsingTemporaryManagedObjectContextWithIndexPath:nil];
}

- (void)scrollToBottomItemClicked:(id)sender {
    NSUInteger numberOfRows =[self.fetchedResultsController.sections[0] numberOfObjects];
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:numberOfRows - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"JournalListViewController_sCellIdentifier";
    SurfEntryTableViewCell *cell = (SurfEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[SurfEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    JournalEntry *journalEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.dateLabel.text = [journalEntry stringForDate];
    NSInteger rating = [journalEntry.rating integerValue];
    [self configureRate:rating forCell:cell];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // REMARK: 切换代码
    //[self gotoJournalEntryViewControllerWithIndexPath:indexPath];
    [self gotoJournalEntryViewControllerUsingTemporaryManagedObjectContextWithIndexPath:indexPath];
}

#pragma mark - JournalEntryViewControllerDelegate

- (void)viewControllerDidFinish:(JournalEntryViewController *)viewController saved:(BOOL)saved {
    if (saved) {
        NSManagedObjectContext *context = viewController.context;
        [context performBlock:^{
            if (context.hasChanges) {
                NSError *error = nil;
                [context save:&error];
                
                if (error) {
                    NSLog(@"error: %@", error);
                    abort();
                }
                
                [self.coreDataStack saveContext];
            }
        }];
    }
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
