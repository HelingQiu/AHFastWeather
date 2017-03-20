//
//  SettingVM.h
//  
//
//  Created by Rainer on 15/12/12.
//
//

#import <Foundation/Foundation.h>
#import "RegisterModel.h"

@interface SettingVM : NSObject

//界面数据
- (void)initilizeSettingView:(CompletionWithObjectBlock)completion;

//提醒设置
- (void)initilizeRemindView:(CompletionWithObjectBlock)completion;

//修改用户信息
- (void)modifyUserInfoWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion;

//获取路段信息
- (void)getRoadInfoWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion;

//修改用户关注路段
- (void)modifyAttentionRoadWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion;

//检查更新
- (void)updateVersionWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion;


@end
