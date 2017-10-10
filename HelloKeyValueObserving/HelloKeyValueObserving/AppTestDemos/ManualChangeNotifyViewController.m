//
//  ManualChangeNotifyViewController.m
//  HelloKeyValueObserving
//
//  Created by wesley chen on 17/2/12.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "ManualChangeNotifyViewController.h"

#import "Account.h"
#import "Person.h"
#import "Transaction.h"

static NSUInteger sCountOfTransactions = 0;

@interface ManualChangeNotifyViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *listData;
@property (nonatomic, strong) Account *account;
@end

@implementation ManualChangeNotifyViewController

- (instancetype)initWithOptionPrior:(BOOL)isOptionPrior {
    self = [super init];
    if (self) {
        [self prepareForInit];
        
        _account = [Account new];
        _account.name = @"Anonymous";   // Note: not notify yet to observers
        _account.openingBalance = 0;    // Note: not notify yet to observers
        NSLog(@"Initial account: %@", _account);
        
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSUInteger i = 0; i < 20; i++) {
            [arrM addObject:[[Transaction alloc] initWithTransactionId:++sCountOfTransactions]];
        }
        _account.transactions = arrM;
        
        NSKeyValueObservingOptions opts = isOptionPrior
            ? (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionPrior)
            : (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial);
        
        // Register a observer for _account's @openingBalance
        [_account addObserver:self forKeyPath:@"openingBalance" options:opts context:nil]; // Note: allow registering multiple times
        //[_account addObserver:self forKeyPath:@"openingBalance" options:opts context:nil];
        
        [_account addObserver:self forKeyPath:@"transactions" options:opts context:nil];
    }
    return self;
}

- (void)dealloc {
    @try {
        // Note: removeObserver: must balance with addObserver:
        [_account removeObserver:self forKeyPath:@"openingBalance"];
        //[_account removeObserver:self forKeyPath:@"openingBalance"];
        [_account removeObserver:self forKeyPath:@"transactions"];
    }
    @catch (NSException * __unused exception) {
        NSLog(@"catched exception: %@", exception);
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
                  @"collection remove items (trigger KVO manually)",
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
            _account.openingBalance = 1.0f;
            break;
        case 1:
            [_account setValue:@(2.0f) forKey:@"openingBalance"];
            break;
        case 2:
            [self setValue:@(3.0f) forKeyPath:@"account.openingBalance"];
            break;
        case 3: {
            NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
            [indexes addIndex:0];
            [indexes addIndex:2];
            [_account removeTransactionsAtIndexes:indexes];
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
    static NSString *sCellIdentifier = @"ManualChangeNotifyViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = _listData[indexPath.row];
    
    return cell;
}

@end
