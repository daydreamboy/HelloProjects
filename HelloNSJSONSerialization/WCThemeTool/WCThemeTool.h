//
//  WCThemeTool.h
//  HelloNSJSONSerialization
//
//  Created by wesley_chen on 2018/4/18.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define WCThemeToolKeyFrames   @"Frames"

// TODO: UIImage、UIFont、UIColor
@interface WCThemeTool : NSObject

+ (instancetype)defaultInstance;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithConfigurationFilePath:(NSString *)configurationFilePath;

- (void)updateConfigurations:(NSDictionary *)configurations;
- (CGRect)frameForKey:(NSString *)key;
- (double)frameHeightForKey:(NSString *)key defaultHeight:(double)defaultHeight;

@end
