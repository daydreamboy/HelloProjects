//
//  DependentKeyToOneRelationshipViewController.m
//  HelloKeyValueObserving
//
//  Created by wesley chen on 17/2/13.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "DependentKeyToOneRelationshipViewController.h"

#import "Person.h"
#import <objc/runtime.h>

@interface DependentKeyToOneRelationshipViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *listData;
@property (nonatomic, strong) Person *person;
@end

@implementation DependentKeyToOneRelationshipViewController

- (instancetype)initWithOptionPrior:(BOOL)isOptionPrior {
    self = [super init];
    if (self) {
        [self prepareForInit];
        
        _person = [Person new];
        _person.firstName = @"Anonymous";   // Note: not notify yet to observers
        _person.lastName = @"Anonymous";    // Note: not notify yet to observers
        
        NSLog(@"Initial person: %@", _person);
        NSLog(@"isa: %s", class_getName(object_getClass(_person))); // Note: check isa pointer
        
        // Register a observer for _account's @name
        NSKeyValueObservingOptions opts = isOptionPrior
            ? (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionPrior)
            : (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial);
        
        [_person addObserver:self forKeyPath:@"fullName" options:opts context:nil];
        
        // isa pointer swizzled to derived class of Account
        NSLog(@"isa (swizzled): %s", class_getName(object_getClass(_person)));
    }
    return self;
}

- (void)dealloc {
    @try {
        // Warning: observer only unregister once, call removeObserver:forKeyPath: for same key multiple times cause to crash,
        // but this crash can be catched fortunately
        [_person removeObserver:self forKeyPath:@"fullName"];
        [_person removeObserver:self forKeyPath:@"fullName"];
    } @catch (NSException * __unused exception) {
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark -
- (void)prepareForInit {
    _listData = @[
                  @"setter method",
                  @"setValue:forKey: method",
                  @"setValue:forKeyPath: method",
                  ];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"--------------------------------------------------------");
    
    NSLog(@"keyPath: %@", keyPath);
    NSLog(@"object: %@", object);
    NSLog(@"changeDict: %@", change);
    
    // more details about changeDict
    NSNumber *kindValue = change[NSKeyValueChangeKindKey];
    NSNumber *notificationIsPriorValue = change[NSKeyValueChangeNotificationIsPriorKey];
    id oldValue = change[NSKeyValueChangeOldKey];
    id newValue = change[NSKeyValueChangeNewKey];
    NSIndexSet *indexesValue = change[NSKeyValueChangeIndexesKey];
    
    NSLog(@"kind: %@", [self stringFromChangeKind:[kindValue unsignedIntegerValue]]);
    NSLog(@"notificationIsPrior: %@", notificationIsPriorValue ? @"YES" : @"NO");
    NSLog(@"old: %@", oldValue);
    NSLog(@"new: %@", newValue);
    NSLog(@"indexes: %@", indexesValue);
    
    NSLog(@"--------------------------------------------------------\n");
}

#pragma mark > Utility for KVO

- (NSString *)stringFromChangeKind:(NSKeyValueChange)changeKind {
    switch (changeKind) {
        case NSKeyValueChangeSetting:       { return @"NSKeyValueChangeSetting"; }
        case NSKeyValueChangeInsertion:     { return @"NSKeyValueChangeInsertion"; }
        case NSKeyValueChangeRemoval:       { return @"NSKeyValueChangeRemoval"; }
        case NSKeyValueChangeReplacement:   { return @"NSKeyValueChangeReplacement"; }
        default:  { return nil; }
    }
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [_person setFirstName:@"John"];
            break;
        case 1:
            [_person setValue:@"Lennon" forKey:@"lastName"];
            break;
        case 2:
            [self setValue:@"George" forKeyPath:@"person.firstName"];
            break;
        case 3:
            // TODO: ...
            [_person mutableArrayValueForKey:@"name"];
            break;
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"AutomaticChangeNotificationViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = _listData[indexPath.row];
    
    return cell;
}

@end
