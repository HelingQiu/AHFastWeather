//
//  AFRoadViewController.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/24.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFRoadViewController.h"
#import "SettingVM.h"
#import "RoadModel.h"
#import "TQMultistageTableView.h"
#import "AFSubTableViewCell.h"
#import "AFTimeTableViewCell.h"
#import "RoadTableViewCell.h"
#import "AFRoadDao.h"

@interface AFRoadViewController ()<TQTableViewDataSource,TQTableViewDelegate>
{
    NSMutableArray *dataSource;
    NSMutableArray *stateArray;
    NSMutableArray *resultArray;
    TQMultistageTableView *_tableView;
}
@end

@implementation AFRoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"路段设置";
    
    dataSource = [NSMutableArray array];
    stateArray = [NSMutableArray array];
    
    [self addNavBar];
    [self getRoadDataFromDB];
    [self getNetRoadData];
    [self initilizeTableView];
}

- (void)addNavBar
{
    [navigationBarRightButton setHidden:NO];
    [navigationBarRightButton setFrame:CGRectMake(0, 5, 88/2, 34)];
    [navigationBarRightButton setBackgroundColor:mRGB(1, 180, 246)];
    [navigationBarRightButton setClipsToBounds:YES];
    [navigationBarRightButton.layer setCornerRadius:4];
    [navigationBarRightButton.titleLabel setFont:LabelTextSize(16)];
    [navigationBarRightButton setTitle:@"提交" forState:UIControlStateNormal];
}

- (void)getRoadDataFromDB
{
    __weak typeof(self) weakSelf = self;
    AFRoadDao *dao = [[AFRoadDao alloc] init];
    [dao getAllServiceCompletion:^(BOOL finish, id obj) {
        if (finish) {
            NSArray *array = obj;
            [weakSelf sortDataSource:array];
        }
    }];
}
- (void)getNetRoadData
{
    NSDictionary *body = @{@"op":AF_GETDEPART_URL};
    SettingVM *setVm = [[SettingVM alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [setVm getRoadInfoWithParams:body complete:^(BOOL finish, id obj) {
        if (finish) {
            NSArray *array = obj;
            [weakSelf sortDataSource:array];
        }
    }];
}

- (void)sortDataSource:(NSArray *)resultArray
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:resultArray];
    [dataSource removeAllObjects];
    [stateArray removeAllObjects];
    
    for (int i = 0; i < array.count; i ++) {
        RoadModel *model = array[i];
        NSString *string = model.city;  //2014 04 01
        
        NSMutableArray *tempArray = [@[] mutableCopy];
        NSMutableArray *stateTempArray = [@[] mutableCopy];
        
        [tempArray addObject:model];
        [stateTempArray addObject:@(NO)];
        
        for (int j = i+1; j < array.count; j ++) {
            RoadModel *jmodel = array[j];
            NSString *jstring = jmodel.city;
            
//            NSLog(@"jstring:%@",jstring);
            
            if([string isEqualToString:jstring]){
                
//                NSLog(@"jvalue = kvalue");
                
                [tempArray addObject:jmodel];
                [stateTempArray addObject:@(NO)];
            }
        }
        
        if ([tempArray count] > 1) {
            
            [dataSource addObject:tempArray];
            [stateArray addObject:stateTempArray];
            
            [array removeObjectsInArray:tempArray];
            
            i -= 1;    //去除重复数据 新数组开始遍历位置不变
            
        }   
    }
    [_tableView reloadData];
}

- (void)initilizeTableView
{
    _tableView = [[TQMultistageTableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64)];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.backgroundColor = mRGB(230, 230, 230);
    [self.view addSubview:_tableView];
}

#pragma - prite
- (void)getAllEmbuddy
{
    resultArray = [[NSMutableArray alloc] initWithCapacity:0];
    [dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        NSArray *result = obj;
        NSArray *selectState = [stateArray objectAtIndex:idx];
        [result enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL * stop) {
            if ([[selectState objectAtIndex:index] boolValue]) {
                RoadModel *model = object;
                [resultArray addObject:model];
            }
        }];
    }];
    NSDebugLog(@"self.resultArray:%@",resultArray);
}

- (void)showRightSideBar
{
    if (resultArray.count == 0) {
        [PublicTools showHUDWithMessage:@"请添加至少一个讨论组成员" autoHide:YES];
        return;
    }
    
    NSMutableString *departs = [[NSMutableString alloc] initWithCapacity:0];
    [resultArray enumerateObjectsUsingBlock:^(RoadModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [departs appendString:[NSString stringWithFormat:@"%@,",obj.aid]];
    }];
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_INFO];
    UserModel *model = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    NSDictionary *body = @{@"op":AF_UPDATEDEPART_URL,@"account":model.Account,@"departs":departs};
    [[SettingVM alloc] modifyAttentionRoadWithParams:body complete:^(BOOL finish, id obj) {
        
    }];
}

#pragma mark - TQTableViewDataSource

- (NSInteger)mTableView:(TQMultistageTableView *)mTableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *subArray = [dataSource objectAtIndex:section];
    return [subArray count];
}

- (UITableViewCell *)mTableView:(TQMultistageTableView *)mTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TQMultistageTableViewCell";
    RoadTableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[RoadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    NSArray *subArray = [dataSource objectAtIndex:indexPath.section];
    NSArray *stateArr = [stateArray objectAtIndex:indexPath.section];
    
    RoadModel *model = [subArray objectAtIndex:indexPath.row];
    
    [cell setBackgroundColor:mRGB(245, 245, 245)];
    cell.selectItem.selected = [[stateArr objectAtIndex:indexPath.row] boolValue];
    cell.labContent.text = [NSString stringWithFormat:@"%@", model.depart];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)mTableView
{
    return [dataSource count];
}

#pragma mark - Table view delegate

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForAtomAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (UIView *)mTableView:(TQMultistageTableView *)mTableView viewForHeaderInSection:(NSInteger)section;
{
    RoadModel *model = [[dataSource objectAtIndex:section] objectAtIndex:0];
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView setFrame:CGRectMake(10,11,37.5,22)];
    [imgView setImage:ImageNamed(@"ic_list2")];
    [header addSubview:imgView];
    
    UILabel *labTitle = [[UILabel alloc] init];
    [labTitle setFrame:CGRectMake(56, 0, UI_SCREEN_WIDTH - 56 - 30 - 20, 44)];
    [labTitle setFont:LabelTextSize(16)];
    [labTitle setText:model.city];
    [header addSubview:labTitle];
    
    UIImageView *arrowView = [[UIImageView alloc] init];
    [arrowView setFrame:CGRectMake(UI_SCREEN_WIDTH - 30, 16, 20, 12)];
    arrowView.tag = 1;
    [arrowView setImage:ImageNamed(@"group_down")];
    [header addSubview:arrowView];
    
    return header;
}

- (void)mTableView:(TQMultistageTableView *)mTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow ----%ld",(long)indexPath.row);
    NSArray *subArray = [dataSource objectAtIndex:indexPath.section];
    
    RoadModel *pmodel = [subArray objectAtIndex:indexPath.row];
    
    RoadTableViewCell *cell = (RoadTableViewCell *)[mTableView.tableView cellForRowAtIndexPath:indexPath];
    
    BOOL state = !cell.selectItem.selected;
    
    [[stateArray objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:@(state)];
    
    cell.selectItem.selected = state;
    
    [self getAllEmbuddy];
}

#pragma mark - Header Open Or Close

- (void)mTableView:(TQMultistageTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section
{
    UIView *headView = [mTableView.tableView headerViewForSection:section];
    [headView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]] && obj.tag == 1) {
            UIImageView *imgView = obj;
            [imgView setImage:ImageNamed(@"group_up")];
        }
    }];
}

- (void)mTableView:(TQMultistageTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section
{
    UIView *headView = [mTableView.tableView headerViewForSection:section];
    [headView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]] && obj.tag == 1) {
            UIImageView *imgView = obj;
            [imgView setImage:ImageNamed(@"group_down")];
        }
    }];
}

#pragma mark - Row Open Or Close

- (void)mTableView:(TQMultistageTableView *)mTableView willOpenRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Open Row ----%ld",(long)indexPath.row);
    
}

- (void)mTableView:(TQMultistageTableView *)mTableView willCloseRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Close Row ----%ld",(long)indexPath.row);
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
