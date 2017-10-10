//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "AutomaticChangeNotifyViewController.h"
#import "Account.h"
#import "Person.h"
#import "Transaction.h"
#import <objc/runtime.h>

static NSUInteger sCountOfTransactions = 0;

@interface AutomaticChangeNotifyViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *listData;
@property (nonatomic, strong) Account *account;
@property (nonatomic, strong) Person *person;
@end

@implementation AutomaticChangeNotifyViewController

- (instancetype)initWithOptionPrior:(BOOL)isOptionPrior {
    self = [super init];
    if (self) {
        [self prepareForInit];
        
        _person = [Person new];
        
        _account = [Account new];
        _account.name = @"Anonymous";   // Note: not notify yet to observers
        _account.openingBalance = 0;    // Note: not notify yet to observers
        NSLog(@"Initial account: %@", _account);
        NSLog(@"isa: %s", class_getName(object_getClass(_account))); // Note: check isa pointer
        
        NSMutableArray *arrM = [NSMutableArray array];
        [arrM addObject:[[Transaction alloc] initWithTransactionId:++sCountOfTransactions]];
        _account.transactions = arrM;
        
        // Register a observer for _account's @name
        NSKeyValueObservingOptions opts = isOptionPrior
            ? (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionPrior)
            : (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial);
        [_account addObserver:self forKeyPath:@"name" options:opts context:nil];
        [self addObserver:self forKeyPath:@"account.transactions" options:opts context:nil];
        
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
                  @"setter method",
                  @"setValue:forKey: method",
                  @"setValue:forKeyPath: method",
                  @"collection add item (no triggeer KVO)",
                  @"collection add item (by KVO proxy object)",
                  @"collection remove item (by KVO proxy object)",
                  @"collection replace item (no triggeer KVO)",
                  @"collection replace item (by KVO proxy object)",
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
        case 0:
            [_account setName:@"Savings1"];
            break;
        case 1:
            [_account setValue:@"Savings2" forKey:@"name"];
            break;
        case 2:
            [self setValue:@"Savings3" forKeyPath:@"account.name"];
            break;
        case 3:
            [_account.transactions addObject:[[Transaction alloc] initWithTransactionId:++sCountOfTransactions]]; // Note: not trigger KVO notification
            break;
        case 4: {
            NSMutableArray *proxyArrM = [_account mutableArrayValueForKey:@"transactions"];
            NSLog(@"proxy mutable array (KVO): %p", proxyArrM);
            NSLog(@"original mutable array: %p", _account.transactions);
            [proxyArrM addObject:[[Transaction alloc] initWithTransactionId:++sCountOfTransactions]];
            break;
        }
        case 5: {
            if ([_account.transactions count] > 0) {
                [[_account mutableArrayValueForKey:@"transactions"] removeLastObject];
            }
            break;
        }
        case 6: {
            NSMutableArray *arrM = _account.transactions;
            arrM[0] = [[Transaction alloc] initWithTransactionId:sCountOfTransactions]; // Note: not trigger KVO notification
            break;
        }
        case 7: {
            NSMutableArray *proxyArrM = [_account mutableArrayValueForKey:@"transactions"];
            proxyArrM[0] = [[Transaction alloc] initWithTransactionId:sCountOfTransactions];
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
