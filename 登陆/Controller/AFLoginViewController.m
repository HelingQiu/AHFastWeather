//
//  AFLoginViewController.m
//  
//
//  Created by Rainer on 15/12/10.
//
//

#import "AFLoginViewController.h"
#import "LoginVM.h"
#import "AFRegisterViewController.h"

@interface AFLoginViewController ()<UITextFieldDelegate>
{
    UIScrollView *mainScrollView;
    UITextField *workNumberTF;
    UITextField *pwdTF;
    
    UILabel *lineLbl1;
    UILabel *lineLbl2;
    CustomKeyboard *customKeyboard;
    
    UIButton *loginButton;
    
}
@end

@implementation AFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"交通气象服务";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [navigationBarLeftButton setHidden:YES];
    
    [self layoutMainView];
}

- (void)layoutMainView
{
    //滚动
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    //此处不知为什么 一定要设置的比scrollview的大小要大才可以滚动
    mainScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT+1);
    mainScrollView.pagingEnabled = NO;
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setShowsVerticalScrollIndicator:NO];
    [mainScrollView setBounces:YES];
    [self.view addSubview:mainScrollView];
    
    UILabel *lab1 = [UILabel new];
    [lab1 setFrame:CGRectMake(20, 20, 100, 18)];
    [lab1 setFont:BoldLabelTextSize(16)];
    [lab1 setText:@"省份"];
    [mainScrollView addSubview:lab1];
    
    UILabel *labProvince = [UILabel new];
    [labProvince setFrame:CGRectMake(UI_SCREEN_WIDTH - 120, 20, 100, 18)];
    [labProvince setFont:BoldLabelTextSize(16)];
    [labProvince setText:@"安徽"];
    [labProvince setTextColor:mRGB(44, 185, 254)];
    [labProvince setTextAlignment:NSTextAlignmentRight];
    [mainScrollView addSubview:labProvince];
    
    UIImageView *headView = [UIImageView new];
    [headView setFrame:CGRectMake(UI_SCREEN_WIDTH/2 - 50, CGRectGetMaxY(labProvince.frame) + 20, 100, 100)];
    [headView setImage:ImageNamed(@"default_face")];
    [mainScrollView addSubview:headView];
    
    UILabel *workNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(36/2, CGRectGetMaxY(headView.frame) + 20, 40, 44)];
    workNumberLbl.backgroundColor = ClearColor;
    workNumberLbl.text = @"警号";
    workNumberLbl.font = BoldLabelTextSize(16);
    workNumberLbl.textColor = [UIColor blackColor];
    [mainScrollView addSubview:workNumberLbl];
    
    //工号输入框
    workNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(workNumberLbl.frame)+20, CGRectGetMaxY(headView.frame) + 20, UI_SCREEN_WIDTH - CGRectGetMaxX(workNumberLbl.frame)-20, 44)];
    workNumberTF.backgroundColor = ClearColor;
    workNumberTF.delegate = self;
    workNumberTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    workNumberTF.placeholder = @"请输入您的警号";
    //textfield placeholder color
    [workNumberTF setValue:mRGB(207, 207, 207) forKeyPath:@"_placeholderLabel.textColor"];
    workNumberTF.font = LabelTextSize(16.0f);
    workNumberTF.textColor = [UIColor blackColor];
    workNumberTF.tag = 0x1111;
    workNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    workNumberTF.returnKeyType = UIReturnKeyDone;
    workNumberTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [workNumberTF addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [mainScrollView addSubview:workNumberTF];
    
    if ([PublicTools judgeStringNotEmpty:[[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_NAME]]) {
        workNumberTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_NAME];
    }
    
    lineLbl1 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(workNumberTF.frame) - 1.5, UI_SCREEN_WIDTH - 20, 1.5)];
    lineLbl1.backgroundColor = HEXCOLOR(0xe1e9ef);
    [mainScrollView addSubview:lineLbl1];
    
    UILabel *pwdLbl = [[UILabel alloc] initWithFrame:CGRectMake(36/2, CGRectGetMaxY(lineLbl1.frame) + 10, 40, 44)];
    pwdLbl.backgroundColor = ClearColor;
    pwdLbl.text = @"密码";
    pwdLbl.font = BoldLabelTextSize(16);
    pwdLbl.textColor = [UIColor blackColor];
    [mainScrollView addSubview:pwdLbl];
    
    //密码输入框
    pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(workNumberLbl.frame)+20, CGRectGetMaxY(lineLbl1.frame) + 10, UI_SCREEN_WIDTH - CGRectGetMaxX(workNumberLbl.frame)-20, 44)];
    pwdTF.backgroundColor = ClearColor;
    pwdTF.delegate = self;
    pwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    pwdTF.placeholder = @"请输入密码";
    //textfield placeholder color
    [pwdTF setValue:mRGB(207, 207, 207) forKeyPath:@"_placeholderLabel.textColor"];
    pwdTF.font = LabelTextSize(16.0f);
    pwdTF.textColor = [UIColor blackColor];
    pwdTF.tag = 0x1112;
    pwdTF.returnKeyType = UIReturnKeyDone;
    pwdTF.secureTextEntry = YES;
    pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [pwdTF addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [mainScrollView addSubview:pwdTF];
    
    lineLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(pwdTF.frame) - 1.5, UI_SCREEN_WIDTH - 20, 1.5)];
    lineLbl2.backgroundColor = HEXCOLOR(0xe1e9ef);
    [mainScrollView addSubview:lineLbl2];
    
    //登陆
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(pwdTF.frame) + 30, UI_SCREEN_WIDTH - 20, 44)];
    loginButton.adjustsImageWhenHighlighted = YES;
    loginButton.backgroundColor = mRGB(135, 215, 248);
    loginButton.userInteractionEnabled = NO;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateSelected];
    [loginButton setTitle:@"登录" forState:UIControlStateHighlighted];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [[loginButton titleLabel] setFont:BoldLabelTextSize(18)];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:loginButton];
    
    UIButton *registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registButton setFrame:CGRectMake(UI_SCREEN_WIDTH - 90, CGRectGetMaxY(loginButton.frame) + 10, 80, 20)];
    [registButton setTitle:@"注册新用户" forState:UIControlStateNormal];
    [registButton.titleLabel setFont:LabelTextSize(14)];
    [registButton setTitleColor:mRGB(44, 185, 254) forState:UIControlStateNormal];
    [registButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:registButton];
}

//登陆事件
- (void)loginButtonClick
{
    [self.view endEditing:YES];
    
    if (![PublicTools judgeStringNotEmpty:workNumberTF.text]) {
        [self showHUDWithMessage:@"请输入您的警号" autoHide:YES inSuperView:self.view];
        return ;
    }
    
    if (![PublicTools judgeStringNotEmpty:pwdTF.text]) {
        [self showHUDWithMessage:@"请输入您的警号" autoHide:YES inSuperView:self.view];
        return ;
    }
    
    __weak typeof (self) weakSelf = self;
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:AF_LOGIN_URL,@"op",workNumberTF.text,@"account",pwdTF.text,@"password", nil];
    [[LoginVM alloc] longinWithParams:body complete:^(BOOL finish, id obj) {
        if (finish) {
            if (weakSelf.isReLogin) {
                if (weakSelf.block) {
                    weakSelf.block();
                }
                //KVO 监听登录状态，修改界面
//                [MOAConfig sharedInstance].isLogined = YES;
                
                [weakSelf.navigationController popViewControllerWithNavigationControllerTransition];
            }else{
                //进入主界面
                [weakSelf setViewControllers];
            }
            
        }
    }];
}
//注册
- (void)registerAction:(id)sender
{
    AFRegisterViewController *registerViewController = [[AFRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerViewController animated:YES];
    
    __block UITextField *blockTF = workNumberTF;
    registerViewController.BackBlock = ^(){
        blockTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_NAME];
    };
}
//输入框
- (void)textFieldValueChanged:(UITextField *)textField
{
    if ([PublicTools judgeStringNotEmpty:workNumberTF.text] && [PublicTools judgeStringNotEmpty:pwdTF.text]) {
        loginButton.userInteractionEnabled = YES;
        [loginButton setBackgroundColor:mRGB(44, 185, 254)];
    }else{
        loginButton.userInteractionEnabled = NO;
        loginButton.backgroundColor = mRGB(135, 215, 248);
    }
}

#pragma mark textfieldDelegate
-  (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return  YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == workNumberTF) {
        lineLbl1.backgroundColor = mRGB(44, 185, 254);
        lineLbl2.backgroundColor = HEXCOLOR(0xe1e9ef);
    }else if (textField == pwdTF) {
        lineLbl1.backgroundColor = HEXCOLOR(0xe1e9ef);
        lineLbl2.backgroundColor = mRGB(44, 185, 254);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)setViewControllers
{
    AFFirstViewController *firstViewController = [[AFFirstViewController alloc] init];
    UINavigationController *firstNavController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    
    AFSecondViewController *secondViewController = [[AFSecondViewController alloc] init];
    UINavigationController *secondNavController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    
    AFThirdViewController *thirdViewController = [[AFThirdViewController alloc] init];
    UINavigationController *thirdNavController = [[UINavigationController alloc] initWithRootViewController:thirdViewController];
    
    AFForthViewController *forthViewController = [[AFForthViewController alloc] init];
    UINavigationController *forthNavController = [[UINavigationController alloc] initWithRootViewController:forthViewController];
    
    AFFifthViewController *fifthViewController = [[AFFifthViewController alloc] init];
    UINavigationController *fifthNavController = [[UINavigationController alloc] initWithRootViewController:fifthViewController];
    
//    AFSixthViewController *sixthViewController = [[AFSixthViewController alloc] init];
//    UINavigationController *sixthNavController = [[UINavigationController alloc] initWithRootViewController:sixthViewController];
    
    RDVTabBarController *tabbarController = [[RDVTabBarController alloc] init];
    [tabbarController setViewControllers:@[firstNavController,secondNavController,thirdNavController,forthNavController,fifthNavController]];
    
    [self customizeTabBarForController:tabbarController];
    
    [self.navigationController pushViewControllerWithNavigationControllerTransition:tabbarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController
{
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    
    NSArray *tabBarItemImages = @[@"ic_ob",@"ic_forecast", @"ic_service",@"ic_profile", @"ic_order"];
    NSArray *tabBarItemTitle = @[@"实况",@"预报", @"服务",@"拍照", @"指令"];
    UIColor *unselectColor = mRGB(146, 148, 147);
    UIColor *selectColor = mRGB(56, 176, 249);
    
    int index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        //设置tab item的title
        
        [item setTitle:[tabBarItemTitle objectAtIndex:index]];
        
        [item setUnselectedTitleAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            unselectColor, NSForegroundColorAttributeName,
                                            [UIFont systemFontOfSize:12],
                                            NSFontAttributeName,
                                            nil]];
        [item setSelectedTitleAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          selectColor, NSForegroundColorAttributeName,
                                          [UIFont systemFontOfSize:12],
                                          NSFontAttributeName,
                                          nil]];
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:finishedImage];
        
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
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
