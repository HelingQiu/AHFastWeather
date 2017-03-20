//
//  AFSecondViewController.m
//  
//
//  Created by Rainer on 15/12/10.
//
//

#import "AFSecondViewController.h"
#import "AFServiceTableViewCell.h"
#import "AFSubTableViewCell.h"
#import "TQMultistageTableView.h"
#import "AFForcaseVM.h"
#import "AFForcaseModel.h"
#import "AFBrowserTxtViewController.h"

@interface AFSecondViewController ()<TQTableViewDataSource,TQTableViewDelegate>
{
    TQMultistageTableView *_tableView;
    NSArray *_contents;
    NSMutableArray *_subContents;
    
    NSArray *_dqybArray;//短期预报
    NSArray *_ljyjArray;//临近预警
}
@end

@implementation AFSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"预报";
    [navigationBarLeftButton setHidden:YES];
    
    [self initilizeTableView];
    
    [self addData];
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(addData) userInfo:nil repeats:YES];
}

- (void)initilizeTableView
{
    _tableView = [[TQMultistageTableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.backgroundColor = mRGB(230, 230, 230);
    [self.view addSubview:_tableView];
}

- (void)addData
{
    _contents = @[@"全省短期预报",@"临近预警预报"];
    _subContents = [NSMutableArray array];
//    _subContents = @[@[@"1",@"2"],@[]];
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_INFO];
    UserModel *model = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    [body setObject:AF_GETPINFO_URL forKey:@"op"];
    [body setObject:model.Account forKey:@"user"];
    int random = [PublicTools getRandomNumber:0 to:1000];
    [body setObject:@(random) forKey:@"token"];
    NSString *md5Str = [PublicTools md5:[NSString stringWithFormat:@"%@+%d",model.Password,random]];
    [body setObject:md5Str forKey:@"key"];
    [body setObject:@"3431" forKey:@"pid"];
    
    [[AFForcaseVM alloc] getForcaseDataWithParams:body complete:^(BOOL finish, id obj) {
        if (finish) {
            _dqybArray = obj;
            [_subContents addObject:_dqybArray];
            
        }else{
            [_subContents addObject:@[]];
        }
        [body setObject:@"9999" forKey:@"pid"];
        [[AFForcaseVM alloc] getForcaseDataWithParams:body complete:^(BOOL finish, id obj) {
            if (finish) {
                _ljyjArray = obj;
                [_subContents addObject:_ljyjArray];
            }else{
                [_subContents addObject:@[]];
            }
            [_tableView reloadData];
        }];
    }];
}

#pragma mark - UITableViewDataSource
#pragma mark - TQTableViewDataSource

- (NSInteger)mTableView:(TQMultistageTableView *)mTableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [_subContents objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)mTableView:(TQMultistageTableView *)mTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TQMultistageTableViewCell";
    AFSubTableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[AFSubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    NSArray *array = [_subContents objectAtIndex:indexPath.section];
    AFForcaseModel *model = [array objectAtIndex:indexPath.row];
    
    [cell setBackgroundColor:mRGB(230, 230, 230)];
    cell.imageView.image = ImageNamed(@"ic_item");
    cell.textLabel.text = [NSString stringWithFormat:@"%@", model.disname];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)mTableView
{
    return 2;
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
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView setFrame:CGRectMake(10,5,30,34)];
    [imgView setImage:ImageNamed(@"ic_list3")];
    [header addSubview:imgView];
    
    UILabel *labTitle = [[UILabel alloc] init];
    [labTitle setFrame:CGRectMake(46, 0, UI_SCREEN_WIDTH - 46 - 30, 44)];
    [labTitle setFont:LabelTextSize(16)];
    [labTitle setText:_contents[section]];
    [header addSubview:labTitle];
    
    UIImageView *arrowView = [[UIImageView alloc] init];
    [arrowView setFrame:CGRectMake(UI_SCREEN_WIDTH - 30, 16, 20, 12)];
    arrowView.tag = 1;
    [arrowView setImage:ImageNamed(@"group_down")];
    [header addSubview:arrowView];
    
    return header;
}

//- (UIView *)mTableView:(TQMultistageTableView *)mTableView viewForHeaderInSection:(NSInteger)section;
//{
//    AFServiceTableViewCell *cell = [[AFServiceTableViewCell alloc] init];
//    [cell setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
//    [cell setBackgroundColor:[UIColor whiteColor]];
//    cell.textLabel.text = @"2";
//    [cell.imageView setImage:ImageNamed(@"ic_list3")];
//    
//    return cell;
//}

- (void)mTableView:(TQMultistageTableView *)mTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow ----%ld",(long)indexPath.row);
    
    NSArray *subArray = [_subContents objectAtIndex:indexPath.section];
    AFForcaseModel *pmodel = [subArray objectAtIndex:indexPath.row];
    
    NSString *requestUrl = AF_PRE_URL_3;
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_INFO];
    UserModel *model = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //判断文件是否已经下载
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/yb/%@_%ld.txt",model.Account,pmodel.disname,(long)indexPath.row]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //建文件夹
    NSString *creatDir = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/yb",model.Account]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:creatDir]) {
        [fileManager createDirectoryAtPath:creatDir withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createDirectoryAtPath:creatDir withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileDir is exists.");
    }
    
    //判断文件是否存在
    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
    {
        NSMutableDictionary *body = [NSMutableDictionary dictionary];
        [body setObject:AF_GETFILE_URL forKey:@"op"];
        [body setObject:model.Account forKey:@"user"];
        int random = [PublicTools getRandomNumber:0 to:1000];
        [body setObject:@(random) forKey:@"token"];
        NSString *md5Str = [PublicTools md5:[NSString stringWithFormat:@"%@+%d",model.Password,random]];
        [body setObject:md5Str forKey:@"key"];
        [body setObject:pmodel.aid forKey:@"aid"];
        
        __weak typeof(self) weakSelf = self;
        
        [AFHTTPRequest downLoadFile:requestUrl params:body docName:model.Account fileName:pmodel.disname filepath:filePath progress:^(BOOL finish, id obj) {
            NSLog(@"下载进度:%@%%",obj);
            
            [PublicTools showHUDWithMessage:obj autoHide:YES];
        } complete:^(BOOL finish, id obj) {
            if (finish) {
                [PublicTools showHUDWithMessage:@"下载完成" autoHide:YES];
                NSString *savedPath = filePath;
                
                AFBrowserTxtViewController *browerController = [[AFBrowserTxtViewController alloc] init];
                [browerController setDocName:savedPath];
                browerController.title = pmodel.disname;
                [weakSelf.navigationController pushViewController:browerController animated:YES];
            }else{
                [PublicTools showHUDWithMessage:obj autoHide:YES];
            }
        }];
    }else{
        AFBrowserTxtViewController *browerController = [[AFBrowserTxtViewController alloc] init];
        [browerController setDocName:filePath];
        browerController.title = pmodel.disname;
        [self.navigationController pushViewController:browerController animated:YES];
    }
}

#pragma mark - Header Open Or Close

- (void)mTableView:(TQMultistageTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section
{
    NSLog(@"Open Header ----%ld",(long)section);
}

- (void)mTableView:(TQMultistageTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section
{
    NSLog(@"Close Header ---%ld",(long)section);
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
