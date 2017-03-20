//
//  AFOneTimeViewController.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/23.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFOneTimeViewController.h"
#import "AFTimeTableViewCell.h"
#import "SettingModel.h"

@interface AFOneTimeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *onetimeView;
    NSArray *timeArray;
    NSMutableArray *stateArray;
    SettingModel *model;
}
@end

@implementation AFOneTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"免扰时段设置";
    [self addData];
    [self initilizeBaseView];
}

- (void)addData
{
    timeArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24"];
    stateArray = [NSMutableArray array];
    
    model = (SettingModel *)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:AF_USET_SETTING]];
    
    [timeArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        if (![model.onetime isEqualToString:@"无"]) {
            NSArray *oldState = [model.onetime componentsSeparatedByString:@","];
            __block BOOL state = NO;
            [oldState enumerateObjectsUsingBlock:^(id object, NSUInteger indx, BOOL * stop) {
                if ([object isEqualToString:obj]) {
                    state = YES;
                }
            }];
            [stateArray addObject:@(state)];
        }else{
            [stateArray addObject:@(NO)];
        }
    }];
}

- (void)initilizeBaseView
{
    CGRect frame = (CGRect){
        .origin.x = 0,
        .origin.y = 0,
        .size.width =  UI_SCREEN_WIDTH,
        .size.height = UI_SCREEN_HEIGHT_64
    };
    onetimeView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [onetimeView setDelegate:self];
    [onetimeView setDataSource:self];
    [onetimeView setBackgroundColor:mRGB(230, 230, 230)];
    [onetimeView setTableFooterView:[UIView new]];
    [self.view addSubview:onetimeView];
    [onetimeView registerNib:[UINib nibWithNibName:@"AFTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeCell"];
    
    [navigationBarRightButton setHidden:NO];
    [navigationBarRightButton setFrame:CGRectMake(0, 5, 88/2, 34)];
    [navigationBarRightButton setBackgroundColor:mRGB(1, 180, 246)];
    [navigationBarRightButton setClipsToBounds:YES];
    [navigationBarRightButton.layer setCornerRadius:4];
    [navigationBarRightButton.titleLabel setFont:LabelTextSize(16)];
    [navigationBarRightButton setTitle:@"提交" forState:UIControlStateNormal];
}

#pragma mark - DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return timeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"timeCell";
    AFTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil){
        
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"AFTimeTableViewCell" owner:nil options:nil] objectAtIndex:0];
        
    }
    [cell.selectItem setSelected:[[stateArray objectAtIndex:indexPath.row] boolValue]];
    [cell.labContent setText:[[timeArray objectAtIndex:indexPath.row] stringByAppendingString:@" 时"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AFTimeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    BOOL state = !cell.selectItem.selected;
    
    [stateArray replaceObjectAtIndex:indexPath.row withObject:@(state)];
    
    cell.selectItem.selected = state;
}

- (void)showRightSideBar
{
    NSMutableString *onetime = [[NSMutableString alloc] initWithString:@""];
    [stateArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        BOOL state = [obj boolValue];
        if (state) {
            [onetime appendString:[NSString stringWithFormat:@"%lu,",(unsigned long)idx]];
        }
    }];
    
    if ([onetime isEqualToString:@""]) {
        model.onetime = @"无";
        
    }else{
        model.onetime = onetime;
    }
    NSData *encodeData = [NSKeyedArchiver archivedDataWithRootObject:model];
    [PublicTools saveUserDefaultObject:encodeData forKey:AF_USET_SETTING];
    [PublicTools showHUDWithMessage:@"提交成功" autoHide:YES];
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
