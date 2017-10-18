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

//#import "JournalEntry+CoreDataClass.h"
//#import "JournalEntry+Methods.h"

@interface JournalListViewController () <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JournalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"SurfEntryTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"JournalListViewController_sCellIdentifier"];
    
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(filterItemClicked:)];
    self.navigationItem.rightBarButtonItem = filterItem;
}

#pragma mark - Getters

- (NSManagedObjectContext *)context {
    if (!_context) {
        CoreDataStack *coreDataStack = [[CoreDataStack alloc] initWithModelName:@"SurfJournalModel"];
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

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"JournalEntry"];
        fetchRequest.fetchBatchSize = 20;
        fetchRequest.sortDescriptors = @[sort];
        
        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
        
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

#pragma mark - Actions

- (void)filterItemClicked:(id)sender {
//    FilterViewController *viewController = [[FilterViewController alloc] initWithContext:self.context];
//    viewController.delegate = self;
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
//
//    [self presentViewController:navController animated:YES completion:nil];
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
    
    return cell;
}

#pragma mark - UITableViewDelegate
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
