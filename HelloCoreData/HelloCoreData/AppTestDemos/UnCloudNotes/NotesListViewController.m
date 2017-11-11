//
//  NotesListViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 11/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "NotesListViewController.h"
#import "CoreDataStack.h"
#import "Note+CoreDataClass.h"

@interface NotesListViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *notes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) void (^block2)(void);
@end

@implementation NotesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Notes";
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItemClicked:)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    @try {
        NSError *error;
        [self.notes performFetch:&error];
        if (error) {
            NSLog(@"error: %@", error);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
    
    [self.tableView reloadData];
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

- (NSFetchedResultsController *)notes {
    if (!_notes) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
        fetchRequest.sortDescriptors = @[sort];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
        fetchedResultsController.delegate = self;
        _notes = fetchedResultsController;
    }
    
    return _notes;
}

- (NSManagedObjectContext *)context {
    if (!_context) {
        NSURL *sqliteURL = [[self documentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", @"UnCloudNotes", @"sqlite"]];
        
        self.coreDataStack = [[CoreDataStack alloc] initWithModelName:@"UnCloudNotesDataModel" databaseURL:sqliteURL concurrentType:NSMainQueueConcurrencyType];
        _context = self.coreDataStack.context;
    }
    
    return _context;
}

#pragma mark -

- (NSURL *)documentsDirectory {
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return URLs[URLs.count - 1];
}

#pragma mark - Actions

- (void)addItemClicked:(id)sender {
    //
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"NotesListViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    Note *note = [self.notes objectAtIndexPath:indexPath];
    cell.textLabel.text = note.title;
    
    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    NSArray * (^NSArrayFromIndexPath)(NSIndexPath *) = ^(NSIndexPath *indexPath) {
        if (indexPath) {
            return @[indexPath];
        }
        else {
            return @[];
        }
    };
    
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:NSArrayFromIndexPath(indexPath) withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:NSArrayFromIndexPath(indexPath) withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default:
            break;
    }
}

@end
