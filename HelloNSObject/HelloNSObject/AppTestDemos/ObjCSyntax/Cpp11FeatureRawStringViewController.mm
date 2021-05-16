//
//  Cpp11FeatureRawStringViewController.m
//  HelloSyntaxSugar
//
//  Created by wesley_chen on 12/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "Cpp11FeatureRawStringViewController.h"

// @see https://stackoverflow.com/questions/9025004/string-literals-without-having-to-escape-special-characters
// json from http://json.org/example.html
static NSString *jsonString = @R"JSON(
{
    "glossary": {
        "title": "example glossary",
        "GlossDiv": {
            "title": "S",
            "GlossList": {
                "GlossEntry": {
                    "ID": "SGML",
                    "SortAs": "SGML",
                    "GlossTerm": "Standard Generalized Markup Language",
                    "Acronym": "SGML",
                    "Abbrev": "ISO 8879:1986",
                    "GlossDef": {
                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
                        "GlossSeeAlso": ["GML", "XML"]
                    },
                    "GlossSee": "markup"
                }
            }
        }
    }
}
)JSON";

@implementation Cpp11FeatureRawStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSLog(@"dict: %@", dict);
}

@end
