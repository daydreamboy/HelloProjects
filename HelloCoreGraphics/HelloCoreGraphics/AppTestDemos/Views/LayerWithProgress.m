//
//  LayerWithProgress.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2018/7/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "LayerWithProgress.h"

@implementation LayerWithProgress
- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        LayerWithProgress *otherLayer = (LayerWithProgress *)layer;
        self.progress = otherLayer.progress;
        self.progressdelegate = otherLayer.progressdelegate;
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString*)key {
    if ([key isEqualToString:@"progress"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

- (void)drawInContext:(CGContextRef)ctx
{
    if (self.progressdelegate)
    {
        [self.progressdelegate progressUpdatedTo:self.progress];
    }
}
@end
