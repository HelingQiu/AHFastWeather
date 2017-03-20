//
//  AFFifthViewController.m
//  
//
//  Created by Rainer on 15/12/10.
//
//

#import "AFFifthViewController.h"
#import "AFChatVM.h"
#import "AFChatModel.h"
#import <UIImageView+AFNetworking.h>
#import "AFSixthViewController.h"

@interface AFFifthViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_resultArray;
    UITableView *_tableView;
    UITextView *_textView;
}
@end

@implementation AFFifthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"指令";
    [navigationBarLeftButton setHidden:YES];
    
    [self initilizeBaseView];
    
    [self getmessagedata];
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(getmessagedata) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO];
}

- (void)initilizeBaseView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64 - 49 - 54)];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = mRGB(230, 230, 230);
    [self.view addSubview:_tableView];
    
    UIView *toolBar = [[UIView alloc] init];
    [toolBar setFrame:CGRectMake(0, UI_SCREEN_HEIGHT_64 - 49 - 54, UI_SCREEN_WIDTH, 54)];
    [toolBar setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:toolBar];
    
    _textView = [[UITextView alloc] init];
    [_textView setFrame:CGRectMake(5, 2, UI_SCREEN_WIDTH - 10 - 60, 40)];
    _textView.font = [UIFont systemFontOfSize:16];
    [toolBar addSubview:_textView];
    
    UIView *line = [[UIView alloc] init];
    [line setFrame:CGRectMake(0, 42, UI_SCREEN_WIDTH - 65, 2)];
    [line setBackgroundColor:mRGB(44, 185, 254)];
    [toolBar addSubview:line];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(UI_SCREEN_WIDTH - 65, 2, 60, 40)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setBackgroundColor:mRGB(44, 185, 254)];
    [sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:sendButton];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 7, 22, 20)];
    [button setImage:[UIImage imageNamed:@"third_selected"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)settingAction
{
    AFSixthViewController *sixthViewController = [[AFSixthViewController alloc] init];
    [[self rdv_tabBarController] setTabBarHidden:YES];
    [self.navigationController pushViewController:sixthViewController animated:YES];
}

//获取指令数据
- (void)getmessagedata
{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_INFO];
    UserModel *model = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    [body setObject:AF_GETCHAT_URL forKey:@"op"];
    [body setObject:model.Account forKey:@"user"];
    int random = [PublicTools getRandomNumber:0 to:1000];
    [body setObject:@(random) forKey:@"token"];
    NSString *md5Str = [PublicTools md5:[NSString stringWithFormat:@"%@+%d",model.Password,random]];
    [body setObject:md5Str forKey:@"key"];
    
    [[AFChatVM alloc] getChatDataWithParams:body complete:^(BOOL finish, id obj) {
        if (finish) {
            _resultArray = [obj mutableCopy];
//            AFChatModel *model = [[AFChatModel alloc] init];
//            model.msg = @"ddjfdlskfjl";
//            model.msgtype = @"2";
//            
//            AFChatModel *model1 = [[AFChatModel alloc] init];
//            model1.msg = @"ddjfdlskfjldafdsafdasfasdfa";
//            model1.msgtype = @"1";
//            
//            AFChatModel *model2 = [[AFChatModel alloc] init];
//            model2.msg = @"ddjfdlskfjfdsafdsafafdsfdsafasdfsadfsadfafl";
//            model2.msgtype = @"1";
//            
//            AFChatModel *model3 = [[AFChatModel alloc] init];
//            model3.msg = @"ddjfdlskfjl";
//            model3.msgtype = @"2";
//            
//            AFChatModel *model4 = [[AFChatModel alloc] init];
//            model4.msg = @"ddjfdlskfjdl";
//            model4.msgtype = @"1";
//            
//            AFChatModel *model5 = [[AFChatModel alloc] init];
//            model5.msg = @"ddjfddfalskfjl";
//            model5.msgtype = @"2";
//            
//            AFChatModel *model6 = [[AFChatModel alloc] init];
//            model6.msg = @"ddjfdl大家发的撒雷锋skfjl";
//            model6.msgtype = @"2";
//            
//            AFChatModel *model7 = [[AFChatModel alloc] init];
//            model7.msg = @"ddjfdl的范德萨范德萨撒飞洒地方的萨芬撒地方撒大大说分手的skfjl";
//            model7.msgtype = @"1";
//            
//            [_resultArray addObject:model];
//            [_resultArray addObject:model1];
//            [_resultArray addObject:model2];
//            [_resultArray addObject:model3];
//            [_resultArray addObject:model4];
//            [_resultArray addObject:model5];
//            [_resultArray addObject:model6];
//            [_resultArray addObject:model7];
            
            [_tableView reloadData];
        }
    }];
}

- (void)sendMessage:(UIButton *)sender
{
    if (_textView.text.length == 0) {
        [PublicTools showHUDWithMessage:@"请输入指令消息" autoHide:YES];
        return;
    }
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_INFO];
    UserModel *model = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    [body setObject:AF_SENDMESSAGE_URL forKey:@"op"];
    [body setObject:model.Account forKey:@"from"];
    [body setObject:@"sa" forKey:@"to"];
    [body setObject:_textView.text forKey:@"msg"];
    
    [body setObject:model.Account forKey:@"user"];
    int random = [PublicTools getRandomNumber:0 to:1000];
    [body setObject:@(random) forKey:@"token"];
    NSString *md5Str = [PublicTools md5:[NSString stringWithFormat:@"%@+%d",model.Password,random]];
    [body setObject:md5Str forKey:@"key"];
    
    [[AFChatVM alloc] sendMessageWithParams:body complete:^(BOOL finish, id obj) {
        if (finish) {
            _textView.text = @"";
            
        }
    }];
}

//泡泡文本
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position{
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    // build single chat bubble cell with given text
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    
    //背影图片
//    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"chat_sender_bg":@"chat_receiver_bg" ofType:@"png"]];
    UIImage *bubble = [UIImage imageNamed:fromSelf?@"chat_sender_bg":@"chat_receiver_bg"];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) + 10 topCapHeight:floorf(bubble.size.height/2) + 5]];
    NSLog(@"%f,%f",size.width,size.height);
    
    
    //添加文本信息
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 24.0f, size.width+10, size.height+10)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text = text;
    
    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
    
    if(fromSelf)
        returnView.frame = CGRectMake(UI_SCREEN_WIDTH-position-(bubbleText.frame.size.width+30.0f), 10.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    else
        returnView.frame = CGRectMake(position, 10.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    
    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleText];
    
    return returnView;
}

//泡泡语音
- (UIView *)yuyinView:(NSInteger)logntime from:(BOOL)fromSelf withIndexRow:(NSInteger)indexRow  withPosition:(int)position{
    
    //根据语音长度
    int yuyinwidth = 66+fromSelf;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = indexRow;
    if(fromSelf)
        button.frame =CGRectMake(UI_SCREEN_WIDTH-position-yuyinwidth, 10, yuyinwidth, 54);
    else
        button.frame =CGRectMake(position, 10, yuyinwidth, 54);
    
    //image偏移量
    UIEdgeInsets imageInsert;
    imageInsert.top = -10;
    imageInsert.left = fromSelf?button.frame.size.width/3:-button.frame.size.width/3;
    button.imageEdgeInsets = imageInsert;
    
    [button setImage:[UIImage imageNamed:fromSelf?@"SenderVoiceNodePlaying":@"ReceiverVoiceNodePlaying"] forState:UIControlStateNormal];
    UIImage *backgroundImage = [UIImage imageNamed:fromSelf?@"SenderVoiceNodeDownloading":@"ReceiverVoiceNodeDownloading"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(fromSelf?-30:button.frame.size.width, 0, 30, button.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%ld''",(long)logntime];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [button addSubview:label];
    
    return button;
}

#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AFChatModel *model = [_resultArray objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [model.msg sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height + 44 + 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = mRGB(230, 230, 230);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else{
        for (UIView *cellView in cell.subviews){
            [cellView removeFromSuperview];
        }
    }
    
    AFChatModel *model = [_resultArray objectAtIndex:indexPath.row];
    
    //创建头像
    UIImageView *photo ;
    if ([model.msgtype isEqualToString:@"1"]) {
        photo = [[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-60, 26, 50, 50)];
        [cell addSubview:photo];
        photo.image = [UIImage imageNamed:@"message_photo"];
        
//        if ([[dict objectForKey:@"content"] isEqualToString:@"0"]) {
//            [cell addSubview:[self yuyinView:1 from:YES withIndexRow:indexPath.row withPosition:65]];
//            
//            
//        }else{
            [cell addSubview:[self bubbleView:model.msg from:YES withPosition:65]];
//        }
        
    }else{
        photo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 26, 50, 50)];
        [cell addSubview:photo];
        [photo setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"message_photo"]];
        
//        if ([[dict objectForKey:@"content"] isEqualToString:@"0"]) {
//            [cell addSubview:[self yuyinView:1 from:NO withIndexRow:indexPath.row withPosition:65]];
//        }else{
            [cell addSubview:[self bubbleView:model.msg from:NO withPosition:65]];
//        }
    }
    UILabel *labTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 20)];
    [labTime setTextAlignment:NSTextAlignmentCenter];
    [labTime setFont:[UIFont systemFontOfSize:12]];
    [labTime setText:model.chattime];
    [labTime setTextColor:[UIColor blackColor]];
    [cell addSubview:labTime];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
