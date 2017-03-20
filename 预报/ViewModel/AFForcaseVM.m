//
//  AFForcaseVM.m
//  AHFastWeather
//
//  Created by Rainer on 16/8/5.
//  Copyright © 2016年 ahqxfw. All rights reserved.
//

#import "AFForcaseVM.h"
#import "AFForcaseModel.h"

@implementation AFForcaseVM

- (void)getForcaseDataWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion
{
    NSString *requestUrl = AF_PRE_URL_3;
    NSString *cacheUrl = [AF_PRE_URL_3 stringByAppendingString:AF_GETPINFO_URL];
    [AFHTTPRequest netRequestGETWithRequestURL:requestUrl cacheUrl:cacheUrl withParameter:params withReturnValeuBlock:^(id returnValue) {
        
        NSDebugLog(@"%@",returnValue);
        NSError *error;
        id jsonBody = [NSJSONSerialization JSONObjectWithData:[returnValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        
        __block NSMutableArray *resultArray = [NSMutableArray array];
        if ([jsonBody isKindOfClass:[NSArray class]]) {
            NSArray *array = jsonBody;
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                AFForcaseModel *model = [AFForcaseModel mj_objectWithKeyValues:obj];
                
                [resultArray addObject:model];
            }];
        }
        if (resultArray.count) {
            completion(YES,resultArray);
        }else{
            completion(NO,@"");
        }
    } withFailureBlock:^(id failValue) {
        [PublicTools showHUDWithMessage:[(NSError *)failValue description] autoHide:YES];
        completion(NO,@"");
    }];
}

@end
