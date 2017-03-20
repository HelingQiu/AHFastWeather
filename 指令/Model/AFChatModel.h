//
//  AFChatModel.h
//  AHFastWeather
//
//  Created by Rainer on 16/8/6.
//  Copyright © 2016年 ahqxfw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFChatModel : NSObject

@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *msgtype;//1send 2receive
@property (nonatomic, copy) NSString *chattime;
@property (nonatomic, copy) NSString *fromname;
@property (nonatomic, copy) NSString *toname;
@property (nonatomic, copy) NSString *imgurl;

@end
