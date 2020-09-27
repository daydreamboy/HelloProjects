//
//  UseWCMessageComposerViewWithItemsViewController.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/27.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseWCMessageComposerViewWithItemsViewController.h"
#import "WCMessageComposerView.h"

@interface UseWCMessageComposerViewWithItemsViewController ()
@property (nonatomic, strong) WCMessageComposerView *messageComposerView;
@end

@implementation UseWCMessageComposerViewWithItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.messageComposerView];
}

#pragma mark -

- (NSArray<WCMessageInputItem *> *)createMessageInputItems {
    
    NSMutableArray<WCMessageInputItem *> *items = [NSMutableArray array];
    
    [items addObject:({
        WCMessageInputItem *item = [[WCMessageInputItem alloc] initWithDict:@{
            @"type": @(WCMessageInputItemTypeText),
            @"position": @(WCMessageInputItemPositionLeft),
            @"order": @1,
            @"title": @"item2",
        }];
        item;
    })];
    
    [items addObject:({
        WCMessageInputItem *item = [[WCMessageInputItem alloc] initWithDict:@{
            @"type": @(WCMessageInputItemTypeText),
            @"position": @(WCMessageInputItemPositionLeft),
            @"order": @0,
            @"title": @"item1",
        }];
        item;
    })];
    
    [items addObject:({
        WCMessageInputItem *item = [[WCMessageInputItem alloc] initWithDict:@{
            @"type": @(WCMessageInputItemTypeText),
            @"position": @(WCMessageInputItemPositionRight),
            @"order": @0,
            @"title": @"item3",
        }];
        item;
    })];
    
    [items addObject:({
        WCMessageInputItem *item = [[WCMessageInputItem alloc] initWithDict:@{
            @"type": @(WCMessageInputItemTypeText),
            @"position": @(WCMessageInputItemPositionRight),
            @"order": @0,
            @"title": @"item4",
        }];
        item;
    })];
    
    return items;
}

#pragma mark - Getter

- (WCMessageComposerView *)messageComposerView {
    if (!_messageComposerView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        WCMessageComposerView *view = [[WCMessageComposerView alloc] initWithFrame:CGRectMake(0, 100, screenSize.width, 0)];
        view.backgroundColor = [UIColor greenColor];
        view.textFont = [UIFont systemFontOfSize:17];
        view.minimumNumberOfLines = 1;
        
        CGFloat textInputHeight = [view currentTextInputHeight];
        CGFloat offset = textInputHeight <= view.textInputAreaMinimumHeight ? (view.textInputAreaMinimumHeight - textInputHeight) / 2.0 : 5;
        view.textInputAreaInsets = UIEdgeInsetsMake(offset, 8, offset, 8);
        
        NSArray<WCMessageInputItem *> *messageInputItems = [self createMessageInputItems];
        for (WCMessageInputItem *item in messageInputItems) {
            [view addMessageInputItem:item];
        }
        
        _messageComposerView = view;
    }
    
    return _messageComposerView;
}

@end
