//
//  MapPopView.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/18.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "MapPopView.h"

@implementation MapPopView

- (instancetype)initWithFrame:(CGRect)frame params:(NSDictionary *)params
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        UILabel *lab = [[UILabel alloc] init];
        [lab setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [lab setText:@"没有低阀值站点"];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lab];
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
