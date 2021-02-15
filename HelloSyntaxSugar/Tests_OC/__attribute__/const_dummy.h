//
//  const_dummy.h
//  Tests_OC
//
//  Created by wesley_chen on 2021/2/15.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(char, XPL802_11Protocol) {
    XPL802_11ProtocolA = 'a',
    XPL802_11ProtocolB = 'b',
    XPL802_11ProtocolG = 'g',
    XPL802_11ProtocolN = 'n'
};

FOUNDATION_EXPORT NSString *XPL802_11ProtocolToString(XPL802_11Protocol protocol) __attribute__((const));
FOUNDATION_EXPORT NSString *XPL802_11ProtocolToString_issue(XPL802_11Protocol protocol) __attribute__((const));

NS_ASSUME_NONNULL_END
