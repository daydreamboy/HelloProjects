//
//  CreateSerialDispatchQueuesViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/11/20.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "CreateDispatchQueuesViewController.h"

@interface CreateDispatchQueuesViewController () <UITextFieldDelegate>
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation CreateDispatchQueuesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, 40)];
    _textField.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    _textField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _textField.layer.cornerRadius = 2.0f;
    _textField.delegate = self;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:_textField];
    
    NSLog(@"current instance: %@", self);
    _textField.text = [NSString stringWithFormat:@"%p", self];
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("com.example.MyQueue", NULL); // DISPATCH_QUEUE_SERIAL is also NULL
    
    NSLog(@"queue object: %@", queue);
    
    dispatch_async(queue, ^{
        // @see http://stackoverflow.com/questions/5166711/gcd-obtaining-queue-name-label
        // set a breakpoint at below line to see threads
        NSLog(@"queue label: %s", dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL));
    });
    self.queue = queue;
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.example.MyQueue2", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        NSLog(@"do task in concurrentQueue");
    });
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // http://stackoverflow.com/questions/5756605/ios-get-pointer-from-nsstring-containing-address
    NSString *address = textField.text;
    
    __unsafe_unretained NSObject *object;
    sscanf([address cStringUsingEncoding:NSUTF8StringEncoding], "%p", &object);
    
    NSString *debugDescriton = [object debugDescription];
    
    NSLog(@"%@", debugDescriton);
    
    return YES;
}

@end
