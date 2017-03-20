//
//  AFBaseViewController.m
//  
//
//  Created by Rainer on 15/12/10.
//
//

#import "AFBaseViewController.h"
#import <MBProgressHUD.h>
#import <RDVTabBarController.h>

@interface AFBaseViewController ()

@end

@implementation AFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //隐藏系统自带返回按钮
    self.navigationItem.hidesBackButton = YES;
    
    [self.view setBackgroundColor:mRGB(230, 230, 230)];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    //
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.barTintColor = mRGB(26, 31, 33);
    
    UIBarButtonItem *l_negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    l_negativeSpacer.width = - 15;
    
    navigationBarLeftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 86/2, 88/2)];
    navigationBarLeftButton.adjustsImageWhenHighlighted = YES;
    navigationBarLeftButton.backgroundColor = ClearColor;
    [navigationBarLeftButton setTitle:@"返回" forState:UIControlStateNormal];
    [navigationBarLeftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationBarLeftButton setImage:ImageNamed(@"btn_back") forState:UIControlStateNormal];
    [navigationBarLeftButton setTitleEdgeInsets:UIEdgeInsetsMake(22, 30, 22, 2)];
    
    [navigationBarLeftButton addTarget:self action:@selector(showLeftSideBar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:navigationBarLeftButton];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:l_negativeSpacer,leftItem, nil]];
    
    //右按钮
    navigationBarRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 88/2, 88/2)];
    navigationBarRightButton.adjustsImageWhenHighlighted = YES;
    navigationBarRightButton.hidden = YES;
    [navigationBarRightButton addTarget:self action:@selector(showRightSideBar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:navigationBarRightButton];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightItem, nil]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.title isEqualToString:@"实况"] && ![self.title isEqualToString:@"预报"] && ![self.title isEqualToString:@"服务"] && ![self.title isEqualToString:@"拍照"] && ![self.title isEqualToString:@"指令"] && ![self.title isEqualToString:@"设置"]) {
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (![self.title isEqualToString:@"实况"] && ![self.title isEqualToString:@"预报"] && ![self.title isEqualToString:@"服务"] && ![self.title isEqualToString:@"拍照"] && ![self.title isEqualToString:@"指令"] && ![self.title isEqualToString:@"设置"]) {
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    }
}

- (void)showLeftSideBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showRightSideBar
{

}

#pragma mark - 下列方法不阻塞页面跳转(不加载在window上)
- (void)showHUDWithWaitingMessage:(NSString *)message inSuperView:(UIView *)view {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    if ([PublicTools judgeStringNotEmpty:message]) {
        hud.detailsLabelText = message;
    }
    hud.layer.zPosition = 9999;
    hud.margin = 16.f;
    
    hud.removeFromSuperViewOnHide = YES;
}

- (void)hideHUD:(UIView *)view {
    
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

- (void)showHUDWithMessage:(NSString*)message autoHide:(BOOL)needAutoHide inSuperView:(UIView *)view {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.layer.zPosition = 9999;
    hud.margin = 16.f;
    hud.removeFromSuperViewOnHide = YES;
    
    if (needAutoHide)
        [hud hide:YES afterDelay:1.3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
