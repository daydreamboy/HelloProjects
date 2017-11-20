//
//  FetchResultControllerViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 06/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "FetchResultControllerViewController.h"
#import "Team+CoreDataClass.h"
#import <CoreData/CoreData.h>

@interface FetchResultControllerViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *barItemAdd;
@end

@implementation FetchResultControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self importJSONSeedDataIfNeeded];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItemClicked:)];
    addItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = addItem;
    self.barItemAdd = addItem;
    
    @try {
        NSError *error = nil;
        [self.fetchedResultsController performFetch:&error];
        if (error) {
            NSLog(@"error: %@", error);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
    @finally {
        
    }
    
    [self.view addSubview:self.tableView];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        self.barItemAdd.enabled = YES;
    }
}

#pragma mark - Actions

- (void)addItemClicked:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Secret Team" message:@"Add a new team" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.placeholder = @"Team Name";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.placeholder = @"Qualifying Zone";
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Saved");
        
        UITextField *nameTextField = alert.textFields[0];
        UITextField *zoneTextField = alert.textFields[1];
        
        Team *team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.context];
        
        team.teamName = nameTextField.text;
        team.qualifyingZone = zoneTextField.text;
        team.imageName = @"wenderland-flag";
        
        [self saveContext];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel");
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Getters

- (NSManagedObjectContext *)context {
    if (!_context) {
        // Note: can't access _coreDataStack of super class instead of using self.coreDataStack
        self.coreDataStack = [[CoreDataStack alloc] initWithModelName:@"WorldCup"];
        _context = self.coreDataStack.context;
    }
    
    return _context;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSSortDescriptor *zoneSort = [NSSortDescriptor sortDescriptorWithKey:@"qualifyingZone" ascending:YES];
        NSSortDescriptor *scoreSort = [NSSortDescriptor sortDescriptorWithKey:@"wins" ascending:NO];
        NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"teamName" ascending:YES];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
        fetchRequest.sortDescriptors = @[zoneSort, scoreSort, nameSort];
        
        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:@"qualifyingZone" cacheName:@"worldCup"];
        controller.delegate = self;
        
        _fetchedResultsController = controller;
    }
    
    return _fetchedResultsController;
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

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Team *team = [self.fetchedResultsController objectAtIndexPath:indexPath];
    team.wins = team.wins + 1;
    [self saveContext];
    // Note: use NSFetchedResultsControllerDelegate instead
    /*
    [self.tableView reloadData];
     */
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.name;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"FetchResultControllerViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sCellIdentifier];
    }
    
    Team *team = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:team.imageName];
    cell.textLabel.text = team.teamName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Wins: %ld", (long)team.wins];
    
    return cell;
}

#pragma mark - Import Seed Data

- (void)importJSONSeedDataIfNeeded {
    // Note: create a NSFetchRequest with entity name
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
    NSError *error = nil;
    
    NSUInteger count = [self.context countForFetchRequest:fetchRequest error:&error];
    if (!count) {
        @try {
            NSError *error2 = nil;
            NSArray<Team *> *arr = [self.context executeFetchRequest:fetchRequest error:&error2];
            
            for (Team *team in arr) {
                [self.context deleteObject:team];
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
    NSURL *jsonURL = [[NSBundle mainBundle] URLForResource:@"WorldCup_seed" withExtension:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    
    NSEntityDescription *teamEntity = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:self.context];
    
    @try {
        
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        
        for (NSDictionary *dict in arr) {
            NSString *teamName = dict[@"teamName"];
            NSString *zone = dict[@"qualifyingZone"];
            NSString *imageName = dict[@"imageName"];
            NSNumber *wins = dict[@"wins"];
            
            Team *team = [[Team alloc] initWithEntity:teamEntity insertIntoManagedObjectContext:self.context];
            team.teamName = teamName;
            team.imageName = imageName;
            team.qualifyingZone = zone;
            team.wins = wins.intValue;
        }
        
        [self saveContext];
        NSLog(@"Imported %ld teams", arr.count);
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

#pragma mark - NSFetchedResultsControllerDelegate

// Note: use will-didChangeObject-did instead to refresh part of UITableView
/*
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
    
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default: {
            break;
        }
    }
}

@end
