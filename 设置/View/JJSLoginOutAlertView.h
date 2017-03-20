//
//  JJSAlertView.h
//  JJSMOA
//
//  Created by JJSAdmin on 15/6/15.
//  Copyright (c) 2015年 JJSHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJSLoginOutAlertView : UIView

typedef void (^JJSLoginOutAlertViewBlock)(void);

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) JJSLoginOutAlertViewBlock block;

- (id)initWithTitle:(NSString *)title;

- (void)animateShow:(BOOL)show completionBlock:(JJSLoginOutAlertViewBlock)completion;

@end
