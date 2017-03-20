//
//  AFDefine.h
//  AHFastWeather
//
//  Created by Rainer on 15/12/10.
//  Copyright (c) 2015年 ahqxfw. All rights reserved.
//

#ifndef AHFastWeather_AFDefine_h
#define AHFastWeather_AFDefine_h


//十六进制颜色值
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//RGB颜色
#define mRGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

//----------設備系統相關---------
//iPhone4S
#define iPhone4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhone6
#define iPhone6    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334),[[UIScreen mainScreen] currentMode].size) : NO)
//iPhone6+
#define iPhone6Plus    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208),[[UIScreen mainScreen] currentMode].size) : NO)

//手机系统
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define IOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 ? YES : NO)
//ipad
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//屏幕相关数据
#define UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)
#define UI_SCREEN_HEIGHT_64             ([[UIScreen mainScreen] bounds].size.height-(IOS7?64:64))

//VIEW长宽相关数据
#define UI_VIEW_HEIGHT(x)                (x.frame.size.height)
#define UI_VIEW_WIDTH(x)                (x.frame.size.width)

///////* 发布时直接屏闭掉nslog打印的语句*/
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define NSDebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define NSDebugLog(...)
#endif

//当前版本号
#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//当前版本代码
#define XcodeAppVersionCode [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//本地存储
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

//透明色
#define ClearColor [UIColor clearColor]

//label字号
#define LabelTextSize(x) [UIFont systemFontOfSize:x]
#define BoldLabelTextSize(x) [UIFont boldSystemFontOfSize:x]

//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(image) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:image ofType:@"png"]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------


//本地数据 登录用户数据
#define AF_USER_INFO @"af_user_info"

//登录用户名
#define AF_USER_NAME @"af_user_name"

//本地设置数据
#define AF_USET_SETTING @"af_user_setting"

//本地版本号
#define AF_VERSION_NUM @"version_num"

//当前版本号
#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#endif
