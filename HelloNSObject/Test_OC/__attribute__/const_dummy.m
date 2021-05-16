//
//  const_dummy.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/2/15.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "const_dummy.h"

NSString *XPL802_11ProtocolToString(XPL802_11Protocol protocol) {
    switch(protocol) {
        case XPL802_11ProtocolA: return @"802.11a";
        case XPL802_11ProtocolB: return @"802.11b";
        case XPL802_11ProtocolG: return @"802.11g";
        case XPL802_11ProtocolN: return @"802.11n";
        default: break;
    }
    return nil;
}

NSString *XPL802_11ProtocolToString_issue(XPL802_11Protocol protocol) {
    switch(protocol) {
        case XPL802_11ProtocolA:
        case XPL802_11ProtocolB:
        case XPL802_11ProtocolG:
        case XPL802_11ProtocolN:
        return [NSString stringWithFormat:@"802.11%c", protocol];
        default: break;
    }
    return nil;
}
