//
//  AFBaseViewController.h
//  
//
//  Created by Rainer on 15/12/10.
//
//

#import <UIKit/UIKit.h>

@interface AFBaseViewController : UIViewController
{
    //左返回
    UIButton *navigationBarLeftButton;
    
    //右键
    UIButton *navigationBarRightButton;
}

- (void)showLeftSideBar;
- (void)showRightSideBar;
/**
 *  Description:等待提示界面
 *
 *  @param message 提示语句
 *  @param view    显示位置
 */
- (void)showHUDWithWaitingMessage:(NSString *)message inSuperView:(UIView *)view;

/**
 *  Description:隐藏等待提示界面
 *
 *  @param view 界面位置
 */
- (void)hideHUD:(UIView *)view;

/**
 *  Description:提示界面自动隐藏
 *
 *  @param message      提示语句
 *  @param needAutoHide 是否自动隐藏
 *  @param view         显示位置
 */
- (void)showHUDWithMessage:(NSString*)message autoHide:(BOOL)needAutoHide inSuperView:(UIView *)view;

@end
