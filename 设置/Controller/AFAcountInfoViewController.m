//
//  AFAcountInfoViewController.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/13.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFAcountInfoViewController.h"
#import "JJSButton.h"
#import "SettingVM.h"

@interface AFAcountInfoViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UIScrollView *mainScrollView;
    
    UITextField *nameTF;
    UITextField *phoneTF;
    UITextField *workNumberTF;
    UITextField *pwdTF;
    
    JJSButton *areaButton;
    JJSButton *ownerButton;
    
    UILabel *lineLbl1;
    UILabel *lineLbl2;
    UILabel *lineLbl3;
    UILabel *lineLbl4;
    
    UIButton *registButton;
    UIAlertView *pwalertView;
    UIButton *verButton;
}
@end

@implementation AFAcountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"账号信息";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initilizeBaseView];
}

- (void)initilizeBaseView
{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_INFO];
    UserModel *model = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //滚动
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    //此处不知为什么 一定要设置的比scrollview的大小要大才可以滚动
    mainScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT+1);
    mainScrollView.pagingEnabled = NO;
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setShowsVerticalScrollIndicator:NO];
    [mainScrollView setBounces:YES];
    [self.view addSubview:mainScrollView];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(36/2, 20, 40, 44)];
    nameLbl.backgroundColor = ClearColor;
    nameLbl.text = @"姓名";
    nameLbl.font = BoldLabelTextSize(16);
    nameLbl.textColor = [UIColor blackColor];
    [mainScrollView addSubview:nameLbl];
    
    //姓名输入框
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLbl.frame)+20, 20, UI_SCREEN_WIDTH - CGRectGetMaxX(nameLbl.frame)-20, 44)];
    nameTF.backgroundColor = ClearColor;
    nameTF.delegate = self;
    nameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameTF.placeholder = @"例如：于巍";
    nameTF.text = model.name;
    //textfield placeholder color
    [nameTF setValue:mRGB(207, 207, 207) forKeyPath:@"_placeholderLabel.textColor"];
    nameTF.font = LabelTextSize(16.0f);
    nameTF.textColor = [UIColor blackColor];
    nameTF.tag = 0x2111;
    nameTF.returnKeyType = UIReturnKeyDone;
    nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [nameTF addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [mainScrollView addSubview:nameTF];
    
    lineLbl1 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nameTF.frame) - 1.5, UI_SCREEN_WIDTH - 20, 1.5)];
    lineLbl1.backgroundColor = HEXCOLOR(0xe1e9ef);
    [mainScrollView addSubview:lineLbl1];
    
    UILabel *phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(36/2, CGRectGetMaxY(lineLbl1.frame) + 10, 40, 44)];
    phoneLbl.backgroundColor = ClearColor;
    phoneLbl.text = @"手机";
    phoneLbl.font = BoldLabelTextSize(16);
    phoneLbl.textColor = [UIColor blackColor];
    [mainScrollView addSubview:phoneLbl];
    
    //电话输入框
    phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLbl.frame)+20, CGRectGetMaxY(lineLbl1.frame) + 10, UI_SCREEN_WIDTH - CGRectGetMaxX(phoneLbl.frame)-20, 44)];
    phoneTF.backgroundColor = ClearColor;
    phoneTF.delegate = self;
    phoneTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTF.placeholder = @"您的手机号码";
    phoneTF.text = model.MobilePhone;
    //textfield placeholder color
    [phoneTF setValue:mRGB(207, 207, 207) forKeyPath:@"_placeholderLabel.textColor"];
    phoneTF.font = LabelTextSize(16.0f);
    phoneTF.textColor = [UIColor blackColor];
    phoneTF.tag = 0x2112;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.returnKeyType = UIReturnKeyDone;
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [phoneTF addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [mainScrollView addSubview:phoneTF];
    
    lineLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(phoneTF.frame) - 1.5, UI_SCREEN_WIDTH - 20, 1.5)];
    lineLbl2.backgroundColor = HEXCOLOR(0xe1e9ef);
    [mainScrollView addSubview:lineLbl2];
    
    UILabel *areaLbl = [[UILabel alloc] initWithFrame:CGRectMake(36/2, CGRectGetMaxY(lineLbl2.frame) + 10, 40, 44)];
    areaLbl.backgroundColor = ClearColor;
    areaLbl.text = @"地区";
    areaLbl.font = BoldLabelTextSize(16);
    areaLbl.textColor = [UIColor blackColor];
    [mainScrollView addSubview:areaLbl];
    
    areaButton = [JJSButton buttonWithType:UIButtonTypeCustom];
    [areaButton setFrame:CGRectMake(CGRectGetMaxX(areaLbl.frame)+20, CGRectGetMaxY(lineLbl2.frame) + 10, UI_SCREEN_WIDTH - CGRectGetMaxX(areaLbl.frame)-20, 44)];
    [areaButton setTitleRect:CGRectMake(0, 0, UI_SCREEN_WIDTH - CGRectGetMaxX(areaLbl.frame)-20, 44)];
    [areaButton.titleLabel setFont:BoldLabelTextSize(16)];
    [areaButton setTitle:@"合肥市" forState:UIControlStateNormal];
    [areaButton setTitle:model.city forState:UIControlStateNormal];
    [areaButton setTitleColor:mRGB(44, 185, 254) forState:UIControlStateNormal];
    [mainScrollView addSubview:areaButton];
    
    UILabel *ownerLbl = [[UILabel alloc] initWithFrame:CGRectMake(36/2, CGRectGetMaxY(areaButton.frame) + 10, 40, 44)];
    ownerLbl.backgroundColor = ClearColor;
    ownerLbl.text = @"所属";
    ownerLbl.font = BoldLabelTextSize(16);
    ownerLbl.textColor = [UIColor blackColor];
    [mainScrollView addSubview:ownerLbl];
    
    ownerButton = [JJSButton buttonWithType:UIButtonTypeCustom];
    [ownerButton setFrame:CGRectMake(CGRectGetMaxX(ownerLbl.frame)+20, CGRectGetMaxY(areaButton.frame) + 10, UI_SCREEN_WIDTH - CGRectGetMaxX(ownerLbl.frame)-20, 44)];
    [ownerButton setTitleRect:CGRectMake(0, 0, UI_SCREEN_WIDTH - CGRectGetMaxX(areaLbl.frame)-20, 44)];
    [ownerButton.titleLabel setFont:BoldLabelTextSize(16)];
    [ownerButton setTitle:@"交警大队" forState:UIControlStateNormal];
    [ownerButton setTitle:model.depart forState:UIControlStateNormal];
    [ownerButton setTitleColor:mRGB(44, 185, 254) forState:UIControlStateNormal];
    [mainScrollView addSubview:ownerButton];
    
    UILabel *ownerLineLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(ownerButton.frame) - 1, UI_SCREEN_WIDTH - 20, 1)];
    ownerLineLbl.backgroundColor = HEXCOLOR(0xe1e9ef);
    [mainScrollView addSubview:ownerLineLbl];
    
    UILabel *workNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(36/2, CGRectGetMaxY(ownerButton.frame) + 10, 40, 44)];
    workNumberLbl.backgroundColor = ClearColor;
    workNumberLbl.text = @"警号";
    workNumberLbl.font = BoldLabelTextSize(16);
    workNumberLbl.textColor = [UIColor blackColor];
    [mainScrollView addSubview:workNumberLbl];
    
    //工号输入框
    workNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(workNumberLbl.frame)+20, CGRectGetMaxY(ownerButton.frame) + 10, UI_SCREEN_WIDTH - CGRectGetMaxX(workNumberLbl.frame)-20, 44)];
    workNumberTF.backgroundColor = ClearColor;
    workNumberTF.delegate = self;
    workNumberTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    workNumberTF.placeholder = @"请输入您的警号";
    workNumberTF.text = model.Account;
    //textfield placeholder color
    [workNumberTF setValue:mRGB(207, 207, 207) forKeyPath:@"_placeholderLabel.textColor"];
    workNumberTF.font = LabelTextSize(16.0f);
    workNumberTF.textColor = [UIColor blackColor];
    workNumberTF.tag = 0x2113;
    workNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    workNumberTF.returnKeyType = UIReturnKeyDone;
    workNumberTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    workNumberTF.enabled = NO;
    [mainScrollView addSubview:workNumberTF];
    
    lineLbl3 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(workNumberTF.frame) - 1.5, UI_SCREEN_WIDTH - 20, 1.5)];
    lineLbl3.backgroundColor = HEXCOLOR(0xe1e9ef);
    [mainScrollView addSubview:lineLbl3];
    
    UILabel *pwdLbl = [[UILabel alloc] initWithFrame:CGRectMake(36/2, CGRectGetMaxY(lineLbl3.frame) + 10, 40, 44)];
    pwdLbl.backgroundColor = ClearColor;
    pwdLbl.text = @"密码";
    pwdLbl.font = BoldLabelTextSize(16);
    pwdLbl.textColor = [UIColor blackColor];
    [mainScrollView addSubview:pwdLbl];
    
    //密码输入框
    pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(workNumberLbl.frame)+20, CGRectGetMaxY(lineLbl3.frame) + 10, UI_SCREEN_WIDTH - CGRectGetMaxX(workNumberLbl.frame)-20, 44)];
    pwdTF.backgroundColor = ClearColor;
    pwdTF.delegate = self;
    pwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //textfield placeholder color
    [pwdTF setValue:mRGB(207, 207, 207) forKeyPath:@"_placeholderLabel.textColor"];
    pwdTF.font = LabelTextSize(16.0f);
    pwdTF.textColor = [UIColor blackColor];
    pwdTF.tag = 0x1112;
    pwdTF.returnKeyType = UIReturnKeyDone;
    pwdTF.secureTextEntry = YES;
    pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTF.enabled = NO;
    [pwdTF addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [mainScrollView addSubview:pwdTF];
    
    verButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [verButton setFrame:CGRectMake(CGRectGetMaxX(workNumberLbl.frame)+20, CGRectGetMaxY(lineLbl3.frame) + 10, UI_SCREEN_WIDTH - CGRectGetMaxX(workNumberLbl.frame)-20, 44)];
    [verButton addTarget:self action:@selector(verificationAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:verButton];
    
    lineLbl4 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(pwdTF.frame) - 1.5, UI_SCREEN_WIDTH - 20, 1.5)];
    lineLbl4.backgroundColor = HEXCOLOR(0xe1e9ef);
    lineLbl4.hidden = YES;
    [mainScrollView addSubview:lineLbl4];
    
    //提交
    registButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(pwdTF.frame) + 30, UI_SCREEN_WIDTH - 20, 44)];
    registButton.adjustsImageWhenHighlighted = YES;
    registButton.backgroundColor = mRGB(135, 215, 248);
    registButton.userInteractionEnabled = NO;
    [registButton setTitle:@"提交" forState:UIControlStateNormal];
    [registButton setTitle:@"提交" forState:UIControlStateSelected];
    [registButton setTitle:@"提交" forState:UIControlStateHighlighted];
    [registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [[registButton titleLabel] setFont:BoldLabelTextSize(18)];
    [registButton addTarget:self action:@selector(comfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:registButton];
}

- (void)verificationAction:(UIButton *)sender
{
    pwalertView = [[UIAlertView alloc] initWithTitle:@"请输入原密码进行验证" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    pwalertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [pwalertView show];
}
//输入框
- (void)textFieldValueChanged:(UITextField *)textField
{
    if ([PublicTools judgeStringNotEmpty:pwdTF.text])
    {
        registButton.userInteractionEnabled = YES;
        [registButton setBackgroundColor:mRGB(44, 185, 254)];
    }else{
        registButton.userInteractionEnabled = NO;
        registButton.backgroundColor = mRGB(135, 215, 248);
    }
}

- (void)comfirmButtonClick:(id)sender
{
    [self.view endEditing:YES];
    
    if (![PublicTools judgeStringNotEmpty:nameTF.text]) {
        [self showHUDWithMessage:@"请输入您的姓名" autoHide:YES inSuperView:self.view];
        return;
    }
    
    if (![PublicTools judgeStringNotEmpty:phoneTF.text]) {
        [self showHUDWithMessage:@"请输入您的手机号码" autoHide:YES inSuperView:self.view];
        return;
    }
    
    if (![PublicTools judgeStringNotEmpty:areaButton.titleLabel.text]) {
        [self showHUDWithMessage:@"请选择地区" autoHide:YES inSuperView:self.view];
        return;
    }
    
    if (![PublicTools judgeStringNotEmpty:ownerButton.titleLabel.text]) {
        [self showHUDWithMessage:@"请选择所属" autoHide:YES inSuperView:self.view];
        return;
    }
    
    if (![PublicTools judgeStringNotEmpty:pwdTF.text]) {
        [self showHUDWithMessage:@"请输入密码" autoHide:YES inSuperView:self.view];
        return ;
    }
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:AF_MODIFY_URL,@"op",workNumberTF.text,@"account",pwdTF.text,@"password",nameTF.text,@"name",phoneTF.text,@"mobilephone",areaButton.titleLabel.text,@"city",ownerButton.titleLabel.text,@"depart", nil];
    
    __weak typeof(self) weakSelf = self;
    [[SettingVM alloc] modifyUserInfoWithParams:body complete:^(BOOL finish, id obj) {
        if (finish) {
            NSDebugLog(@"good");
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark --
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_INFO];
        UserModel *model = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        UITextField *pwdField = [alertView textFieldAtIndex:0];
        
        NSDebugLog(@"%@",pwdField.text);
        if ([pwdField.text isEqualToString:model.Password]) {
            [lineLbl4 setHidden:NO];
            [pwdTF setEnabled:YES];
            [verButton removeFromSuperview];
        }else{
            [PublicTools showHUDWithMessage:@"密码错误" autoHide:YES];
            pwalertView = [[UIAlertView alloc] initWithTitle:@"请输入原密码进行验证" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            pwalertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [pwalertView show];
        }
    }
}

#pragma mark textfieldDelegate
-  (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return  YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == nameTF) {
        lineLbl1.backgroundColor = mRGB(44, 185, 254);
        lineLbl2.backgroundColor = HEXCOLOR(0xe1e9ef);
        lineLbl3.backgroundColor = HEXCOLOR(0xe1e9ef);
        lineLbl4.backgroundColor = HEXCOLOR(0xe1e9ef);
    }else if (textField == phoneTF) {
        lineLbl1.backgroundColor = HEXCOLOR(0xe1e9ef);
        lineLbl2.backgroundColor = mRGB(44, 185, 254);
        lineLbl3.backgroundColor = HEXCOLOR(0xe1e9ef);
        lineLbl4.backgroundColor = HEXCOLOR(0xe1e9ef);
    }else if (textField == workNumberTF) {
        lineLbl1.backgroundColor = HEXCOLOR(0xe1e9ef);
        lineLbl2.backgroundColor = HEXCOLOR(0xe1e9ef);
        lineLbl3.backgroundColor = mRGB(44, 185, 254);
        lineLbl4.backgroundColor = HEXCOLOR(0xe1e9ef);
    }else if (textField == pwdTF) {
        lineLbl1.backgroundColor = HEXCOLOR(0xe1e9ef);
        lineLbl2.backgroundColor = HEXCOLOR(0xe1e9ef);
        lineLbl3.backgroundColor = HEXCOLOR(0xe1e9ef);
        lineLbl4.backgroundColor = mRGB(44, 185, 254);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
