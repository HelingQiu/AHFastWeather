//
//  AFSubTableViewCell.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/13.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFSubTableViewCell.h"

@implementation AFSubTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.bounds = CGRectMake(0,0,44,44);
    self.imageView.frame = CGRectMake(20,15,14,14);
    self.imageView.contentMode =UIViewContentModeScaleAspectFit;
    
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = 44;
    self.textLabel.frame = tmpFrame;
    
    tmpFrame = self.detailTextLabel.frame;
    tmpFrame.origin.x = 46;
    self.detailTextLabel.frame = tmpFrame;
    
    UIView *line = [UIView new];
    [line setFrame:CGRectMake(0, 43, UI_SCREEN_WIDTH, 1)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:line];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
