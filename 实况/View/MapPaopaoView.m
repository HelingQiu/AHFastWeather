//
//  MapPaopaoView.m
//  JJSButler
//
//  Created by 邱荷凌 on 15/7/7.
//  Copyright (c) 2015年 邱荷凌. All rights reserved.
//

#import "MapPaopaoView.h"

@implementation MapPaopaoView

- (instancetype)initWithFrame:(CGRect)frame model:(ActuallyModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setImage:[ImageNamed(@"map_bg") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 30, 10) resizingMode:UIImageResizingModeStretch]];
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, frame.size.width - 10, 16)];
        [lab1 setFont:LabelTextSize(14)];
        [lab1 setTextColor:[UIColor blackColor]];
        [lab1 setText:[@"时间：" stringByAppendingString:model.OBTime]];
        [self addSubview:lab1];
        
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(lab1.frame), frame.size.width - 10, 16)];
        [lab2 setFont:LabelTextSize(14)];
        [lab2 setTextColor:[UIColor blackColor]];
        [lab2 setText:[@"站名：" stringByAppendingString:model.StationName]];
        [self addSubview:lab2];
        
        UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(lab2.frame), frame.size.width - 10, 16)];
        [lab3 setFont:LabelTextSize(14)];
        [lab3 setTextColor:[UIColor blackColor]];
        [lab3 setText:[@"能见度：" stringByAppendingString:model.Visibility]];
        [self addSubview:lab3];
        
        UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(lab3.frame), frame.size.width - 10, 16)];
        [lab4 setFont:LabelTextSize(14)];
        [lab4 setTextColor:[UIColor blackColor]];
        [lab4 setText:[@"雨量：" stringByAppendingString:model.Rainfall]];
        [self addSubview:lab4];
        
        UILabel *lab5 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(lab4.frame), frame.size.width - 10, 16)];
        [lab5 setFont:LabelTextSize(14)];
        [lab5 setTextColor:[UIColor blackColor]];
        [lab5 setText:[@"气温：" stringByAppendingString:model.Temperature]];
        [self addSubview:lab5];
    }
    return self;
}

@end
