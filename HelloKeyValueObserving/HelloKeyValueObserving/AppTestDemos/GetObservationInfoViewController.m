//
//  GetObservationInfoViewController.m
//  HelloKeyValueObserving
//
//  Created by wesley_chen on 2018/9/25.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import "GetObservationInfoViewController.h"
#import "Account.h"
#import "Person.h"
#import "Transaction.h"
#import "WCNSObjectTool.h"
#import "WCKVOTool.h"
#import <objc/runtime.h>

static NSUInteger sCountOfTransactions = 0;

@interface GetObservationInfoViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *listData;
@property (nonatomic, strong) Account *account;
@property (nonatomic, strong) Person *person;
@property (nonatomic, assign) BOOL isOptionPrior;
@end

@implementation GetObservationInfoViewController

- (instancetype)initWithOptionPrior:(BOOL)isOptionPrior {
    self = [super init];
    if (self) {
        [self prepareForInit];
        _isOptionPrior = isOptionPrior;
        
        _person = [Person new];
        
        _account = [Account new];
        _account.name = @"Anonymous";   // Note: not notify yet to observers
        _account.openingBalance = 0;    // Note: not notify yet to observers
        NSLog(@"Initial account: %@", _account);
        NSLog(@"isa: %s", class_getName(object_getClass(_account))); // Note: check isa pointer
        
        NSMutableArray *arrM = [NSMutableArray array];
        [arrM addObject:[[Transaction alloc] initWithTransactionId:++sCountOfTransactions]];
        _account.transactions = arrM;
        
        // isa pointer swizzled to derived class of Account
        NSLog(@"isa (swizzled): %s", class_getName(object_getClass(_account)));
    }
    return self;
}

- (void)dealloc {
    @try {
        // Warning: observer only unregister once, call removeObserver:forKeyPath: for same key multiple times cause to crash,
        // but this crash can be catched fortunately
        [_account removeObserver:self forKeyPath:@"name"];
        [_account removeObserver:self forKeyPath:@"name"]; // Warning: throw exception here, so jump the following lines
        //[self removeObserver:self forKeyPath:@"account.transactions"];
    }
    @catch (NSException * __unused exception) {
        NSLog(@"catched exception: %@", exception);
    }
    
    @try {
        [self removeObserver:self forKeyPath:@"account.transactions"];
    }
    @catch (NSException * __unused exception) {
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
                  @"Add Observer",
                  @"Remove Observer",
                  @"Check Observer",
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
    NSIndexSet *indexesValue = change[NSKeyValueChangeIndexesKey]; // the indexes of inserted, removed, replaced objects
    
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
        case 0: {
            // Register a observer for _account's @name
            NSKeyValueObservingOptions opts = self.isOptionPrior
                ? (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionPrior)
                : (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial);
            [_account addObserver:self forKeyPath:@"name" options:opts context:nil];
            break;
        }
        case 1: {
            [_account removeObserver:self forKeyPath:@"name" context:nil];
            break;
        }
        case 2: {
            NSPointerArray *pointerArray = [WCKVOTool observersWithObservationInfo:_account.observationInfo];
            for (NSInteger i = 0; i < pointerArray.count; i++) {
                id element = [pointerArray pointerAtIndex:i];
                NSLog(@"%@", element);
            }
            break;
        }
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
