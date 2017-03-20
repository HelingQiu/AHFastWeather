//
//  AFForthViewController.m
//  
//
//  Created by Rainer on 15/12/10.
//
//

#import "AFForthViewController.h"
#import <UIActionSheet+BlocksKit.h>
#import <UIAlertView+BlocksKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AFUploadPhotoViewController.h"
#import "AFShowViewController.h"
#import "AFPhotoDao.h"
#import "AFPhotoModel.h"

#define PZ_TAG 46789
#define XC_TAG 46790

#define PSP_TAG 46791
#define QSP_TAG 46792

@interface AFForthViewController ()<UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *localPhotoArray;
    UICollectionView *_collectionView;
}
@end

@implementation AFForthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"拍照";
    localPhotoArray = [NSMutableArray array];
    
    [navigationBarLeftButton setHidden:YES];
    [navigationBarRightButton setHidden:NO];
    [navigationBarRightButton setImage:ImageNamed(@"camare_selected") forState:UIControlStateNormal];
    [navigationBarRightButton setImage:ImageNamed(@"camare_selected1") forState:UIControlStateHighlighted];
    
//    [self createImagePath];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64 - 49) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createImagePath];
}

- (void)createImagePath
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/%@/photo", pathDocuments,[[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_NAME]];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"文件夹已存在");
        [localPhotoArray removeAllObjects];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSEnumerator *childFilesEnumerator = [[fileManager subpathsAtPath:createPath] objectEnumerator];
        NSString* fileName;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [createPath stringByAppendingPathComponent:fileName];
            NSDebugLog(@"filename:%@",fileAbsolutePath);
            [localPhotoArray addObject:fileAbsolutePath];
        }
        [_collectionView reloadData];
    }
}

- (void)showRightSideBar
{
    __weak typeof(self) weakSelf = self;
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [actionSheet bk_addButtonWithTitle:@"拍照片" handler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([weakSelf photoPermissions]) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [PublicTools showHUDWithMessage:@"无法打开相机" autoHide:YES];
                return ;
            }
            
            UIImagePickerController *__iPicker = [[UIImagePickerController alloc] init];
            __iPicker.view.tag = PZ_TAG;
            __iPicker.delegate = strongSelf;
            __iPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //只显示拍照的视图
            NSArray *mt = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
            __iPicker.mediaTypes = mt;
            __iPicker.videoQuality = UIImagePickerControllerQualityTypeLow;
            __iPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            __iPicker.cameraFlashMode = UIImagePickerControllerCameraDeviceRear;
            [strongSelf presentViewController:__iPicker animated:YES completion:nil];
        }
        
    }];
    [actionSheet bk_addButtonWithTitle:@"拍视频" handler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([weakSelf photoPermissions]) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [PublicTools showHUDWithMessage:@"无法打开相机" autoHide:YES];
                return ;
            }
            
            UIImagePickerController *__iPicker = [[UIImagePickerController alloc] init];
            __iPicker.view.tag = PSP_TAG;
            __iPicker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置image picker的来源，这里设置为摄像头
            __iPicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头
            
            __iPicker.mediaTypes = @[(NSString *)kUTTypeMovie];
            __iPicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
            __iPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
            __iPicker.delegate = strongSelf;//设置代理，检测操作
            [strongSelf presentViewController:__iPicker animated:YES completion:nil];
        }
        
    }];
    
    [actionSheet bk_addButtonWithTitle:@"选照片" handler:^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [PublicTools showHUDWithMessage:@"无法打开相册" autoHide:YES];
            return ;
        }
        
        UIImagePickerController *__iPicker = [[UIImagePickerController alloc] init];
        __iPicker.view.tag = XC_TAG;
        __iPicker.delegate = strongSelf;
        __iPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSArray *mt = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        __iPicker.mediaTypes = mt;
        [strongSelf presentViewController:__iPicker animated:YES completion:nil];
     
    }];
    [actionSheet bk_addButtonWithTitle:@"选视频" handler:^{ NSLog(@"Zop!");
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [PublicTools showHUDWithMessage:@"无法打开相册" autoHide:YES];
            return ;
        }
        
        UIImagePickerController *__iPicker = [[UIImagePickerController alloc] init];
        __iPicker.view.tag = QSP_TAG;
        __iPicker.delegate = strongSelf;
        __iPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSArray *mt = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        __iPicker.mediaTypes = mt;
        [strongSelf presentViewController:__iPicker animated:YES completion:nil];
    
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:^{ NSLog(@"Never mind, then!");
    }];
    [actionSheet showInView:self.view];
}

#pragma mark UIImagePickerControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSDebugLog(@"====%ld",(long)picker.view.tag);
//    int pickerTag = (int)picker.view.tag;
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __weak typeof(self) weakSelf = self;
    
    @autoreleasepool {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:@"public.image"]){
            
            __block UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            if(image != nil){
                AFUploadPhotoViewController *uploadViewController = [[AFUploadPhotoViewController alloc] init];
                [uploadViewController setImage:image];
                [weakSelf.navigationController pushViewController:uploadViewController animated:YES];
                image = nil;
            }
        }else if([mediaType isEqualToString:@"public.movie"]){
            NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
            NSLog(@"%@", videoURL);
            NSLog(@"found a video");
            
            if(videoURL != nil){
                AFUploadPhotoViewController *uploadViewController = [[AFUploadPhotoViewController alloc] init];
                [uploadViewController setVideoUrl:videoURL];
                [weakSelf.navigationController pushViewController:uploadViewController animated:YES];
            }
            
            /****************************************/
            
//            NSString *videoFile = [documentsDirectory stringByAppendingPathComponent:@"temp.mov"];
//            NSLog(@"%@", videoFile);
//            
//            success = [fileManager fileExistsAtPath:videoFile];
//            if(success) {
//                success = [fileManager removeItemAtPath:videoFile error:&error];
//            }
//            [videoData writeToFile:videoFile atomically:YES];
            
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    picker.delegate=nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//获取拍照权限
- (BOOL)photoPermissions
{
    __block BOOL permissionOk = NO;
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus ==AVAuthorizationStatusRestricted){
        NSLog(@"Restricted");
    }else if(authStatus == AVAuthorizationStatusDenied){
        //应该是这个，如果不允许的话
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:@"请在设备的 设置->隐私->相机 中允许访问相机."];
        [alertView bk_setCancelButtonWithTitle:@"确定" handler:^{
        }];
        [alertView show];
        permissionOk = NO;
    }
    else if(authStatus == AVAuthorizationStatusAuthorized){//允许访问
        permissionOk =  YES;
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){//点击允许访问时调用
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                NSLog(@"Granted access to %@", mediaType);
                permissionOk =  YES;
            }
            else {
                NSLog(@"Not granted access to %@", mediaType);
                permissionOk = NO;
            }
            
        }];
    }else {
        NSLog(@"Unknown authorization status");
    }
    
    return permissionOk;
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return localPhotoArray.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CGFloat width = (UI_SCREEN_WIDTH - 8)/3;
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/%@/photo/", pathDocuments,[[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_NAME]];
    
    NSString *path = [localPhotoArray objectAtIndex:localPhotoArray.count - 1 - indexPath.row];
    
    if ([path hasSuffix:@".mp4"]) {
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView setFrame:CGRectMake(0, 0, width, width)];
        [imgView setImage:[self getImageWith:path]];
        [cell.contentView addSubview:imgView];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(0, 0, 50, 50)];
        [imageView setCenter:CGPointMake(width/2.0, width/2.0)];
        [imageView setImage:ImageNamed(@"ic_video_play")];
        [imageView setUserInteractionEnabled:YES];
        [imgView addSubview:imageView];
        
        UILabel *labAddr = [[UILabel alloc] init];
        [labAddr setFrame:CGRectMake(0, width - 40, width, 40)];
        [labAddr setFont:LabelTextSize(12)];
        [labAddr setTextColor:[UIColor whiteColor]];
        [labAddr setNumberOfLines:0];
        [imgView addSubview:labAddr];
        
        NSString *filename = [path stringByReplacingOccurrencesOfString:@".mp4" withString:@""];
        filename = [filename stringByReplacingOccurrencesOfString:createPath withString:@""];
        AFPhotoDao *dao = [[AFPhotoDao alloc] init];
        [dao getPhotoByFileName:filename completion:^(BOOL finish, id obj) {
            if (finish) {
                AFPhotoModel *model = obj;
                [labAddr setText:model.address];
            }
        }];
    }else{
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView setFrame:CGRectMake(0, 0, width, width)];
        [imgView setImage:[UIImage imageWithContentsOfFile:path]];
        [cell.contentView addSubview:imgView];
        
        UILabel *labAddr = [[UILabel alloc] init];
        [labAddr setFrame:CGRectMake(0, width - 40, width, 40)];
        [labAddr setFont:LabelTextSize(12)];
        [labAddr setTextColor:[UIColor whiteColor]];
        [labAddr setNumberOfLines:0];
        [imgView addSubview:labAddr];
        
        NSString *filename = [path stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
        filename = [filename stringByReplacingOccurrencesOfString:createPath withString:@""];
        AFPhotoDao *dao = [[AFPhotoDao alloc] init];
        [dao getPhotoByFileName:filename completion:^(BOOL finish, id obj) {
            if (finish) {
                AFPhotoModel *model = obj;
                [labAddr setText:model.address];
            }
        }];
        
    }
    
//    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (UI_SCREEN_WIDTH - 8)/3;
    return CGSizeMake(width, width);
}

//纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/%@/photo/", pathDocuments,[[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_NAME]];
    
    NSString *path = [localPhotoArray objectAtIndex:localPhotoArray.count - 1 - indexPath.row];
    if ([path hasSuffix:@".mp4"]) {
        NSString *filename = [path stringByReplacingOccurrencesOfString:@".mp4" withString:@""];
        filename = [filename stringByReplacingOccurrencesOfString:createPath withString:@""];
        __block AFPhotoModel *model = nil;
        AFPhotoDao *dao = [[AFPhotoDao alloc] init];
        [dao getPhotoByFileName:filename completion:^(BOOL finish, id obj) {
            if (finish) {
                model = obj;
            }
        }];
        
        NSURL *videoUrl = [NSURL fileURLWithPath:path];
        AFShowViewController *showViewController = [[AFShowViewController alloc] init];
        [showViewController setVideoUrl:videoUrl];
        [showViewController setModel:model];
        [self.navigationController pushViewController:showViewController animated:YES];
    }else{
        NSString *filename = [path stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
        filename = [filename stringByReplacingOccurrencesOfString:createPath withString:@""];
        __block AFPhotoModel *model = nil;
        AFPhotoDao *dao = [[AFPhotoDao alloc] init];
        [dao getPhotoByFileName:filename completion:^(BOOL finish, id obj) {
            if (finish) {
                model = obj;
            }
        }];
        
        AFShowViewController *showViewController = [[AFShowViewController alloc] init];
        [showViewController setImage:[UIImage imageWithContentsOfFile:path]];
        [showViewController setModel:model];
        [self.navigationController pushViewController:showViewController animated:YES];
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)getImageWith:(NSString *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:path] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return thumb;
    
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
