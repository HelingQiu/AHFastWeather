//
//  AFSixthViewController.m
//  
//
//  Created by Rainer on 15/12/10.
//
//

#import "AFSixthViewController.h"
#import "SettingVM.h"
#import "SettingTableViewCell.h"
#import "JJSLoginOutAlertView.h"
#import "AFAcountInfoViewController.h"
#import "AFRemindViewController.h"
#import "SettingModel.h"
#import "AFAboutViewController.h"
#import "AFRoadViewController.h"
#import <UIAlertView+BlocksKit.h>

@interface AFSixthViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *settingTableView;
    NSArray *sourceArray;
}
@end

@implementation AFSixthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    
    [self getData];
    [self initilizeBaseView];
    
    NSData *setData = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USET_SETTING];
    
    if (setData == nil) {
        SettingModel *model = [[SettingModel alloc] init];
        model.account = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_NAME];
        model.isVoice = YES;
        model.isVibration = YES;
        model.visibility = @"200";
        model.temperture = @"30";
        model.rainfall = @"20";
        model.windspeed = @"5";
        model.onetime = @"无";
        NSData *encodeData = [NSKeyedArchiver archivedDataWithRootObject:model];
        [PublicTools saveUserDefaultObject:encodeData forKey:AF_USET_SETTING];
    }
}

- (void)getData
{
    [[SettingVM alloc] initilizeSettingView:^(BOOL finish, id obj) {
        if (finish) {
            sourceArray = obj;
        }
    }];
}

- (void)initilizeBaseView
{
    CGRect frame = (CGRect){
        .origin.x = 10,
        .origin.y = 0,
        .size.width =  UI_SCREEN_WIDTH - 20,
        .size.height = UI_SCREEN_HEIGHT
    };
    settingTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    
    [settingTableView setDelegate:self];
    [settingTableView setDataSource:self];
    [settingTableView setBackgroundColor:mRGB(230, 230, 230)];
    [settingTableView setTableFooterView:[UIView new]];
    [self.view addSubview:settingTableView];
}

#pragma mark --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sourceArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *subArray = [sourceArray objectAtIndex:section];
    return [subArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    [headView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH - 20, 10)];
    [headView setBackgroundColor:mRGB(230, 230, 230)];
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    NSArray *subArray = [sourceArray objectAtIndex:indexPath.section];
    NSDictionary *body = [subArray objectAtIndex:indexPath.row];
    
    if (indexPath.section == 3) {
        [cell.labLogout setText:[body objectForKey:@"title"]];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.imgView setImage:ImageNamed([body objectForKey:@"image"])];
        [cell.labTitle setText:[body objectForKey:@"title"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            AFAcountInfoViewController *accountViewController = [[AFAcountInfoViewController alloc] init];
            [self.navigationController pushViewController:accountViewController animated:YES];
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    AFRemindViewController *remindViewController = [[AFRemindViewController alloc] init];
                    [self.navigationController pushViewController:remindViewController animated:YES];
                }
                    break;
                case 1:
                {
                    AFRoadViewController *roadViewController = [[AFRoadViewController alloc] init];
                    [self.navigationController pushViewController:roadViewController animated:YES];
                }
                    break;
                case 2:
                {
                    [self isNewVersionUpdate];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        case 2:
        {
            AFAboutViewController *aboutViewController = [[AFAboutViewController alloc] init];
            [self.navigationController pushViewController:aboutViewController animated:YES];
        }
            break;
        case 3:
        {
            __weak typeof(self) weakSelf = self;
            __weak UITableView *wTableView = settingTableView;
            
            JJSLoginOutAlertView *sfcAlert = [[JJSLoginOutAlertView alloc] initWithTitle:@"是否退出当前登录?"];
            [sfcAlert animateShow:YES completionBlock:^(){
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:AF_USER_INFO];
                
                __strong typeof(weakSelf) strongSelf = weakSelf;
                __weak typeof(strongSelf) wweakSelf = strongSelf;
                __strong UITableView *sTableView = wTableView;
                __weak UITableView *wwTableView = sTableView;
                AFLoginViewController *loginViewController = [[AFLoginViewController alloc] init];
                loginViewController.isReLogin = YES;
                loginViewController.block = ^(){
                    [wwTableView reloadData];
                    [wweakSelf.rdv_tabBarController setSelectedIndex:2];
                };
                [[strongSelf rdv_tabBarController] setTabBarHidden:YES animated:YES];
                [strongSelf.navigationController pushViewControllerWithNavigationControllerTransition:loginViewController];
                
            }];
        }
            break;
        default:
            break;
    }
}

- (void)isNewVersionUpdate
{
    NSDictionary *body = @{@"op":AF_UPDATEVERSION_URL};
    [[SettingVM alloc] updateVersionWithParams:body complete:^(BOOL finish, id obj) {
        if (finish) {
            NSInteger version_num = [[[NSUserDefaults standardUserDefaults] objectForKey:AF_VERSION_NUM] integerValue];
            if ([obj integerValue] < version_num) {
                [UIAlertView bk_showAlertViewWithTitle:@"更新提示" message:@"发现新版本，是否更新？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"www.baidu.com"]];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:[obj integerValue]] forKey:AF_VERSION_NUM];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }];
            }else{
                [PublicTools showHUDWithMessage:@"没有发现新版本" autoHide:YES];
            }
        }
    }];
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
