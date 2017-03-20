//
//  AFFirstViewController.m
//  
//
//  Created by Rainer on 15/12/10.
//
//

#import "AFFirstViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "ActuallyVM.h"
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import "LocationModel.h"
#import "NSDateFormatter+Category.h"
#import "LocationInfoView.h"
#import "ActuallyModel.h"
#import "FirstAnnotationView.h"
#import "FirstAnnotation.h"
#import "MapPaopaoView.h"
#import "JJSButton.h"
#import "MapPopView.h"

@interface AFFirstViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    LocationModel *_model;
    NSTimer *_timer;
    LocationInfoView *_lView;
    JJSButton *toolBar;
    MapPopView *popView;
}
@end

@implementation AFFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"实况";
    [navigationBarLeftButton setHidden:YES];
    
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位服务不可用，请在设置中开启" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    _model = [[LocationModel alloc] init];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64 - 49)];
    [_mapView setDelegate:self];
    [_mapView setZoomLevel:11];
    [self.view addSubview:_mapView];
    
    [self setLocationButton];
    
    _locService = [[BMKLocationService alloc]init];
    [_locService setDelegate:self];
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self;
    
    [self startLocation];
    
    [self getServiceData];
}

- (void)setLocationButton
{
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton setFrame:CGRectMake(UI_SCREEN_WIDTH - 30 - 20, 10, 30, 30)];
    [locationButton setImage:ImageNamed(@"custom_loc") forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationButton];
    
    toolBar = [JJSButton buttonWithType:UIButtonTypeCustom];
    [toolBar setFrame:CGRectMake(0, UI_SCREEN_HEIGHT_64 -49 - 20, UI_SCREEN_WIDTH, 20)];
    [toolBar setTitleRect:CGRectMake(0, 0, UI_SCREEN_WIDTH, 20)];
    [toolBar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [toolBar.titleLabel setFont:LabelTextSize(12)];
    [toolBar setBackgroundImage:[PublicTools imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7] Size:CGRectMake(0, 0, 1, 1)] forState:UIControlStateNormal];
    [toolBar addTarget:self action:@selector(showPopView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toolBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geocodesearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
}

- (void)dealloc {
    if (_locService != nil) {
        _locService = nil;
    }
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)startLocation
{
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

- (void)showPopView:(id)sender
{
    if (popView) {
        [popView removeFromSuperview];
        popView = nil;
    }else{
        popView = [[MapPopView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT_64 - 49 - 20 - 200, UI_SCREEN_WIDTH, 200) params:nil];
        [self.view addSubview:popView];
        [self.view bringSubviewToFront:popView];
    }
}

- (void)getServiceData
{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_INFO];
    UserModel *model = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    int random = [PublicTools getRandomNumber:0 to:1000];
    
    NSString *md5Str = [PublicTools md5:[NSString stringWithFormat:@"%@+%d",model.Password,random]];
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:AF_GETOB_URL,@"op",model.Account,@"user",@(random),@"token",md5Str,@"key", nil];
    
    [[ActuallyVM alloc] getStationWithParams:body complete:^(BOOL finish, id obj) {
        if (finish) {
            NSArray *array = obj;
            [array enumerateObjectsUsingBlock:^(ActuallyModel *obj, NSUInteger idx, BOOL * stop) {
                FirstAnnotation* item = [[FirstAnnotation alloc]init];
                item.coordinate = CLLocationCoordinate2DMake(obj.Latitude.floatValue, obj.Longtitude.floatValue);
                item.title = obj.StationName;
                item.model = obj;
                [_mapView addAnnotation:item];
            }];
            ActuallyModel *model = array.firstObject;
            if (model != nil) {
                [toolBar setTitle:[@"观测时间：" stringByAppendingString:model.OBTime] forState:UIControlStateNormal];
            }
        }
        
    }];
}

#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"百度地图初始化完成" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//    [alert show];
//    alert = nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: click blank");
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: double click");
}

#pragma mark - LocationService
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
    [_locService stopUserLocationService];
    
    _model.latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    _model.longtitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    
    [self geoCodeSearch:userLocation.location.coordinate];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    [PublicTools showHUDWithMessage:@"定位失败，请在设置中查看您是否开启定位" autoHide:YES];
}

#pragma mark -- 
// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //动画annotation
    NSString *AnnotationViewID = @"AnimatedAnnotation";
    FirstAnnotationView *annotationView = nil;
    if (annotationView == nil) {
        annotationView = [[FirstAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    if ([PublicTools judgeStringNotEmpty:[[(FirstAnnotation *)annotation model] Temperature]]) {
        [annotationView.annotationImageView setImage:ImageNamed(@"zi")];
    }else{
        [annotationView.annotationImageView setImage:ImageNamed(@"icon_gcoding_little")];
    }
    ActuallyModel *model = [(FirstAnnotation *)annotation model];
    annotationView.model = model;
    
    MapPaopaoView *paopaoView = [[MapPaopaoView alloc] initWithFrame:CGRectMake(0, 0, 200, 100) model:model];
    annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paopaoView];
    
    return annotationView;
    
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
//    NSLog(@"paopaoclick:(%@)",[(FirstAnnotationView *)view model]);
}
// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
//    NSLog(@"paopaoclick:(%@)",[(FirstAnnotationView *)view model]);
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

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"result:%@",result);
    
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    _model.time = dateString;
    _model.addr = result.address;
    _model.describe = @"定位成功";
    
    _lView = [[LocationInfoView alloc] initWithFrame:CGRectMake(50, UI_SCREEN_HEIGHT_64 - 49 - 70 - 30, UI_SCREEN_WIDTH - 100, 75) location:_model];
    [self.view addSubview:_lView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeView) userInfo:nil repeats:NO];
}

- (void)removeView
{
    [_lView removeFromSuperview];
    [_timer invalidate];
    _timer = nil;
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
