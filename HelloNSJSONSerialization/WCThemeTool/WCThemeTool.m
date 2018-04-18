//
//  WCThemeTool.m
//  HelloNSJSONSerialization
//
//  Created by wesley_chen on 2018/4/18.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCThemeTool.h"

@interface WCThemeTool ()
@property (nonatomic, copy) NSString *configurationFilePath;
@property (nonatomic, strong) NSDictionary *configurations;

@property (nonatomic, strong) NSMutableDictionary *frames;

@end

@implementation WCThemeTool

+ (NSString *)defaultConfigurationFilePath {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"theme.plist"];
}

#pragma mark - Public Methods

+ (instancetype)defaultInstance {
    static dispatch_once_t onceToken;
    static WCThemeTool *sInstance;
    dispatch_once(&onceToken, ^{
        sInstance = [[WCThemeTool alloc] initWithConfigurationFilePath:[self defaultConfigurationFilePath]];
    });
    
    return sInstance;
}

- (instancetype)initWithConfigurationFilePath:(NSString *)configurationFilePath {
    self = [super init];
    if (self) {
        _configurationFilePath = configurationFilePath;
        _configurations = [NSDictionary dictionaryWithContentsOfFile:configurationFilePath];
        
        [self updateConfigurations:_configurations];
    }
    return self;
}

- (void)updateConfigurations:(NSDictionary *)configurations {
    NSDictionary *frames = configurations[WCThemeToolKeyFrames];
    if ([frames isKindOfClass:[NSDictionary class]] && frames.count) {
        if (!self.frames) {
            self.frames = [NSMutableDictionary dictionaryWithCapacity:frames.count];
        }
        
        [frames enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                double x, y, width, height;
                x = y = width = height = NAN;
                
                if ([obj[@"x"] isKindOfClass:[NSNumber class]]) {
                    x = [obj[@"x"] doubleValue];
                }
                
                if ([obj[@"y"] isKindOfClass:[NSNumber class]]) {
                    x = [obj[@"y"] doubleValue];
                }
                
                if ([obj[@"width"] isKindOfClass:[NSNumber class]]) {
                    width = [obj[@"width"] doubleValue];
                }
                
                if ([obj[@"height"] isKindOfClass:[NSNumber class]]) {
                    height = [obj[@"height"] doubleValue];
                }
                
                CGRect rect = CGRectMake(x, y, width, height);
                [self.frames setObject:[NSValue valueWithCGRect:rect] forKey:key];
            }
        }];
    }
}

- (CGRect)frameForKey:(NSString *)key {
    CGRect rect = {{NAN, NAN}, {NAN, NAN}};;
    
    NSValue *frame = self.frames[key];
    if ([frame isKindOfClass:[NSValue class]]) {
        rect = [frame CGRectValue];
    }
    
    return rect;
}

- (double)frameHeightForKey:(NSString *)key defaultHeight:(double)defaultHeight {
    CGRect rect = [self frameForKey:key];
    double height = (isnan(rect.size.height) == 0 ? rect.size.height : defaultHeight);
    
    return height;
}

@end
