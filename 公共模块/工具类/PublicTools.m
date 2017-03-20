//
//  PublicTools.m
//  
//
//  Created by Rainer on 15/12/11.
//
//

#import "PublicTools.h"
#import "CommonCrypto/CommonDigest.h"

@implementation PublicTools

//判断字符串是否为空
+ (BOOL) judgeStringNotEmpty:(NSString *)string
{
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ((string != nil) && [string length] != 0 && ![string isEqualToString:@"(null)"] && ![string isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}

//md5加密
+ (NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

//计算文本所占高度
//3个参数：宽度和文本内容 字号
+ (CGFloat)calculateTextHeight:(CGFloat)widthInput Content:(NSString *)strContent textFont:(CGFloat)font
{
    CGSize constraint = CGSizeMake(widthInput, 20000.0f);
    UIFont *fnt = LabelTextSize(font);
    CGFloat result = fnt.pointSize+4;
    CGRect textRect = [strContent boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fnt} context:nil];
    CGSize size = CGSizeMake(textRect.size.width, textRect.size.height+1);
    result = MAX(size.height, result); //At least one row
    return result;
}

//计算 宽度
+ (CGFloat)calculateTextWidth:(NSString *)strContent textFont:(CGFloat)font
{
    CGFloat constrainedSize = 26500.0f; //其他大小也行
    
    UIFont *fnt = LabelTextSize(font);
    //    CGSize size = [strContent sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX) lineBreakMode:LineBreakModeWordWrap];
    float widthIs = [strContent boundingRectWithSize:CGSizeMake(constrainedSize, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:fnt } context:nil].size.width;
    return widthIs;
}

//存本地数据
+ (void)saveUserDefaultObject:(id)object forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (object) {
        [defaults setObject:object
                     forKey:key];
    }
    [defaults synchronize];
}

//data判断返回图片类型名
+ (NSString *)contentTypeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c)
    {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

+ (void)showHUDWithMessage:(NSString*)message autoHide:(BOOL)needAutoHide {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.layer.zPosition = 9999;
    hud.margin = 16.f;
    hud.removeFromSuperViewOnHide = YES;
    
    if (needAutoHide)
        [hud hide:YES afterDelay:1.3];
}

+ (BOOL)isCurrentLoginStatus
{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_INFO];
    if (userData != nil) {
        //自定义对象，解编后转对象
        UserModel *model = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
        if ([PublicTools judgeStringNotEmpty:model.name] && model.logret == 0) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

//从from到to 生成一个随机数
+ (int)getRandomNumber:(int)from to:(int)to

{
    return (int)(from + (arc4random() % (to - from + 1)));
}

//颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color Size:(CGRect)size
{
    CGRect rect = size;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//压缩图片
+ (UIImage *)imageWithImageSimple:(UIImage *)image
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = UI_SCREEN_WIDTH;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  @brief  Copy sqlite file
 *
 *  @param path Copy to destination location
 *
 *  @return Copy result
 *
 *  @since 1.0.0
 */
+ (NSString *)copyDataBaseWithFileFullName:(NSString *)name CustomerDir:(NSString *)dir Override:(BOOL)ovrid
{
    
    BOOL success;
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath;
    if (dir && [self judgeStringNotEmpty:dir]) {
        
        NSString *subDir = [NSString stringWithFormat:@"%@/%@", documentsDirectory, dir];
        BOOL isDir = NO;
        BOOL existed = [fm fileExistsAtPath:subDir isDirectory:&isDir];
        if (!(isDir == YES && existed == YES)) {
            [fm createDirectoryAtPath:subDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        writableDBPath = [[documentsDirectory stringByAppendingPathComponent:dir] stringByAppendingPathComponent:name];
        
    } else
        writableDBPath = [documentsDirectory stringByAppendingPathComponent:name];
    
    //    NSLog(@"writableDBPath:%@",writableDBPath);
    
    success = [fm fileExistsAtPath:writableDBPath];
    
    if (ovrid && success) {
        
        NSError *error;
        if ([fm removeItemAtPath:writableDBPath error:&error])
            NSLog(@"Ovrride database file success");
        
    }
    
    if (ovrid || !success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name];
        success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSLog(@"copy database file error:%@",[error localizedDescription]);
            success = NO;
        }
        
    }
    
    if (success) {
        
        return writableDBPath;
        
    }
    
    return nil;
}

@end
