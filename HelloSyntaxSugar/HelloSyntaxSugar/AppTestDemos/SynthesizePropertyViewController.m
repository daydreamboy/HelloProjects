//
//  SynthesizePropertyViewController.m
//  HelloSyntaxSugar
//
//  Created by wesley_chen on 2018/11/9.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "SynthesizePropertyViewController.h"

@interface SynthesizePropertyViewController ()
@property (nonatomic, copy) NSString *propertyWithAutoSynthesize;
@property (nonatomic, copy) NSString *propertyOnlyWithCustomSetter;
@property (nonatomic, copy) NSString *propertyOnlyWithCustomGetter;
@property (nonatomic, copy) NSString *propertyWithBothCustomSetterAndGetter;
@property (nonatomic, copy) NSString *propertyWithBothCustomSetterGetterAndManualSynthesize;
@end

@implementation SynthesizePropertyViewController

@synthesize propertyWithBothCustomSetterGetterAndManualSynthesize = _propertyWithBothCustomSetterGetterAndManualSynthesize;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _propertyWithAutoSynthesize = @"propertyWithAutoSynthesize";
}

#pragma mark - Only Setter

- (void)setPropertyOnlyWithCustomSetter:(NSString *)propertyOnlyWithCustomSetter {
    _propertyOnlyWithCustomSetter = propertyOnlyWithCustomSetter;
}

#pragma mark - Only Getter

- (NSString *)propertyOnlyWithCustomGetter {
    return _propertyOnlyWithCustomGetter;
}

#pragma mark - Both Setter and Getter

- (void)setPropertyWithBothCustomSetterAndGetter:(NSString *)propertyWithBothCustomSetterAndGetter {
    // Compile Error: Use of undeclared identifier '_propertyWithBothCustomSetterAndGetter'; did you mean 'propertyWithBothCustomSetterAndGetter'?
    /*
    _propertyWithBothCustomSetterAndGetter = propertyWithBothCustomSetterAndGetter;
     */
}

- (NSString *)propertyWithBothCustomSetterAndGetter {
    // Compile Error: Use of undeclared identifier '_propertyWithBothCustomSetterAndGetter'
    /*
    return _propertyWithBothCustomSetterAndGetter;
     */
    return @"";
}

- (void)setPropertyWithBothCustomSetterGetterAndManualSynthesize:(NSString *)propertyWithBothCustomSetterGetterAndManualSynthesize {
    _propertyWithBothCustomSetterGetterAndManualSynthesize = propertyWithBothCustomSetterGetterAndManualSynthesize;
}

- (NSString *)propertyWithBothCustomSetterGetterAndManualSynthesize {
    return _propertyWithBothCustomSetterGetterAndManualSynthesize;
}

@end
