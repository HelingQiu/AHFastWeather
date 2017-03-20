//
//  AFChatVM.m
//  AHFastWeather
//
//  Created by Rainer on 16/8/5.
//  Copyright © 2016年 ahqxfw. All rights reserved.
//

#import "AFChatVM.h"
#import "AFChatModel.h"

@implementation AFChatVM

- (void)getChatDataWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion
{
    NSString *requestUrl = AF_PRE_URL_3;
    NSString *cacheUrl = [AF_PRE_URL_3 stringByAppendingString:AF_GETCHAT_URL];
    [AFHTTPRequest netRequestGETWithRequestURL:requestUrl cacheUrl:cacheUrl withParameter:params withReturnValeuBlock:^(id returnValue) {
        
        NSDebugLog(@"%@",returnValue);
        NSError *error;
        id jsonBody = [NSJSONSerialization JSONObjectWithData:[returnValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        __block NSMutableArray *resultArray = [NSMutableArray array];
        if ([jsonBody isKindOfClass:[NSArray class]]) {
            [jsonBody enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                AFChatModel *model = [AFChatModel mj_objectWithKeyValues:obj];
                [resultArray addObject:model];
            }];
            completion(YES,resultArray);
        }else{
            completion(NO,@"获取指令失败");
        }
        
    } withFailureBlock:^(id failValue) {
        [PublicTools showHUDWithMessage:[(NSError *)failValue description] autoHide:YES];
        completion(NO,@"");
    }];
}

- (void)sendMessageWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion
{
    NSString *requestUrl = AF_PRE_URL_5;
    NSString *cacheUrl = [AF_PRE_URL_5 stringByAppendingString:AF_SENDMESSAGE_URL];
    [AFHTTPRequest netRequestGETWithRequestURL:requestUrl cacheUrl:cacheUrl withParameter:params withReturnValeuBlock:^(id returnValue) {
        
        NSDebugLog(@"sendMsg:%@",returnValue);
        NSError *error;
        id jsonBody = [NSJSONSerialization JSONObjectWithData:[returnValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if ([jsonBody isKindOfClass:[NSDictionary class]]) {
            if ([PublicTools judgeStringNotEmpty:[jsonBody objectForKey:@"Info"]]) {
                [PublicTools showHUDWithMessage:[jsonBody objectForKey:@"Info"] autoHide:YES];
            }
        }
        completion(YES,jsonBody);
        
    } withFailureBlock:^(id failValue) {
        [PublicTools showHUDWithMessage:[(NSError *)failValue description] autoHide:YES];
        completion(NO,@"");
    }];
}

@end
