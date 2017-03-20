//
//  AFRoadDao.h
//  AHFastWeather
//
//  Created by Rainer on 15/12/29.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFBaseDao.h"

@interface AFRoadDao : AFBaseDao

- (void)addproduct:(NSArray *)productArray completion:(CompletionWithObjectBlock)completion;

- (void)getAllServiceCompletion:(CompletionWithObjectBlock)completion;

@end
