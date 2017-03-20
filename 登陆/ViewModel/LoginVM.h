//
//  LoginVM.h
//  
//
//  Created by Rainer on 15/12/11.
//
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "RegisterModel.h"

@interface LoginVM : NSObject

//登录
- (void)longinWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion;

//注册
- (void)registerWithParams:(NSDictionary *)params complete:(CompletionWithObjectBlock)completion;

@end
