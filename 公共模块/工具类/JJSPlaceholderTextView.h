//
//  JJSPlaceholderTextView.h
//  JJSMOA
//
//  Created by Rainer on 15/6/4.
//  Copyright (c) 2015年 JJSHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJSPlaceholderTextView : UITextView

@property(nonatomic, copy) NSString *placeholder;

@property(nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, strong) UIColor* realTextColor;

//字数限制
@property(nonatomic) int limitCount;

@end
