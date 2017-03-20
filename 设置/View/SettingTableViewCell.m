//
//  SettingTableViewCell.m
//  
//
//  Created by Rainer on 15/12/12.
//
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgView = [UIImageView new];
        [self.imgView setFrame:CGRectMake(10, 10, 24, 24)];
        [self.contentView addSubview:self.imgView];
        
        self.labTitle = [UILabel new];
        [self.labTitle setFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame) + 10, 0, 200, 44)];
        [self.labTitle setFont:BoldLabelTextSize(16)];
        [self.labTitle setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:self.labTitle];
        
        self.labLogout = [UILabel new];
        [self.labLogout setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH - 20, 44)];
        [self.labLogout setTextAlignment:NSTextAlignmentCenter];
        [self.labLogout setFont:BoldLabelTextSize(16)];
        [self.labLogout setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:self.labLogout];
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
