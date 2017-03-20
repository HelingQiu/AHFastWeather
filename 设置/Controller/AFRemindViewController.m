//
//  AFRemindViewController.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/22.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFRemindViewController.h"
#import "SettingVM.h"
#import "LeftRightTableViewCell.h"
#import "SettingModel.h"
#import "AFOneTimeViewController.h"

#define TAG_SWITCH 23898
#define TAG_ALERT 4987
@interface AFRemindViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *remindTableView;
    NSArray *remindArray;
    SettingModel *model;
}
@end

@implementation AFRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"提醒设置";
    [self initilizeBaseView];
    model = (SettingModel *)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:AF_USET_SETTING]];
}

- (void)initilizeBaseView
{
    CGRect frame = (CGRect){
        .origin.x = 0,
        .origin.y = 0,
        .size.width =  UI_SCREEN_WIDTH,
        .size.height = UI_SCREEN_HEIGHT_64
    };
    remindTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [remindTableView setDelegate:self];
    [remindTableView setDataSource:self];
    [remindTableView setBackgroundColor:mRGB(230, 230, 230)];
    [remindTableView setTableFooterView:[UIView new]];
    [self.view addSubview:remindTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addDataSource];
    [remindTableView reloadData];
}

- (void)addDataSource
{
    SettingVM *settingVm = [[SettingVM alloc] init];
    [settingVm initilizeRemindView:^(BOOL finish, id obj) {
        if (finish) {
            remindArray = obj;
        }
    }];
}

#pragma mark - UITableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return remindArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"iCell";
    LeftRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[LeftRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    NSDictionary *body = [remindArray objectAtIndex:indexPath.row];
    [cell.leftLab setText:[body objectForKey:@"title"]];
    if (indexPath.row != 0 && indexPath.row != 1) {
        [cell.rightLab setText:[body objectForKey:@"value"]];
    }
    if (indexPath.row == 0 || indexPath.row == 1) {
        [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UISwitch class]]) {
                [obj removeFromSuperview];
            }
        }];
        UISwitch *iSwitch = [[UISwitch alloc] init];
        [iSwitch setFrame:CGRectMake(UI_SCREEN_WIDTH - 20 - 50, 5, 60, 34)];
        [iSwitch setTag:TAG_SWITCH + indexPath.row];
        [iSwitch setOn:[[body objectForKey:@"value"] boolValue]];
        [iSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:iSwitch];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 2:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设置能见度提醒阀值" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = TAG_ALERT + indexPath.row;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
        }
            break;
        case 3:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设置温度提醒阀值" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = TAG_ALERT + indexPath.row;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
        }
            break;
        case 4:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设置雨量提醒阀值" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = TAG_ALERT + indexPath.row;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
        }
            break;
        case 5:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设置风速提醒阀值" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = TAG_ALERT + indexPath.row;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
        }
            break;
        case 6:
        {
            AFOneTimeViewController *timeViewController = [[AFOneTimeViewController alloc] init];
            [self.navigationController pushViewController:timeViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)switchAction:(UISwitch *)iswitch
{
    NSInteger tag = iswitch.tag;
    if (tag == TAG_SWITCH) {
        model.isVoice = iswitch.on;
    }else{
        model.isVibration = iswitch.on;
    }
    NSData *encodeData = [NSKeyedArchiver archivedDataWithRootObject:model];
    [PublicTools saveUserDefaultObject:encodeData forKey:AF_USET_SETTING];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        NSInteger tag = alertView.tag;
        UITextField *field = [alertView textFieldAtIndex:0];
        switch (tag) {
            case TAG_ALERT + 2:
            {
                model.visibility = field.text;
            }
                break;
            case TAG_ALERT + 3:
            {
                model.temperture = field.text;
            }
                break;
            case TAG_ALERT + 4:
            {
                model.rainfall = field.text;
            }
                break;
            case TAG_ALERT + 5:
            {
                model.windspeed = field.text;
            }
                break;
            default:
                break;
        }
        NSData *encodeData = [NSKeyedArchiver archivedDataWithRootObject:model];
        [PublicTools saveUserDefaultObject:encodeData forKey:AF_USET_SETTING];
        [self addDataSource];
        [remindTableView reloadData];
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
