//
//  SurfEntryTableViewCell.h
//  HelloCoreData
//
//  Created by wesley_chen on 18/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurfEntryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *starOneFilledImageView;
@property (weak, nonatomic) IBOutlet UIImageView *starOneImageView;

@property (weak, nonatomic) IBOutlet UIImageView *starTwoFilledImageView;
@property (weak, nonatomic) IBOutlet UIImageView *starTwoImageView;

@property (weak, nonatomic) IBOutlet UIImageView *starThreeFilledImageView;
@property (weak, nonatomic) IBOutlet UIImageView *starThreeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *starFourFilledImageView;
@property (weak, nonatomic) IBOutlet UIImageView *starFourImageView;

@property (weak, nonatomic) IBOutlet UIImageView *starFiveFilledImageView;
@property (weak, nonatomic) IBOutlet UIImageView *starFiveImageView;


@end
