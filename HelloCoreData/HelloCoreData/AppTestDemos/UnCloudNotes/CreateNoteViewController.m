//
//  CreateNoteViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 12/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "CreateNoteViewController.h"
#import "Note+CoreDataClass.h"

@interface CreateNoteViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textFieldTitle;
@property (nonatomic, strong) UITextView *textViewBody;
@property (nonatomic, strong) UIButton *buttonAttachPhoto;
@property (nonatomic, strong) UIImageView *imageViewAttachedPhoto;
@end

@implementation CreateNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(createItemClicked:)];
    
    [self.view addSubview:self.textFieldTitle];
    [self.view addSubview:self.textViewBody];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textFieldTitle becomeFirstResponder];
}

#pragma mark - Getters

#define PADDING_H 20

- (UITextField *)textFieldTitle {
    if (!_textFieldTitle) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(PADDING_H, 64 + 10, screenSize.width - 2 * PADDING_H, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.delegate = self;
        
        _textFieldTitle = textField;
    }
    
    return _textFieldTitle;
}

- (UITextView *)textViewBody {
    if (!_textViewBody) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat spaceV = 10;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(PADDING_H, CGRectGetMaxY(self.textFieldTitle.frame) + spaceV, screenSize.width - 2 * PADDING_H, screenSize.height - CGRectGetMaxY(self.textFieldTitle.frame) - PADDING_H - spaceV)];
        textView.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
        
        _textViewBody = textView;
    }
    
    return _textViewBody;
}

#pragma mark - Actions

- (void)cancelItemClicked:(id)sender {
    [self dismissKeyboard];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(viewControllerDidDismiss:)]) {
            [self.delegate viewControllerDidDismiss:self];
        }
    }];
}

- (void)createItemClicked:(id)sender {
    Note *note = [self createNote];
    note.title = self.textFieldTitle.text;
    note.body = self.textViewBody.text;
    
    if (self.context) {
        NSError *error;
        [self.context save:&error];
        if (error) {
            NSLog(@"error: %@", error);
        }
    }
    
    [self dismissKeyboard];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(viewControllerDidDismiss:)]) {
            [self.delegate viewControllerDidDismiss:self];
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -

- (void)dismissKeyboard {
    [self.textFieldTitle resignFirstResponder];
    [self.textViewBody resignFirstResponder];
}

- (Note *)createNote {
    Note *note;
    if (self.context) {
        note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:self.context];
    }
    return note;
}

@end
