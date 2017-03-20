//
//  ActuallyVM.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/15.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "ActuallyVM.h"
#import "ActuallyModel.h"

@implementation ActuallyVM

- (void)getStationWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion
{
    NSString *cache = [AF_PRE_URL_3 stringByAppendingString:AF_GETOB_URL];
    [AFHTTPRequest netRequestGETWithRequestURL:AF_PRE_URL_3 cacheUrl:cache withParameter:params withReturnValeuBlock:^(id returnValue) {
        
        NSError *error;
        id jsonBody = [NSJSONSerialization JSONObjectWithData:[returnValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
//        NSDebugLog(@"json:%@",jsonBody);
        
        __block NSMutableArray *resultArray = [NSMutableArray array];
        if ([jsonBody isKindOfClass:[NSArray class]]) {
            NSArray *array = jsonBody;
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ActuallyModel *model = [ActuallyModel mj_objectWithKeyValues:obj];
                
                [resultArray addObject:model];
                
            }];
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
