//
//  TableViewCell.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell ()
@property (nonatomic, strong) UILabel *labelCustom;
@end

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView addSubview:self.labelCustom];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.labelCustom.frame = CGRectMake(5.0, 0.0, self.contentView.bounds.size.width - 10.0, self.contentView.bounds.size.height);
}

#pragma mark - Getter

- (UILabel *)labelCustom {
    if (!_labelCustom) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:16];
        
        _labelCustom = label;
    }
    
    return _labelCustom;
}

@end
