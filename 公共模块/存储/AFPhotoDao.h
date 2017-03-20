//
//  AFPhotoDao.h
//  AHFastWeather
//
//  Created by Rainer on 15/12/22.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFBaseDao.h"
#import "AFPhotoModel.h"

@interface AFPhotoDao : AFBaseDao

//存
- (void)addPhoto:(AFPhotoModel *)model completion:(CompletionWithObjectBlock)completion;

//取
- (void)getPhotoByFileName:(NSString *)filename completion:(CompletionWithObjectBlock)completion;

@end
