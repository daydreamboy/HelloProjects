//
//  WCTuple.h
//  Tests_C
//
//  Created by wesley_chen on 2019/6/7.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#ifndef WCTuple_h
#define WCTuple_h

#import "WCTupleClass.h"

#define WCTupleType WCTupleClass
#define WCTuple(...) [[WCTupleClass alloc] initWithObjects:__VA_ARGS__, [WCTupleClass sentinel]];

#endif /* WCTuple_h */
