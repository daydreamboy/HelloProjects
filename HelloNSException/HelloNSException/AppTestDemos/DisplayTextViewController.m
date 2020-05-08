//
//  DisplayTextViewController.m
//  HelloCrash
//
//  Created by wesley_chen on 23/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DisplayTextViewController.h"

@interface DisplayTextViewController ()
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSError *errorOfReadingFile;
@property (nonatomic, strong) NSMutableAttributedString *attrTextM;
@end

@implementation DisplayTextViewController

- (instancetype)initWithFilePath:(NSString *)filePath {
    self = [super init];
    if (self) {
        _filePath = filePath;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self loadFile];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.errorOfReadingFile) {
        NSError *error = self.errorOfReadingFile;
        NSLog(@"Error: %@", error);
        NSString *title = [NSString stringWithFormat:@"不能读取文件%@", [self.filePath lastPathComponent]];
        NSString *msg = [NSString stringWithFormat:@"code: %ld, %@", (long)error.code, error.localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)setup {
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingHead;
    
    NSDictionary *attrs = @{
                            NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                            NSForegroundColorAttributeName: [UIColor darkTextColor],
                            //                            NSParagraphStyleAttributeName: paragraphStyle
                            };
    
    self.title = [self.filePath lastPathComponent];
    self.navigationController.navigationBar.titleTextAttributes = attrs;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
}

- (void)loadFile {
    NSError *error = nil;
    NSString *text = [self readFileAtPath:self.filePath error:&error];
    if (!error) {
        self.attrTextM = [[NSMutableAttributedString alloc] initWithString:text];
        self.textView.attributedText = [self.attrTextM copy];
//        self.textView.contentOffset = CGPointZero;
    }
    self.errorOfReadingFile = error;
}

- (NSString *)readFileAtPath:(NSString *)filePath error:(NSError **)error {
    NSString *fileName = [filePath lastPathComponent];
    NSString *fileExt = [[fileName pathExtension] lowercaseString];
    
    NSString *content;
    NSError *errorL;
    
    if ([fileExt isEqualToString:@"plist"]) {
        
        NSPropertyListFormat format = 0;
        NSData *data = [NSData dataWithContentsOfFile:filePath options:kNilOptions error:&errorL];
        if (data) {
            @try {
                id objectM = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:&format error:&errorL];
                content = [NSString stringWithFormat:@"%@", objectM];
            }
            @catch (NSException *exception) {
                NSLog(@"exception: %@", exception);
                NSString *reason = exception.reason ? exception.reason : @"文件读取异常";
                errorL = [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{ NSLocalizedDescriptionKey: reason }];
            }
        }
    }
    else {
        NSStringEncoding encoding = 0;
        // Treat as simple text file
        content = [NSString stringWithContentsOfFile:filePath usedEncoding:&encoding error:&errorL];
    }
    
    *error = errorL;
    
    return content;
}

#pragma mark - Getters

- (UITextView *)textView {
    if (!_textView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 400)];
        textView.autocorrectionType = UITextAutocorrectionTypeNo;
        textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textView.editable = NO;
        
        _textView = textView;
    }
    
    return _textView;
}

@end
