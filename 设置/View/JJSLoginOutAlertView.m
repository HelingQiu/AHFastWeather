//
//  JJSAlertView.m
//  JJSMOA
//
//  Created by JJSAdmin on 15/6/15.
//  Copyright (c) 2015年 JJSHome. All rights reserved.
//

#import "JJSLoginOutAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "JJSButton.h"

@implementation JJSLoginOutAlertView
{
    UIInterfaceOrientation _currentOrientation;
    
    UIView *overlay;
}

- (id)initWithTitle:(NSString *)title
{
    self = [super initWithFrame:CGRectMake((UI_SCREEN_WIDTH-540/2)/2, (UI_SCREEN_HEIGHT-194/2)/2, 540/2, 194/2)];
    if (self) {
        self.opaque = NO;
        self.alpha = 1.0;
        
        UIView *whiteView = [[UIView alloc] initWithFrame:self.bounds];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.cornerRadius = 6;
        whiteView.layer.masksToBounds = YES;
        [self addSubview:whiteView];
        
        //标题
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(whiteView.frame), 114/2)];
        titleLbl.backgroundColor = ClearColor;
        titleLbl.textColor = HEXCOLOR(0x2c3e50);
        titleLbl.numberOfLines = 0;
        titleLbl.font = LabelTextSize(15.0f);
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.lineBreakMode = NSLineBreakByWordWrapping;
        titleLbl.text = title;
        [whiteView addSubview:titleLbl];
//
        UILabel *line1Lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLbl.frame), CGRectGetWidth(whiteView.frame), 0.5)];
        line1Lbl.backgroundColor = HEXCOLOR(0xe1e9f0);
        [whiteView addSubview:line1Lbl];
        //确定
        JJSButton *confirmButton = [[JJSButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1Lbl.frame), CGRectGetWidth(whiteView.frame)/2, CGRectGetHeight(whiteView.frame)-CGRectGetMaxY(line1Lbl.frame)) forStyle:0];
        [confirmButton setTitleRect:CGRectMake(0, 0, CGRectGetWidth(whiteView.frame)/2, CGRectGetHeight(whiteView.frame)-CGRectGetMaxY(line1Lbl.frame))];
        [confirmButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        confirmButton.adjustsImageWhenHighlighted = YES;
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        confirmButton.titleLabel.font = LabelTextSize(15);
        [confirmButton setTitleColor:mRGB(44, 185, 254) forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(yesButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:confirmButton];
        
        //取消
        JJSButton *cannelButton = [[JJSButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(whiteView.frame)/2, CGRectGetMaxY(line1Lbl.frame), CGRectGetWidth(whiteView.frame)/2, CGRectGetHeight(whiteView.frame)-CGRectGetMaxY(line1Lbl.frame)) forStyle:1];
        cannelButton.adjustsImageWhenHighlighted = YES;
        [cannelButton setTitleRect:CGRectMake(0, 0, CGRectGetWidth(whiteView.frame)/2, CGRectGetHeight(whiteView.frame)-CGRectGetMaxY(line1Lbl.frame))];
        [cannelButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [cannelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cannelButton setTitleColor:mRGB(44, 185, 254) forState:0];
//        cannelButton.backgroundColor = HEXCOLOR(0xfc6565);
        cannelButton.titleLabel.font = LabelTextSize(15);
        [cannelButton addTarget:self action:@selector(noButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:cannelButton];

        UILabel *line2Lbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(whiteView.frame)/2, CGRectGetMaxY(line1Lbl.frame), 0.5, CGRectGetHeight(whiteView.frame)-CGRectGetMaxY(line1Lbl.frame))];
        line2Lbl.backgroundColor = HEXCOLOR(0xe1e9f0);
        [whiteView addSubview:line2Lbl];
        
    }
    return self;
}

- (void)noButtonClick
{
    [self animateShow:NO completionBlock:nil];
}

- (void)yesButtonClick
{
    self.block();
    [self animateShow:NO completionBlock:nil];
}


- (void)showOverlay:(BOOL)show {
    if (show) {
        // create a new window to add our overlay and dialogs to
        UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window = window;
        window.windowLevel = UIWindowLevelStatusBar + 1;
        window.opaque = NO;
        
        // darkened background
        overlay = [UIView new];
        overlay.opaque = NO;
        overlay.frame = self.window.bounds;
        overlay.backgroundColor = [UIColor colorWithWhite:0.22 alpha:0.5];
        
        [self.window addSubview:overlay];
        [self.window addSubview:self];
        
        // window has to be un-hidden on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.window makeKeyAndVisible];
            
            // fade in overlay
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                //self.blurredBackgroundView.alpha = 1.0f;
                overlay.alpha = 1.0f;
            } completion:^(BOOL finished) {
                // stub
            }];
        });
    }
    else {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            overlay.alpha = 0.0f;
            //self.blurredBackground.alpha = 0.0f;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)animateShow:(BOOL)show completionBlock:(JJSLoginOutAlertViewBlock)completion {
    if (completion)
    {
        self.block = completion;
    }
    
    //    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGAffineTransform transform = self.transform;
    
    if (show) {
        _currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        transform = [self transformForOrientation:_currentOrientation];
        self.transform = transform;
        self.layer.transform = CATransform3DMakeAffineTransform(transform);
    }
    
    // some animation durations need to be slightly longer on iPad since more distance to travel, so assign a scale factor
    //    CGFloat durationScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1.2 : 1.0;
    
    // default "pop" animation like UIAlertView
    if (show) {
        [self showOverlay:YES];
        
        self.alpha = 0.0f;
        self.transform = CGAffineTransformScale(transform, 0.7, 0.7);
        
        [UIView animateWithDuration:0.18 animations:^{
            self.transform = CGAffineTransformScale(transform, 1.1, 1.1);
            self.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.13 animations:^{
                self.transform = CGAffineTransformScale(transform, 0.9, 0.9);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    self.transform = transform;
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }
    else {
        [self showOverlay:NO];
        
        [UIView animateWithDuration:0.13 animations:^{
            self.transform = CGAffineTransformScale(transform, 1.1, 1.1);
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.18 animations:^{
                    self.transform = CGAffineTransformScale(transform, 0.7, 0.7);
                    self.alpha = 0.0f;
                } completion:^(BOOL finished) {
                    if (finished) {
                        self.alpha = 0.0f;
                        [self cleanup];
                    }
                }];
            }
            
        }];
    }
}

- (void)cleanup {
    //self.layer.transform = CATransform3DIdentity;
    //self.transform = CGAffineTransformIdentity;
//    self.alpha = 1.0f;
    self.window = nil;
    // rekey main AppDelegate window
    [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // calculate a rotation transform that matches the required orientation
    if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        transform = CGAffineTransformMakeRotation(M_PI);
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    else if (orientation == UIInterfaceOrientationLandscapeRight) {
        transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    
    return transform;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-  (void)dealloc
{
    NSDebugLog();
}


@end
