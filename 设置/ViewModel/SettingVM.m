//
//  SettingVM.m
//  
//
//  Created by Rainer on 15/12/12.
//
//

#import "SettingVM.h"
#import "ServiceModel.h"
#import "SettingModel.h"
#import "RoadModel.h"
#import "AFRoadDao.h"

@implementation SettingVM

- (void)initilizeSettingView:(CompletionWithObjectBlock)completion
{
    NSArray *resultArray = @[@[@{@"title":@"账号信息",@"image":@"ic_setting_account"}],@[@{@"title":@"提醒设置",@"image":@"ic_setting_notification"},@{@"title":@"路段设置",@"image":@"ic_setting_privacy"}],@[@{@"title":@"关于",@"image":@"ic_setting_about"}],@[@{@"title":@"退出",@"image":@""}]];
    completion(YES,resultArray);
}

//提醒设置
- (void)initilizeRemindView:(CompletionWithObjectBlock)completion
{
    SettingModel *model = (SettingModel *)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:AF_USET_SETTING]];
    if (![model.account isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_NAME]]) {
        BOOL isVoice = YES;
        BOOL isVibration = YES;
        NSString *visibility = @"200  米";
        NSString *temperture = @" 30  °C";
        NSString *rainfall =   @" 20 毫米";
        NSString *windspeed =  @" 5 米/秒";
        NSString *onetime =    @"1,2,3,4,5,6,7,8,9,10";
        NSArray *resultArray = @[@{@"title":@"声音提醒",@"value":[NSNumber numberWithBool:isVoice]},@{@"title":@"振动提醒",@"value":[NSNumber numberWithBool:isVibration]},@{@"title":@"能见度提醒阀值",@"value":visibility},@{@"title":@"温度提醒阀值",@"value":temperture},@{@"title":@"雨量提醒阀值",@"value":rainfall},@{@"title":@"风速提醒阀值",@"value":windspeed},@{@"title":@"勿扰时段",@"value":onetime}];
        
        completion(YES,resultArray);
    }else{
        BOOL isVoice = model.isVoice;
        BOOL isVibration = model.isVibration;
        NSString *visibility = [NSString stringWithFormat:@"%@  米",model.visibility];
        NSString *temperture = [NSString stringWithFormat:@" %@  °C",model.temperture];
        NSString *rainfall = [NSString stringWithFormat:@" %@ 毫米",model.rainfall];
        NSString *windspeed = [NSString stringWithFormat:@" %@ 米/秒",model.windspeed];
        NSString *onetime = [NSString stringWithFormat:@"%@",model.onetime];
        NSArray *resultArray = @[@{@"title":@"声音提醒",@"value":[NSNumber numberWithBool:isVoice]},@{@"title":@"振动提醒",@"value":[NSNumber numberWithBool:isVibration]},@{@"title":@"能见度提醒阀值",@"value":visibility},@{@"title":@"温度提醒阀值",@"value":temperture},@{@"title":@"雨量提醒阀值",@"value":rainfall},@{@"title":@"风速提醒阀值",@"value":windspeed},@{@"title":@"勿扰时段",@"value":onetime}];
        
        completion(YES,resultArray);
    }
}

- (void)modifyUserInfoWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion
{
    NSString *requestUrl = AF_PRE_URL_1;
    NSString *cacheUrl = [AF_PRE_URL_1 stringByAppendingString:AF_MODIFY_URL];
    [AFHTTPRequest netRequestGETWithRequestURL:requestUrl cacheUrl:cacheUrl withParameter:params withReturnValeuBlock:^(id returnValue) {
        
        NSDebugLog(@"%@",returnValue);
        
        RegisterModel *model = [RegisterModel mj_objectWithKeyValues:returnValue];
        [PublicTools showHUDWithMessage:model.Info autoHide:YES];
        
        if (model.Ret == 0) {
            NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_INFO];
            UserModel *model = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
            
            model.name = [params objectForKey:@"name"];
            model.city = [params objectForKey:@"city"];
            model.depart = [params objectForKey:@"depart"];
            model.MobilePhone = [params objectForKey:@"mobilephone"];
            model.Password = [params objectForKey:@"password"];
            
            NSData *encodeData = [NSKeyedArchiver archivedDataWithRootObject:model];
            [PublicTools saveUserDefaultObject:encodeData forKey:AF_USER_INFO];
            [PublicTools saveUserDefaultObject:model.Account forKey:AF_USER_NAME];
            
            completion(YES,@"");
        }else{
            completion(NO,@"");
        }
        
    } withFailureBlock:^(id failValue) {
        [PublicTools showHUDWithMessage:[(NSError *)failValue description] autoHide:YES];
        completion(NO,@"");
    }];
}

- (void)getRoadInfoWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion
{
    NSString *requestUrl = AF_PRE_URL_2;
    NSString *cacheUrl = [AF_PRE_URL_2 stringByAppendingString:AF_GETDEPART_URL];
    [AFHTTPRequest netRequestGETWithRequestURL:requestUrl cacheUrl:cacheUrl withParameter:params withReturnValeuBlock:^(id returnValue) {
        
//        NSDebugLog(@"road:%@",returnValue);
        NSError *error = nil;
        id jsonBody = [NSJSONSerialization JSONObjectWithData:[returnValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        __block NSMutableArray *resultArray = [NSMutableArray array];
        if ([jsonBody isKindOfClass:[NSArray class]]) {
            
            NSArray *array = jsonBody;
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                RoadModel *model = [RoadModel mj_objectWithKeyValues:obj];
                
                [resultArray addObject:model];
                
            }];
            
            AFRoadDao *dao = [[AFRoadDao alloc] init];
            [dao addproduct:resultArray completion:^(BOOL finish, id obj) {
                
            }];
            completion(YES,resultArray);
        }else{
            completion(NO,@"");
        }
        
    } withFailureBlock:^(id failValue) {
        [PublicTools showHUDWithMessage:[(NSError *)failValue description] autoHide:YES];
        completion(NO,@"");
    }];
}

- (void)modifyAttentionRoadWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion
{
    NSString *requestUrl = AF_PRE_URL_2;
    NSString *cacheUrl = [AF_PRE_URL_2 stringByAppendingString:AF_UPDATEDEPART_URL];
    [AFHTTPRequest netRequestGETWithRequestURL:requestUrl cacheUrl:cacheUrl withParameter:params withReturnValeuBlock:^(id returnValue) {
        
        NSDebugLog(@"road:%@",returnValue);
        if ([returnValue integerValue] == 1) {
            [PublicTools showHUDWithMessage:@"提交成功" autoHide:YES];
            completion(YES,returnValue);
        }else{
            [PublicTools showHUDWithMessage:@"提交失败" autoHide:YES];
            completion(NO,returnValue);
        }
        
    } withFailureBlock:^(id failValue) {
        [PublicTools showHUDWithMessage:[(NSError *)failValue description] autoHide:YES];
        completion(NO,@"");
    }];
}

- (void)updateVersionWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion
{
    NSString *requestUrl = AF_PRE_URL_2;
    NSString *cacheUrl = [AF_PRE_URL_2 stringByAppendingString:AF_UPDATEVERSION_URL];
    [AFHTTPRequest netRequestGETWithRequestURL:requestUrl cacheUrl:cacheUrl withParameter:params withReturnValeuBlock:^(id returnValue) {
        
        NSDebugLog(@"road:%@",returnValue);
        NSError *error;
        id jsonBody = [NSJSONSerialization JSONObjectWithData:[returnValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        
        completion(YES,[jsonBody objectForKey:@"version"]);
        
    } withFailureBlock:^(id failValue) {
        [PublicTools showHUDWithMessage:[(NSError *)failValue description] autoHide:YES];
        completion(NO,@"");
    }];
}

@end
