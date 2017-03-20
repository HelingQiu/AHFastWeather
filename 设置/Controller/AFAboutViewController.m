//
//  AFAboutViewController.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/24.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFAboutViewController.h"

@interface AFAboutViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AFAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"关于";
    [self initilizeBaseView];
}

- (void)initilizeBaseView
{
    UIImageView *logoView = [[UIImageView alloc] init];
    [logoView setFrame:CGRectMake(UI_SCREEN_WIDTH/2 - 18, 20, 36, 36)];
    [logoView setImage:ImageNamed(@"push")];
    [self.view addSubview:logoView];
    
    UILabel *labTitle = [[UILabel alloc] init];
    [labTitle setFrame:CGRectMake(0, CGRectGetMaxY(logoView.frame) + 10, UI_SCREEN_WIDTH, 20)];
    [labTitle setTextAlignment:NSTextAlignmentCenter];
    [labTitle setText:[NSString stringWithFormat:@"高速气象 V%@",XcodeAppVersion]];
    [self.view addSubview:labTitle];
    
    CGRect frame = (CGRect){
        .origin.x = 10,
        .origin.y = CGRectGetMaxY(labTitle.frame) + 20,
        .size.width =  UI_SCREEN_WIDTH - 20,
        .size.height = 44 * 3
    };
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:mRGB(230, 230, 230)];
    [tableView setTableFooterView:[UIView new]];
    [self.view addSubview:tableView];
    
    UILabel *labssub = [[UILabel alloc] init];
    [labssub setFrame:CGRectMake(0, UI_SCREEN_HEIGHT_64 - 20, UI_SCREEN_WIDTH, 10)];
    [labssub setText:@"高速交警专用气象服务客户端版权所有省交警总队高速支队"];
    [labssub setTextAlignment:NSTextAlignmentCenter];
    [labssub setFont:LabelTextSize(10)];
    [self.view addSubview:labssub];
    
    UILabel *labsub = [[UILabel alloc] init];
    [labsub setFrame:CGRectMake(0, UI_SCREEN_HEIGHT_64 - 10, UI_SCREEN_WIDTH, 10)];
    [labsub setText:@"Copyright @ 2015-2020 All Rights Reserved"];
    [labsub setTextAlignment:NSTextAlignmentCenter];
    [labsub setFont:LabelTextSize(10)];
    [self.view addSubview:labsub];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"业务支持：0551-62801586"];
    }else if (indexPath.row == 1) {
        [cell.textLabel setText:@"技术支持：0551-62290437"];
    }else{
        [cell.textLabel setText:@"帮助"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0551-62801586"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }else if (indexPath.row == 1) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0551-62290437"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }else{
    
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
