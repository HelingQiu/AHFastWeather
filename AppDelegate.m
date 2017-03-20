//
//  AppDelegate.m
//  AHFastWeather
//
//  Created by Rainer on 15/10/21.
//  Copyright (c) 2015年 ahqxfw. All rights reserved.
//

#import "AppDelegate.h"
#import "AFFirstViewController.h"
#import "AFSecondViewController.h"
#import "AFThirdViewController.h"
#import "AFForthViewController.h"
#import "AFFifthViewController.h"
#import "AFSixthViewController.h"
#import "AFLoginViewController.h"

#import <RDVTabBarController.h>
#import <RDVTabBarItem.h>

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "SettingVM.h"
#import <UIAlertView+BlocksKit.h>
#import "APService.h"

//百度key
#define BAI_DU_KEY @"R2tRkKbDG7ZbI97eirH3hmFq"

@interface AppDelegate ()<BMKGeneralDelegate>
{
    BMKMapManager *_mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL b = [_mapManager start:BAI_DU_KEY generalDelegate:self];
    if (!b) {
        NSLog(@"连接失败");
    }
    
    [self isNewVersionUpdate];
    
    //初始化数据库
    [self initDataBase];
    
    if ([PublicTools isCurrentLoginStatus]) {
        [self setViewControllers];
    }else{
        [self pushToLoginView];
    }
    
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];
    
    
    return YES;
}

- (void)pushToLoginView
{
    AFLoginViewController *firstViewController = [[AFLoginViewController alloc] init];
    UINavigationController *firstNavController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    self.window.rootViewController = firstNavController;
}

- (void)setViewControllers
{
    AFFirstViewController *firstViewController = [[AFFirstViewController alloc] init];
    UINavigationController *firstNavController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    
    AFSecondViewController *secondViewController = [[AFSecondViewController alloc] init];
    UINavigationController *secondNavController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    
    AFThirdViewController *thirdViewController = [[AFThirdViewController alloc] init];
    UINavigationController *thirdNavController = [[UINavigationController alloc] initWithRootViewController:thirdViewController];
    
    AFForthViewController *forthViewController = [[AFForthViewController alloc] init];
    UINavigationController *forthNavController = [[UINavigationController alloc] initWithRootViewController:forthViewController];
    
    AFFifthViewController *fifthViewController = [[AFFifthViewController alloc] init];
    UINavigationController *fifthNavController = [[UINavigationController alloc] initWithRootViewController:fifthViewController];
    
//    AFSixthViewController *sixthViewController = [[AFSixthViewController alloc] init];
//    UINavigationController *sixthNavController = [[UINavigationController alloc] initWithRootViewController:sixthViewController];
    
    RDVTabBarController *tabbarController = [[RDVTabBarController alloc] init];
    [tabbarController setViewControllers:@[firstNavController,secondNavController,thirdNavController,forthNavController,fifthNavController]];
    self.window.rootViewController = tabbarController;
    
    [self customizeTabBarForController:tabbarController];
    [tabbarController setSelectedIndex:2];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController
{
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    
    NSArray *tabBarItemImages = @[@"ic_ob",@"ic_forecast", @"ic_service",@"ic_profile", @"ic_order"];
    NSArray *tabBarItemTitle = @[@"实况",@"预报", @"服务",@"拍照", @"指令"];
    UIColor *unselectColor = mRGB(146, 148, 147);
    UIColor *selectColor = mRGB(56, 176, 249);
    
    int index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        //设置tab item的title
        
        [item setTitle:[tabBarItemTitle objectAtIndex:index]];
        
        [item setUnselectedTitleAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           unselectColor, NSForegroundColorAttributeName,
                                           [UIFont systemFontOfSize:12],
                                           NSFontAttributeName,
                                            nil]];
        [item setSelectedTitleAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         selectColor, NSForegroundColorAttributeName,
                                         [UIFont systemFontOfSize:12],
                                         NSFontAttributeName,
                                          nil]];
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:finishedImage];
        
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}

#pragma mark - 打开本地数据库操作
/**
 *  Description: Initialize database
 *
 *  @return result
 */
- (void)initDataBase
{
    NSString *fileFullName = @"AHFastWeather.sqlite";
    NSString *subDir = nil;
    
    // 拷贝本地数据库
    NSString *DBPath = [PublicTools copyDataBaseWithFileFullName:fileFullName CustomerDir:subDir Override:NO];
    
    NSLog(@"DBPath:%@",DBPath);
    
    // Copy successfully and sync data from server
    if (DBPath) {
        _queue = [FMDatabaseQueue databaseQueueWithPath:DBPath];
        
    }
}

/**
 *  Description: Close database
 */
- (void)closeDatabase
{
    [_queue close];
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
            }
        }
    }];
}

#pragma mark - apns
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
