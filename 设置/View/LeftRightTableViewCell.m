//
//  LeftRightTableViewCell.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/22.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "LeftRightTableViewCell.h"

@implementation LeftRightTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftLab = [[UILabel alloc] init];
        [self.leftLab setFrame:CGRectMake(20, 0, 150, self.contentView.frame.size.height)];
        [self.leftLab setFont:BoldLabelTextSize(16)];
        [self.contentView addSubview:self.leftLab];
        
        self.rightLab = [[UILabel alloc] init];
        [self.rightLab setFrame:CGRectMake(180, 0, UI_SCREEN_WIDTH - 200, self.contentView.frame.size.height)];
        [self.rightLab setFont:LabelTextSize(14)];
        [self.rightLab setTextColor:mRGB(188, 188, 188)];
        [self.rightLab setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.rightLab];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
