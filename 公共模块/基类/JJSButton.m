//
//  JJSButton.m
//  JJSMOA
//
//  Created by JJSAdmin on 15/6/16.
//  Copyright (c) 2015年 JJSHome. All rights reserved.
//

#import "JJSButton.h"

@implementation JJSButton

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return self.imageRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return self.titleRect;
}

- (id)initWithFrame:(CGRect)frame forStyle:(int)s
{
    self = [super initWithFrame:frame];
    if (self) {
        UIRectCorner corners;
        
        switch (s)
        {
            case 0:
                corners = UIRectCornerBottomLeft;
                break;
            case 1:
                corners = UIRectCornerBottomRight;
                break;
            case 2:
                corners = UIRectCornerTopLeft;
                break;
            case 3:
                corners = UIRectCornerTopRight;
                break;
            case 4:
                corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
                break;
            case 5:
                corners = UIRectCornerTopLeft | UIRectCornerTopRight;
                break;
            case 6:
                corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
                break;
            case 7:
                corners = UIRectCornerBottomRight | UIRectCornerTopRight;
                break;
            case 8:
                corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
                break;
            case 9:
                corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft;
                break;
            default:
                corners = UIRectCornerAllCorners;
                break;
        }
        
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                       byRoundingCorners:corners
                                                             cornerRadii:CGSizeMake(4, 10)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame         = self.bounds;
        maskLayer.path          = maskPath.CGPath;
        self.layer.mask         = maskLayer;
    }
    return self;
}

@end
