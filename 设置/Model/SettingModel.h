//
//  SettingModel.h
//  AHFastWeather
//
//  Created by Rainer on 15/12/23.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject

@property(nonatomic, copy) NSString *account;
@property(nonatomic, assign) BOOL isVoice;//声音
@property(nonatomic, assign) BOOL isVibration;//振动
@property(nonatomic, copy) NSString *visibility;//能见度
@property(nonatomic, copy) NSString *temperture;//温度
@property(nonatomic, copy) NSString *rainfall;//雨量
@property(nonatomic, copy) NSString *windspeed;//风速
@property(nonatomic, copy) NSString *onetime;//勿扰

@end
