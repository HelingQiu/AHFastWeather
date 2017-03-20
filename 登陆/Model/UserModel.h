//
//  UserModel.h
//  
//
//  Created by Rainer on 15/12/11.
//
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface UserModel : NSObject

singleton_interface(UserModel)

@property (nonatomic, copy) NSString *Account;

@property (nonatomic, copy) NSString *MobilePhone;

@property (nonatomic, copy) NSString *Password;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *depart;

@property (nonatomic, copy) NSString *loginfo;

@property (nonatomic, assign) NSInteger logret;

@property (nonatomic, copy) NSString *name;

@end
