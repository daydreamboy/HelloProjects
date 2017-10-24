//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "BuildCoreDataStackViewController.h"
#import "CoreDataStack.h"
#import "Dog+CoreDataProperties.h"
#import "Walk+CoreDataProperties.h"

@interface BuildCoreDataStackViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, strong) Dog *currentDog;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation BuildCoreDataStackViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateStyle = NSDateFormatterShortStyle;
        _dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    self.title = @"Dog Walk";
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItemClicked:)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.tableView];
}

- (void)setup {
    self.coreDataStack = [[CoreDataStack alloc] initWithModelName:@"Dog Walk"];
    self.context = self.coreDataStack.context;
    
    NSString *dogName = @"Fido";
    NSFetchRequest *dogFetch = [[NSFetchRequest alloc] initWithEntityName:@"Dog"];
    dogFetch.predicate = [NSPredicate predicateWithFormat:@"name == %@", dogName];
    
    @try {
        NSError *error = nil;
        NSArray<Dog *> *results = [self.context executeFetchRequest:dogFetch error:&error];
        
        if (results.count) {
            // Fido found, use Fido
            self.currentDog = results[0];
        }
        else {
            // Fido not found, create Fido
            NSEntityDescription *dogEntity = [NSEntityDescription entityForName:@"Dog" inManagedObjectContext:self.context];
            
            self.currentDog = [[Dog alloc] initWithEntity:dogEntity insertIntoManagedObjectContext:self.context];
            self.currentDog.name = dogName;
            
            [self.coreDataStack saveContext];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
    @finally {
        
    }
}

#pragma mark - Getters

- (UIImageView *)imageView {
    if (!_imageView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 213)];
        imageView.backgroundColor = [UIColor lightGrayColor];
        _imageView = imageView;
    }
    
    return _imageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat startY = CGRectGetMaxY(self.imageView.frame);
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startY, screenSize.width, screenSize.height - startY) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableView = tableView;
    }
    
    return _tableView;
}

#pragma mark - Actions

- (void)addItemClicked:(id)sender {
    NSEntityDescription *walkEntity = [NSEntityDescription entityForName:@"Walk" inManagedObjectContext:self.context];
    Walk *walk = [[Walk alloc] initWithEntity:walkEntity insertIntoManagedObjectContext:self.context];
    
    walk.date = [NSDate date];
    
    NSMutableOrderedSet *walks = [self.currentDog.walks mutableCopy];
    [walks addObject:walk];
    
    self.currentDog.walks = [walks copy];
    
    [self.coreDataStack saveContext];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"List of Walks";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Walk *walkToRemove = self.currentDog.walks[indexPath.row];
        
        [self.context deleteObject:walkToRemove];
        [self.coreDataStack saveContext];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentDog.walks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"Demo1ViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    Walk *walk = self.currentDog.walks[indexPath.row];
    cell.textLabel.text = [self.dateFormatter stringFromDate:walk.date];
    
    return cell;
}

@end
