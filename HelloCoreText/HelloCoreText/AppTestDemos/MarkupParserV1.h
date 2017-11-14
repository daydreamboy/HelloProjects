//
//  MarkupParserV1.h
//  HelloCoreText
//
//  Created by wesley_chen on 13/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkupParserV1 : NSObject

@property (nonatomic, strong, readonly) NSMutableAttributedString *attrStringM;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *images;

- (void)parseMarkup:(NSString *)markup;
@end
