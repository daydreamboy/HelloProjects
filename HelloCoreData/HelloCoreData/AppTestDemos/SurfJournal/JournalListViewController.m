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

#define SEED_NAME   @"SurfJournalDatabase"

@interface JournalListViewController () <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>
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
    
    self.navigationItem.rightBarButtonItem = [self createExportItem];
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

- (void)exportCSV {
    self.navigationItem.rightBarButtonItem = [self createActivityIndicatorItem];
    
    NSError *error = nil;
    NSArray *results = nil;
    @try {
        results = [self.context executeFetchRequest:self.fetchRequestSurfJournal error:&error];
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
        
        self.navigationItem.rightBarButtonItem = [self createExportItem];
    }
    else {
        self.navigationItem.rightBarButtonItem = [self createExportItem];
    }
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
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"JournalEntry"];
        fetchRequest.fetchBatchSize = 20;
        fetchRequest.sortDescriptors = @[sort];
        
        _fetchRequestSurfJournal = fetchRequest;
    }
    
    return _fetchRequestSurfJournal;
}

#pragma mark - Actions

- (void)exportItemClicked:(id)sender {
    NSError *error = nil;
    NSTimeInterval start = CACurrentMediaTime();
    NSArray *results = [self.coreDataStack.context executeFetchRequest:self.fetchRequestSurfJournal error:&error];
    NSTimeInterval end = CACurrentMediaTime();
    
    NSLog(@"fetch all data time: %f", end - start);
    
    NSString *exportFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"export.csv"];
    [[NSFileManager defaultManager] createFileAtPath:exportFilePath contents:[NSData data] attributes:nil];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:exportFilePath];
    
    for (JournalEntry *journalEntry in results) {
        [fileHandle seekToEndOfFile];
        
        NSData *csvData = [[journalEntry csv] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        [fileHandle writeData:csvData];
    }
    
    [fileHandle closeFile];
    
    NSLog(@"exported to %@", exportFilePath);
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
    
    JournalEntryViewController *vc = [JournalEntryViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
