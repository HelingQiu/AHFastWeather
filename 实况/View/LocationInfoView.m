//
//  LocationInfoView.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/17.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "LocationInfoView.h"

@implementation LocationInfoView

- (id)initWithFrame:(CGRect)frame location:(LocationModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7;
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, frame.size.width - 10, 14)];
        [lab1 setFont:LabelTextSize(10)];
        [lab1 setTextColor:[UIColor whiteColor]];
        [lab1 setText:[@"time：" stringByAppendingString:model.time]];
        [self addSubview:lab1];
        
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(lab1.frame), frame.size.width - 10, 14)];
        [lab2 setFont:LabelTextSize(10)];
        [lab2 setTextColor:[UIColor whiteColor]];
        [lab2 setText:[@"latitude：" stringByAppendingString:model.latitude]];
        [self addSubview:lab2];
        
        UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(lab2.frame), frame.size.width - 10, 14)];
        [lab3 setFont:LabelTextSize(10)];
        [lab3 setTextColor:[UIColor whiteColor]];
        [lab3 setText:[@"longtitude：" stringByAppendingString:model.longtitude]];
        [self addSubview:lab3];
        
        UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(lab3.frame), frame.size.width - 10, 14)];
        [lab4 setFont:LabelTextSize(10)];
        [lab4 setTextColor:[UIColor whiteColor]];
        [lab4 setText:[@"addr：" stringByAppendingString:model.addr]];
        [self addSubview:lab4];
        
        UILabel *lab5 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(lab4.frame), frame.size.width - 10, 14)];
        [lab5 setFont:LabelTextSize(10)];
        [lab5 setTextColor:[UIColor whiteColor]];
        [lab5 setText:[@"describe：" stringByAppendingString:model.describe]];
        [self addSubview:lab5];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
