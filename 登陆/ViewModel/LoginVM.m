//
//  LoginVM.m
//  
//
//  Created by Rainer on 15/12/11.
//
//

#import "LoginVM.h"

@implementation LoginVM

- (void)longinWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion
{
    NSString *requestUrl = AF_PRE_URL_1;
    NSString *cacheUrl = [AF_PRE_URL_1 stringByAppendingString:AF_LOGIN_URL];
    [AFHTTPRequest netRequestGETWithRequestURL:requestUrl cacheUrl:cacheUrl withParameter:params withReturnValeuBlock:^(id returnValue) {
        
        NSDebugLog(@"%@",returnValue);
        
        UserModel *userModel = [UserModel mj_objectWithKeyValues:returnValue];
        [PublicTools showHUDWithMessage:userModel.loginfo autoHide:YES];
        
        if (userModel.logret == LoginSuccessCode) {
            //自定义对象转nsdata 存本地
            NSData *encodeData = [NSKeyedArchiver archivedDataWithRootObject:userModel];
            [PublicTools saveUserDefaultObject:encodeData forKey:AF_USER_INFO];
            [PublicTools saveUserDefaultObject:userModel.Account forKey:AF_USER_NAME];
            completion(YES,@"");
        }else{
            completion(NO,@"");
        }
        
    } withFailureBlock:^(id failValue) {
        [PublicTools showHUDWithMessage:[(NSError *)failValue description] autoHide:YES];
        completion(NO,@"");
    }];
}

- (void)registerWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion
{
    NSString *requestUrl = AF_PRE_URL_1;
    NSString *cacheUrl = [AF_PRE_URL_1 stringByAppendingString:AF_REGISTER_URL];
    [AFHTTPRequest netRequestGETWithRequestURL:requestUrl cacheUrl:cacheUrl withParameter:params withReturnValeuBlock:^(id returnValue) {
        
        NSDebugLog(@"%@",returnValue);
        
        RegisterModel *model = [RegisterModel mj_objectWithKeyValues:returnValue];
        [PublicTools showHUDWithMessage:model.Info autoHide:YES];
        
        if (model.Ret == 0) {
            [PublicTools saveUserDefaultObject:model.Account forKey:AF_USER_NAME];
            completion(YES,@"");
        }else{
            completion(NO,@"");
        }
        
    } withFailureBlock:^(id failValue) {
        [PublicTools showHUDWithMessage:[(NSError *)failValue description] autoHide:YES];
        completion(NO,@"");
    }];
}

@end
