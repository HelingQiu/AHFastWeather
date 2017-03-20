//
//  HTTPRequest.h
//  JJSMOA
//
//  Created by 张基誉 on 15/6/22.
//  Copyright (c) 2015年 JJSHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

//请求超时
#define LoginOutTime @"11"

/** 每页默认条数 */
#define SERVER_DEFAULT_COUNT  @"10"

/** 网络错误提示 */
#define NETWORK_ERROR_MSG  @"网络出错,请检查网络"

@interface AFHTTPRequest : NSObject

#pragma 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl;

#pragma GET请求
+ (void) netRequestGETWithRequestURL: (NSString *) requestURLString
                            cacheUrl: (NSString *) cacheURLString
                       withParameter: (NSDictionary *) parameter
                withReturnValeuBlock: (ReturnValueBlock) finishBlock
                    withFailureBlock: (FailureBlock) failureBlock;

#pragma POST请求
+ (void) netRequestPOSTWithRequestURL: (NSString *) requestURLString
                             cacheUrl: (NSString *) cacheURLString
                        withParameter: (NSDictionary *) parameter
                 withReturnValeuBlock: (ReturnValueBlock) finishBlock
                     withFailureBlock: (FailureBlock) failureBlock;


#pragma 图片上传
+ (void) netRequestUploadFileWithRequestURL: (NSString *) requestURLString
                                   withFile: (NSData *)fileData
                                   photoKey: (NSString *)photoKey
                                   fileName: (NSString *)fileName
                              withParameter: (NSDictionary *) parameter
                       withReturnValeuBlock: (ReturnValueBlock) finishBlock
                          withProgressBlock: (UploadProgressBlock) progressBlock
                           withFailureBlock: (FailureBlock) failureBlock;

//移除请求
+ (void) netWorkCancelRequest:(NSString *) cacheURLString;

//下载文件
+ (void)downLoadFile:(NSString *)requsetUrl params:(NSDictionary *)params docName:(NSString *)docName fileName:(NSString *)fileName filepath:(NSString *)filepath progress:(CompletionWithObjectBlock)progressBlock complete:(CompletionWithObjectBlock)completion;

@end
