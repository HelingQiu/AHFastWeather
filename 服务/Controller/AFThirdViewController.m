//
//  AFThirdViewController.m
//  
//
//  Created by Rainer on 15/12/10.
//
//

#import "AFThirdViewController.h"
#import "AFSubTableViewCell.h"
#import "ServiceVM.h"
#import "TQMultistageTableView.h"
#import "AFBrowerViewController.h"
#import "AFServiceDao.h"

@interface AFThirdViewController ()<TQTableViewDataSource,TQTableViewDelegate>
{
    TQMultistageTableView *_tableView;
    NSArray *_contents;
    NSMutableArray *_subContents;
    AFServiceDao *_serviceDao;
}
@end

@implementation AFThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"服务";
    [navigationBarLeftButton setHidden:YES];
    
    _serviceDao = [[AFServiceDao alloc] init];
    _contents = @[];
    _subContents = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self initilizeTableView];
    [self getDBData];
    [self addData];
}
- (void)initilizeTableView
{
    _tableView = [[TQMultistageTableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64 - 49)];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.backgroundColor = mRGB(230, 230, 230);
    [self.view addSubview:_tableView];
}

- (void)getDBData
{
    [_serviceDao getAllServiceCompletion:^(BOOL finish, id obj, id obj2) {
        if (finish) {
            _contents = obj;
            _subContents = obj2;
            [_tableView reloadData];
        }
    }];
}

- (void)addData
{
//    _contents = @[@"高速公路气象服务日报",@"高速公路气象服务旬报",@"高速公路气象服务月报",@"预评估报告",@"交通气象服务专报"];
    
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_INFO];
    UserModel *model = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    [body setObject:AF_GETPRODUCT_URL forKey:@"op"];
    [body setObject:model.Account forKey:@"user"];
    int random = [PublicTools getRandomNumber:0 to:1000];
    [body setObject:@(random) forKey:@"token"];
    NSString *md5Str = [PublicTools md5:[NSString stringWithFormat:@"%@+%d",model.Password,random]];
    [body setObject:md5Str forKey:@"key"];
    
    // 加入队列
    __block NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    [[ServiceVM alloc] getServiceProductListWithParams:body complete:^(BOOL finish, id obj) {
        if (finish) {
            _contents = obj;
            [_tableView reloadData];
            
            [_contents enumerateObjectsUsingBlock:^(ServiceModel *object, NSUInteger index, BOOL * stop) {
                
                NSMutableDictionary *body = [NSMutableDictionary dictionary];
                [body setObject:AF_GETPINFO_URL forKey:@"op"];
                [body setObject:model.Account forKey:@"user"];
                int random = [PublicTools getRandomNumber:0 to:1000];
                [body setObject:@(random) forKey:@"token"];
                NSString *md5Str = [PublicTools md5:[NSString stringWithFormat:@"%@+%d",model.Password,random]];
                [body setObject:md5Str forKey:@"key"];
                [body setObject:object.pid forKey:@"pid"];
                
                NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:AF_PRE_URL_3 parameters:body error:nil];
                
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                
                // 请求数据，设置成功与失败的回调函数
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSError *error;
                    id jsonBody = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
                    
                    NSMutableArray *resultArray1 = [NSMutableArray array];
                    if ([jsonBody isKindOfClass:[NSArray class]]) {
                        NSArray *array = jsonBody;
                        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            ProductModel *model = [ProductModel mj_objectWithKeyValues:obj];
                            
                            [resultArray1 addObject:model];
                            
                        }];
                    }
                    
                    [_serviceDao addService:object product:resultArray1 completion:^(BOOL finish, id obj) {
                        if (finish) {
                            NSDebugLog(@"add successfully");
                        }
                    }];
                    
                    [_subContents addObject:resultArray1];
                    [_tableView reloadData];
                    
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"发生错误！%@",error);
                }];
                
                [queue addOperation:operation];
                
            }];
        }
    }];
    
}

#pragma mark - UITableViewDataSource
#pragma mark - TQTableViewDataSource

- (NSInteger)mTableView:(TQMultistageTableView *)mTableView numberOfRowsInSection:(NSInteger)section
{
    if (_subContents.count > section) {
        NSArray *subArray = [_subContents objectAtIndex:section];
        return [subArray count];
    }
    
    return 0;
}

- (UITableViewCell *)mTableView:(TQMultistageTableView *)mTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TQMultistageTableViewCell";
    AFSubTableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[AFSubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    NSArray *subArray = [_subContents objectAtIndex:indexPath.section];
    ProductModel *model = [subArray objectAtIndex:indexPath.row];
    
    [cell setBackgroundColor:mRGB(230, 230, 230)];
    cell.imageView.image = ImageNamed(@"ic_item");
    cell.textLabel.text = [NSString stringWithFormat:@"%@", model.disname];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)mTableView
{
    return [_contents count];
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
    ServiceModel *model = [_contents objectAtIndex:section];
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView setFrame:CGRectMake(10,5,40,34)];
    [imgView setImage:ImageNamed(@"ic_doc")];
    [header addSubview:imgView];
    
    UILabel *labTitle = [[UILabel alloc] init];
    [labTitle setFrame:CGRectMake(56, 0, UI_SCREEN_WIDTH - 56 - 30 - 20, 44)];
    [labTitle setFont:LabelTextSize(16)];
    [labTitle setText:model.pname];
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
    ServiceModel *smodel = [_contents objectAtIndex:indexPath.section];
    
    NSArray *subArray = [_subContents objectAtIndex:indexPath.section];
    ProductModel *pmodel = [subArray objectAtIndex:indexPath.row];
    
    NSString *requestUrl = AF_PRE_URL_3;
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_INFO];
    UserModel *model = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //判断文件是否已经下载
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/fw/%@_%ld.pdf",model.Account,pmodel.disname,(long)indexPath.row]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //建文件夹
    NSString *creatDir = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/fw",model.Account]];
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
                
                AFBrowerViewController *browerController = [[AFBrowerViewController alloc] init];
                [browerController setDocName:savedPath];
                browerController.title = pmodel.disname;
                [weakSelf.navigationController pushViewController:browerController animated:YES];
            }else{
                [PublicTools showHUDWithMessage:obj autoHide:YES];
            }
        }];
    }else{
        AFBrowerViewController *browerController = [[AFBrowerViewController alloc] init];
        [browerController setDocName:filePath];
        browerController.title = pmodel.disname;
        [self.navigationController pushViewController:browerController animated:YES];
    }
}

#pragma mark - Header Open Or Close

- (void)mTableView:(TQMultistageTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section
{
    UIView *headView = [mTableView headForSection:section];
    [headView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]] && obj.tag == 1) {
            UIImageView *imgView = obj;
            [imgView setImage:ImageNamed(@"group_up")];
        }
    }];
}

- (void)mTableView:(TQMultistageTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section
{
    UIView *headView = [mTableView headForSection:section];
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
