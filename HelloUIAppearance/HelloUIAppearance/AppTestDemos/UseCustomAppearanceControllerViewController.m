//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "UseCustomAppearanceControllerViewController.h"
#import "MyViewWithUIAppearance.h"

@interface UseCustomAppearanceControllerViewController ()
@property (nonatomic, strong) MyViewWithUIAppearance *myView;
@end

@implementation UseCustomAppearanceControllerViewController

#define CLASS_PROPERTY_DEFINITION(getterName, setterName, type) \
@dynamic getterName; \
static type __static_##getterName; \
+ (void)setterName:(type)object { \
    __static_##getterName = object; \
} \
+ (type)getterName { \
    return __static_##getterName; \
}

CLASS_PROPERTY_DEFINITION(disableSomething, setDisableSomething, BOOL);

//@dynamic disableSomething;
//
//static BOOL sDisableSomething;
//
//+ (void)setDisableSomething:(BOOL)disableSomething {
//    sDisableSomething = disableSomething;
//}
//
//+ (BOOL)disableSomething {
//    return sDisableSomething;
//}

- (instancetype)init {
    self = [super init];
    if (self) {
        [MyViewWithUIAppearance appearance].myBackgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.myView];
    
    if (!UseCustomAppearanceControllerViewController.disableSomething) {
        [MyViewWithUIAppearance appearance].myBorderColor = [UIColor redColor];
        [MyViewWithUIAppearance appearance].myBorderWidth = 1.0;
    }
}

#pragma mark - Getters

- (MyViewWithUIAppearance *)myView {
    if (!_myView) {
        MyViewWithUIAppearance *view = [[MyViewWithUIAppearance alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
        _myView = view;
    }
    
    return _myView;
}

@end
