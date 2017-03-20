//
//  RoadTableViewCell.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/28.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "RoadTableViewCell.h"

@implementation RoadTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView setFrame:CGRectMake(20, 17, 14, 10)];
        [imgView setImage:ImageNamed(@"ic_item")];
        [self.contentView addSubview:imgView];
        
        self.labContent = [[UILabel alloc] init];
        [self.labContent setFrame:CGRectMake(46, 0, UI_SCREEN_WIDTH - 46 - 44, 44)];
        [self.labContent setFont:LabelTextSize(16)];
        [self.labContent setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.labContent];
        
        self.selectItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectItem setFrame:CGRectMake(UI_SCREEN_WIDTH - 10 - 24, 10, 24, 24)];
        [self.selectItem setImage:ImageNamed(@"noSelected") forState:UIControlStateNormal];
        [self.selectItem setImage:ImageNamed(@"Selected") forState:UIControlStateSelected];
        [self.contentView addSubview:self.selectItem];
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
