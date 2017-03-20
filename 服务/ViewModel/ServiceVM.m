//
//  ServiceVM.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/13.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "ServiceVM.h"

@implementation ServiceVM

- (void)getServiceProductListWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion
{
    NSString *requestUrl = AF_PRE_URL_3;
    NSString *cacheUrl = [AF_PRE_URL_3 stringByAppendingString:AF_GETPRODUCT_URL];
    [AFHTTPRequest netRequestGETWithRequestURL:requestUrl cacheUrl:cacheUrl withParameter:params withReturnValeuBlock:^(id returnValue) {
        
//        NSDebugLog(@"%@",returnValue);
        NSError *error;
        id jsonBody = [NSJSONSerialization JSONObjectWithData:[returnValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        
        __block NSMutableArray *fResultArray = [NSMutableArray array];
        
        __block NSMutableArray *resultArray = [NSMutableArray array];
        if ([jsonBody isKindOfClass:[NSArray class]]) {
            NSArray *array = jsonBody;
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ServiceModel *model = [ServiceModel mj_objectWithKeyValues:obj];
                if (model.isshow == 0) {
                    [resultArray addObject:model];
                }
            }];
        }
        
        [resultArray sortUsingComparator:^NSComparisonResult(ServiceModel  * obj1, ServiceModel  * obj2) {
            if (obj1.showorder > obj2.showorder) { // obj1排后面
                return NSOrderedDescending;
            } else { // obj1排前面
                return NSOrderedAscending;
            }
        }];
        
        NSDebugLog(@"==%@",resultArray);
        
//        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:AF_USER_INFO];
//        UserModel *model = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
//        
//        [resultArray enumerateObjectsUsingBlock:^(ServiceModel  * smodel, NSUInteger idx, BOOL * stop) {
//            
//            
//            
//        }];
        
        completion(YES,resultArray);
        
    } withFailureBlock:^(id failValue) {
        [PublicTools showHUDWithMessage:[(NSError *)failValue description] autoHide:YES];
        completion(NO,@"");
    }];
}

- (void)getProductListWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion
{
    NSString *requestUrl = AF_PRE_URL_3;
    NSString *cacheUrl = [AF_PRE_URL_3 stringByAppendingString:AF_GETPINFO_URL];
    [AFHTTPRequest netRequestGETWithRequestURL:requestUrl cacheUrl:cacheUrl withParameter:params withReturnValeuBlock:^(id returnValue) {
        
        //        NSDebugLog(@"%@",returnValue);
        NSError *error;
        id jsonBody = [NSJSONSerialization JSONObjectWithData:[returnValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        
        NSMutableArray *resultArray = [NSMutableArray array];
        if ([jsonBody isKindOfClass:[NSArray class]]) {
            NSArray *array = jsonBody;
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ProductModel *model = [ProductModel mj_objectWithKeyValues:obj];
                
                [resultArray addObject:model];
                
            }];
        }
        
        NSDebugLog(@"%@",resultArray);
        
        completion(YES,resultArray);
        
    } withFailureBlock:^(id failValue) {
        [PublicTools showHUDWithMessage:[(NSError *)failValue description] autoHide:YES];
        completion(NO,@"");
    }];
}

@end
