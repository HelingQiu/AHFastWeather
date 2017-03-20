//
//  AFUploadPhotoViewController.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/18.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFUploadPhotoViewController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import "NSDateFormatter+Category.h"
#import "JJSPlaceholderTextView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AFPlayVideoViewController.h"
#import "AFPhotoModel.h"
#import "AFPhotoDao.h"

@interface AFUploadPhotoViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    
    CLLocationCoordinate2D coordinate;
    UILabel *labAddress;
    UILabel *labTime;
    UILabel *labLatLng;
    JJSPlaceholderTextView *textView;
}
@end

@implementation AFUploadPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位服务不可用，请在设置中开启" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    _locService = [[BMKLocationService alloc]init];
    [_locService setDelegate:self];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self;
    
    [_locService startUserLocationService];
    
    [self addNavBar];
    [self initlizeBaseView];
}

- (void)initlizeBaseView
{
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64/3.0 * 2)];
    [imgView setImage:self.image];
    [imgView setUserInteractionEnabled:YES];
    [self.view addSubview:imgView];
    
    if (self.videoUrl != nil) {
        [imgView setImage:[self getImage]];
        
        [navigationBarRightButton setTitle:@"上传视频" forState:UIControlStateNormal];
        [textView setPlaceholder:@"请输入视频描述..."];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(0, 0, 60, 60)];
        [imageView setCenter:CGPointMake(UI_SCREEN_WIDTH/2, UI_SCREEN_HEIGHT_64/3.0)];
        [imageView setImage:ImageNamed(@"ic_video_play")];
        [imageView setUserInteractionEnabled:YES];
        [imgView addSubview:imageView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
        [imgView addGestureRecognizer:tapRecognizer];
        [imageView addGestureRecognizer:tapRecognizer];
    }
    
    UIView *middleView = [[UIView alloc] init];
    [middleView setFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64/3.0/2)];
    [middleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:middleView];
    
    labAddress = [[UILabel alloc] init];
    [labAddress setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64/3.0/2/2)];
    [labAddress setFont:BoldLabelTextSize(16)];
    [labAddress setTextAlignment:NSTextAlignmentCenter];
    [labAddress setTextColor:mRGB(132, 127, 127)];
    [middleView addSubview:labAddress];
    
    labTime = [[UILabel alloc] init];
    [labTime setFrame:CGRectMake(0, CGRectGetMaxY(labAddress.frame), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64/3.0/2/2/2)];
    [labTime setFont:LabelTextSize(12)];
    [labTime setTextAlignment:NSTextAlignmentCenter];
    [labTime setTextColor:mRGB(210, 207, 207)];
    [middleView addSubview:labTime];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    [labTime setText:dateString];
    
    labLatLng = [[UILabel alloc] init];
    [labLatLng setFrame:CGRectMake(0, CGRectGetMaxY(labTime.frame), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64/3.0/2/2/2)];
    [labLatLng setFont:LabelTextSize(12)];
    [labLatLng setTextAlignment:NSTextAlignmentCenter];
    [labLatLng setTextColor:mRGB(210, 207, 207)];
    [middleView addSubview:labLatLng];

    
    textView = [[JJSPlaceholderTextView alloc] init];
    [textView setFrame:CGRectMake(0, CGRectGetMaxY(middleView.frame), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64/3.0/2)];
    [textView setPlaceholder:@"请输入照片描述..."];
    [textView setPlaceholderColor:mRGB(129, 129, 129)];
    [textView setBackgroundColor:mRGB(243, 243, 243)];
    [self.view addSubview:textView];
}

- (void)addNavBar
{
    [navigationBarRightButton setHidden:NO];
    [navigationBarRightButton setFrame:CGRectMake(0, 5, 88, 34)];
    [navigationBarRightButton setBackgroundColor:mRGB(1, 180, 246)];
    [navigationBarRightButton setClipsToBounds:YES];
    [navigationBarRightButton.layer setCornerRadius:4];
    [navigationBarRightButton.titleLabel setFont:LabelTextSize(16)];
    [navigationBarRightButton setTitle:@"上传照片" forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geocodesearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     // 不用时，置nil
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_locService stopUserLocationService];
    
    coordinate = userLocation.location.coordinate;
    
    [labLatLng setText:[NSString stringWithFormat:@"经度：%f  纬度：%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude]];
    
    [self geoCodeSearch:userLocation.location.coordinate];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    coordinate = CLLocationCoordinate2DMake(0, 0);
}

#pragma mark --
- (void)geoCodeSearch:(CLLocationCoordinate2D)pt
{
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSDebugLog(@"result:%@-",result.address);
    [labAddress setText:result.address];
}

//上传图片
- (void)showRightSideBar
{
    if (self.videoUrl != nil) {
        [self showHUDWithWaitingMessage:@"上传中..." inSuperView:self.view];
        [self videoChangeToMP4];
        
    }else{
        UIImage *__image = [PublicTools imageWithImageSimple:self.image];
        //压缩
        __block NSData *imageData = UIImageJPEGRepresentation(__image, 1);
        __image = nil;
        
        if (labAddress.text == nil) {
            labAddress.text = @"";
        }
        
        NSDictionary *body = @{@"picdesc":textView.text,@"upopr":[[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_NAME],@"lon":[NSString stringWithFormat:@"%f",coordinate.longitude],@"lat":[NSString stringWithFormat:@"%f",coordinate.latitude],@"filename":@"image.jpg",@"addr":labAddress.text};
        
        [self showHUDWithWaitingMessage:@"上传中..." inSuperView:self.view];
        
        [AFHTTPRequest netRequestUploadFileWithRequestURL:AF_PRE_URL_4 withFile:imageData photoKey:@"fileList" fileName:@"image.jpg" withParameter:body withReturnValeuBlock:^(id returnValue) {
            NSDebugLog(@"%@",returnValue);
            [self hideHUD:self.view];
            if ([returnValue isKindOfClass:[NSString class]]) {
                if ([returnValue isEqualToString:@"ok"]) {
                    [PublicTools showHUDWithMessage:@"上传成功" autoHide:YES];
                    
                    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    NSString *createPath = [NSString stringWithFormat:@"%@/%@/photo", pathDocuments,[[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_NAME]];
                    
                    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
                    
                    [createPath stringByAppendingString:dateString];
                    NSString *jpgImage = [createPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",dateString]];
                    [imageData writeToFile:jpgImage atomically:YES];
                    
                    AFPhotoModel *model = [[AFPhotoModel alloc] init];
                    model.filename = dateString;
                    model.lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
                    model.lng = [NSString stringWithFormat:@"%f",coordinate.longitude];
                    model.address = labAddress.text;
                    model.time = dateString;
                    AFPhotoDao *dao = [[AFPhotoDao alloc] init];
                    [dao addPhoto:model completion:^(BOOL finish, id obj) {
                        if (finish) {
                            
                        }
                    }];
                }
            }
        } withProgressBlock:^(float progressValue) {
            NSDebugLog(@"%f",progressValue);
            [self showHUDWithWaitingMessage:[NSString stringWithFormat:@"%d%%",(int)(progressValue * 100)] inSuperView:self.view];
        } withFailureBlock:^(id failValue) {
            NSDebugLog(@"%@",failValue);
        }];
    }
}

- (UIImage *)getImage
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoUrl options:nil];
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

- (void)playVideo:(id)sender
{
    AFPlayVideoViewController *playViewController = [[AFPlayVideoViewController alloc] init];
    [playViewController setVideoUrl:self.videoUrl];
    [self presentViewController:playViewController animated:YES completion:nil];
}

- (void)videoChangeToMP4
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:self.videoUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
        
    {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetPassthrough];
        
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *createPath = [NSString stringWithFormat:@"%@/%@/photo", pathDocuments,[[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_NAME]];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        NSString *exportPath = [NSString stringWithFormat:@"%@/%@.mp4",createPath,dateString];
        exportSession.outputURL = [NSURL fileURLWithPath:exportPath];
        NSLog(@"%@", exportPath);
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                    [self hideHUD:self.view];
                }
                    break;
                case AVAssetExportSessionStatusCancelled:
                {
                    NSLog(@"Export canceled");
                    [self hideHUD:self.view];
                }
                    break;
                case AVAssetExportSessionStatusCompleted:
                    
                {
                    NSLog(@"转换成功");
                    NSData *videoData = [NSData dataWithContentsOfFile:exportPath];
                    
                    NSDictionary *body = @{@"picdesc":textView.text,@"upopr":[[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_NAME],@"lon":[NSString stringWithFormat:@"%f",coordinate.longitude],@"lat":[NSString stringWithFormat:@"%f",coordinate.latitude],@"filename":@"video.MP4",@"addr":labAddress.text};
                    [AFHTTPRequest netRequestUploadFileWithRequestURL:AF_PRE_URL_4 withFile:videoData photoKey:@"video" fileName:@"video.MP4" withParameter:body withReturnValeuBlock:^(id returnValue) {
                        NSDebugLog(@"%@",returnValue);
                        [self hideHUD:self.view];
                        if ([returnValue isKindOfClass:[NSString class]]) {
                            if ([returnValue isEqualToString:@"ok"]) {
                                [PublicTools showHUDWithMessage:@"上传成功" autoHide:YES];
                                
                                AFPhotoModel *model = [[AFPhotoModel alloc] init];
                                model.filename = dateString;
                                model.lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
                                model.lng = [NSString stringWithFormat:@"%f",coordinate.longitude];
                                model.address = labAddress.text;
                                model.time = dateString;
                                AFPhotoDao *dao = [[AFPhotoDao alloc] init];
                                [dao addPhoto:model completion:^(BOOL finish, id obj) {
                                    if (finish) {
                                        
                                    }
                                }];
                                
                            }else{
                                if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]) {
                                    [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
                                }
                            }
                        }
                    } withProgressBlock:^(float progressValue) {
                        NSDebugLog(@"%f",progressValue);
                        [self showHUDWithWaitingMessage:[NSString stringWithFormat:@"%d%%",(int)(progressValue * 100)] inSuperView:self.view];
                    } withFailureBlock:^(id failValue) {
                        [self hideHUD:self.view];
                        NSDebugLog(@"%@",failValue);
                        if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]) {
                            [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
                        }
                    }];
                    
                }
                    break;
                default:
                    break;
            }
        }];
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
