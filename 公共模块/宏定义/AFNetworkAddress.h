//
//  AFNetworkAddress.h
//  AHFastWeather
//
//  Created by Rainer on 15/12/10.
//  Copyright (c) 2015年 ahqxfw. All rights reserved.
//

#ifndef AHFastWeather_AFNetworkAddress_h
#define AHFastWeather_AFNetworkAddress_h

//Completion Block(with object)
typedef void (^CompletionWithObjectBlock) (BOOL finish, id obj);
typedef void (^CompletionWithDoubleBlock) (BOOL finish, id obj, id obj2);
typedef void (^CompletionBlock)(BOOL finish);

//定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^FailureBlock)(id failValue);
typedef void (^UploadProgressBlock) (float progressValue);


//登录代码
typedef enum : NSInteger {

    LoginSuccessCode = 0,
    LoginErrorPassWord = 1,
    LoginErrorNotUser = 2,
    LoginErrorUserStop = 3,
    LoginErrorUserExamine = 4,
    LoginErrorSystemAnomaly = -1
    
}loginErrorCode;


#define AF_PRE_URL_1 @"http://weixin.ahqxfw.com/appservice/login.ashx"

#define AF_PRE_URL_2 @"http://weixin.ahqxfw.com/appservice/getPara.ashx"

#define AF_PRE_URL_3 @"http://weixin.ahqxfw.com/appservice/getData.ashx"

//上传文件
#define AF_PRE_URL_4 @"http://weixin.ahqxfw.com/appservice/upload.ashx"

//发送指令
#define AF_PRE_URL_5 @"http://218.22.11.37/appservice/sendmsg.ashx"

//注册
#define AF_REGISTER_URL @"newuser"

//登录
#define AF_LOGIN_URL @"login"

//修改用户信息
#define AF_MODIFY_URL @"modifyuser"

//获取路段(单位)信息
#define AF_GETDEPART_URL @"getdepart"

//修改关注路段（单位）信息
#define AF_UPDATEDEPART_URL @"updatedepart"

//获取实况数据
#define AF_GETOB_URL @"getob"

//获取服务材料产品类别
#define AF_GETPRODUCT_URL @"getproduct"

//获取服务材料产品列表
#define AF_GETPINFO_URL @"getpinfo"

//获取服务材料产品文件
#define AF_GETFILE_URL @"getfile"

//检查更新
#define AF_UPDATEVERSION_URL @"getversion"

//从服务器轮询
#define AF_GETCHAT_URL @"getchat"

//发送指令
#define AF_SENDMESSAGE_URL @"sendmsg"

#endif
