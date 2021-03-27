//
//  DetectShakeMotionViewController.m
//  HelloCMMotionManager
//
//  Created by wesley_chen on 2021/3/27.
//

#import "DetectShakeMotionViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "WCCoreMotionTool.h"

@interface DetectShakeMotionViewController ()
@property (nonatomic, strong) CMMotionManager *motionManager;
@end

@implementation DetectShakeMotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [WCCoreMotionTool startDeviceMotionListenerWithBizID:@"1" updateHandler:^(CMDeviceMotion * _Nonnull motion, NSError * _Nonnull error) {
        CMAcceleration userAcceleration = motion.userAcceleration;
        NSLog (@"1. %f, %f, %f", userAcceleration.x, userAcceleration.y, userAcceleration.z);
    }];
    
    [WCCoreMotionTool startDeviceMotionListenerWithBizID:@"2" updateHandler:^(CMDeviceMotion * _Nonnull motion, NSError * _Nonnull error) {
        CMAcceleration userAcceleration = motion.userAcceleration;
        NSLog (@"2. %f, %f, %f", userAcceleration.x, userAcceleration.y, userAcceleration.z);
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [WCCoreMotionTool stopDeviceMotionListenerWithBizID:@"1" completion:^(BOOL success) {
            
    }];
}

#define accelerationThreshold  0.30

- (void)handleMotion:(CMDeviceMotion *)deviceMotion {
    CMAcceleration userAcceleration = deviceMotion.userAcceleration;
    
    NSLog (@"%f, %f, %f", userAcceleration.x, userAcceleration.y, userAcceleration.z);
    
   if (fabs(userAcceleration.x) > accelerationThreshold ||
       fabs(userAcceleration.y) > accelerationThreshold ||
       fabs(userAcceleration.z) > accelerationThreshold) {
       float sensitivity = 1;
       float x1 = 0, x2 = 0, y1 = 0, y2 = 0, z1 = 0, z2 = 0;

       double totalAccelerationInXY = sqrt(userAcceleration.x * userAcceleration.x +
                                           userAcceleration.y * userAcceleration.y);

       if (0.85 < totalAccelerationInXY < 3.45) {
           x1 = userAcceleration.x;
           y1 = userAcceleration.y;
           z1 = userAcceleration.z;

           float change = fabs(x1-x2+y1-y2+z1-z2);
           if (sensitivity < change) {

             // print change in position in coordinates.
               NSLog (@"total=%f x=%f y=%f z=%f timeStamp:%f, UpTime:%f", totalAccelerationInXY, userAcceleration.x, userAcceleration.y, userAcceleration.z, deviceMotion.timestamp, [[NSProcessInfo processInfo] systemUptime]);

               x2 = x1;
               y2 = y1;
               z2 = z1;
           }
       }
   }
}

@end
