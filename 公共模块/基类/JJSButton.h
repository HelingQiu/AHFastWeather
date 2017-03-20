//
//  JJSButton.h
//  JJSMOA
//
//  Created by JJSAdmin on 15/6/16.
//  Copyright (c) 2015年 JJSHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJSButton : UIButton

@property (nonatomic , assign) CGRect imageRect;

@property (nonatomic , assign) CGRect titleRect;

//圆角style
- (id)initWithFrame:(CGRect)frame forStyle:(int)s;

@end
