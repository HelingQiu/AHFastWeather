//
//  AFServiceDao.h
//  AHFastWeather
//
//  Created by Rainer on 15/12/27.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFBaseDao.h"
#import "ServiceModel.h"
#import "ProductModel.h"

@interface AFServiceDao : AFBaseDao

- (void)addService:(ServiceModel *)model product:(NSArray *)productArray completion:(CompletionWithObjectBlock)completion;

- (void)getAllServiceCompletion:(CompletionWithDoubleBlock)completion;

@end
