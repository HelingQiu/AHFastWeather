//
//  HTTPRequest.m
//  JJSMOA
//
//  Created by 张基誉 on 15/6/22.
//  Copyright (c) 2015年 JJSHome. All rights reserved.
//

#import "AFHTTPRequest.h"

@implementation AFHTTPRequest

#pragma 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl
{
    __block BOOL netState = NO;
    
    NSURL *baseURL = [NSURL URLWithString:strUrl];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                netState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netState = NO;
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
    
    return netState;
}


#define CheckReqNil    if(!requestDicCache) requestDicCache = [[NSMutableDictionary alloc] init]
static NSMutableDictionary *requestDicCache = nil;

/***************************************
 在这做判断如果有dic里有errorCode
 调用errorBlock(dic)
 没有errorCode则调用block(dic
 ******************************/

#pragma --mark GET请求方式
+ (void) netRequestGETWithRequestURL: (NSString *) requestURLString
                            cacheUrl: (NSString *) cacheURLString
                       withParameter: (NSDictionary *) parameter
                withReturnValeuBlock: (ReturnValueBlock) finishBlock
                    withFailureBlock: (FailureBlock) failureBlock
{
    NSDebugLog(@"当前请求：%@",requestURLString);
    NSDebugLog(@"请求参数：%@",parameter);
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager.requestSerializer setTimeoutInterval:60];
    
    AFHTTPRequestOperation *op = [manager GET:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [requestDicCache removeObjectForKey:cacheURLString];
        
        NSString *result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
//        NSDebugLog(@"==%@", result);
        
        finishBlock(result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [requestDicCache removeObjectForKey:cacheURLString];
        
        //请求取消 不调用block
        if (error.code != NSURLErrorCancelled) {
            failureBlock(error);
        }
    }];
    
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [op start];
    
    CheckReqNil;
    [requestDicCache setObject:manager forKey:cacheURLString];
}

#pragma --mark POST请求方式
+ (void) netRequestPOSTWithRequestURL: (NSString *) requestURLString
                             cacheUrl: (NSString *) cacheURLString
                        withParameter: (NSDictionary *) parameter
                 withReturnValeuBlock: (ReturnValueBlock) finishBlock
                     withFailureBlock: (FailureBlock) failureBlock
{
    NSDebugLog(@"当前请求：%@",requestURLString);
    NSDebugLog(@"请求参数：%@",parameter);
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager.requestSerializer setTimeoutInterval:60];
    
    AFHTTPRequestOperation *op = [manager POST:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [requestDicCache removeObjectForKey:cacheURLString];
        
        NSString *result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        NSDebugLog(@"===%@", result);
        
        finishBlock(result);
        /***************************************
         在这做判断如果有dic里有errorCode
         调用errorBlock(dic)
         没有errorCode则调用block(dic
         ******************************/
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [requestDicCache removeObjectForKey:cacheURLString];
        
        //请求取消 不调用block
        if (error.code != NSURLErrorCancelled) {
            failureBlock(error);
        }
    }];
    
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [op start];
    
    CheckReqNil;
    [requestDicCache setObject:manager forKey:cacheURLString];
}

#pragma mark -
#pragma mark upload file to ks server
+ (void) netRequestUploadFileWithRequestURL: (NSString *) requestURLString
                                   withFile: (NSData *)fileData
                                   photoKey: (NSString *)photoKey
                                   fileName: (NSString *)fileName
                              withParameter: (NSDictionary *) parameter
                       withReturnValeuBlock: (ReturnValueBlock) finishBlock
                          withProgressBlock: (UploadProgressBlock) progressBlock
                           withFailureBlock: (FailureBlock) failureBlock
{
    NSString *mimeType = [PublicTools contentTypeForImageData:fileData];
    if ([photoKey isEqualToString:@"video"]) {
        mimeType = @"video/MP4";
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:60];
    
    AFHTTPRequestOperation  *operation= [manager POST:requestURLString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        [formData appendPartWithFileData:fileData name:photoKey fileName:fileName mimeType:mimeType];
        
    }success:^(AFHTTPRequestOperation *operation,id responseObject){
        
        [requestDicCache removeObjectForKey:requestURLString];
        NSString *result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        NSDebugLog(@"===%@", result);
        
        finishBlock(result);
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        
        [requestDicCache removeObjectForKey:requestURLString];
        
        //请求取消 不调用block
        if (error.code != NSURLErrorCancelled) {
            failureBlock(error);
        }
    }];
    
    //设置上传操作的进度
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        progressBlock((float)totalBytesWritten/totalBytesExpectedToWrite);
    }];
    
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [operation start];
    
    CheckReqNil;
    [requestDicCache setObject:manager forKey:requestURLString];
}

//移除请求
+ (void) netWorkCancelRequest:(NSString *) cacheURLString
{
    AFHTTPRequestOperationManager *manager = [requestDicCache objectForKey:cacheURLString];
    
    //非空，清除所在的数据
    if (manager) {
        [manager.operationQueue cancelAllOperations];
        
        [requestDicCache removeObjectForKey:cacheURLString];
    }
}

//下载文件存储到file文件夹
+ (void)downLoadFile:(NSString *)requsetUrl params:(NSDictionary *)params docName:(NSString *)docName fileName:(NSString *)fileName filepath:(NSString *)filepath progress:(CompletionWithObjectBlock)progressBlock complete:(CompletionWithObjectBlock)completion
{
    NSString *savedPath = filepath;
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:requsetUrl parameters:params error:nil];
    
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded;charset=%@",charset] forHTTPHeaderField:@"Content-Type"];
    //下载请求
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:savedPath append:YES];
    //下载进度回调
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //下载进度
        float progress = ((float)totalBytesRead) / (totalBytesExpectedToRead);
        NSLog(@"%f",progress);
        int jdcount = progress * 100;
        progressBlock(YES,[NSString stringWithFormat:@"%d%%",jdcount]);
    }];
                  
    //成功和失败回调
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"ok");
        NSLog(@"%@",responseObject);
        completion(YES,@"");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
                  
    [operation start];
    
}

@end
