//
//  PublicTools.h
//  
//
//  Created by Rainer on 15/12/11.
//
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
#import "UserModel.h"

@interface PublicTools : NSObject

//md5加密
+(NSString *)md5:(NSString *) inPutText;
//计算文本所占高度
//3个参数：宽度和文本内容 字号
+(CGFloat)calculateTextHeight:(CGFloat)widthInput Content:(NSString *)strContent textFont:(CGFloat)font;

//计算 宽度
+(CGFloat)calculateTextWidth:(NSString *)strContent textFont:(CGFloat)font;

//判断字符串是否为空
+ (BOOL) judgeStringNotEmpty:(NSString *)string;

//存本地数据
+ (void)saveUserDefaultObject:(id)object forKey:(NSString *)key;

//判断图片格式
+ (NSString *)contentTypeForImageData:(NSData *)data;

//HUD
+ (void)showHUDWithMessage:(NSString*)message autoHide:(BOOL)needAutoHide;

//判断当前是否登录
+ (BOOL)isCurrentLoginStatus;

//从from到to 生成一个随机数
+ (int)getRandomNumber:(int)from to:(int)to;

//颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color Size:(CGRect)size;

//压缩图片
+ (UIImage *)imageWithImageSimple:(UIImage *)image;

//拷贝数据库
+ (NSString *)copyDataBaseWithFileFullName:(NSString *)name CustomerDir:(NSString *)dir Override:(BOOL)ovrid;

@end
