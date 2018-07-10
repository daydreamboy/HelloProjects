//
//  MPBaseComponentView.h
//  FrameworkWithPublicHeaderIssue
//
//  Created by wesley_chen on 2018/7/10.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

// Note: not work
//#import "MsgDynamicCommon.h"
// Note: also not work
#import "IMPComponentViewProtocol.h"

@interface MPBaseComponentView : NSObject<IMPComponentViewProtocol>

@end
