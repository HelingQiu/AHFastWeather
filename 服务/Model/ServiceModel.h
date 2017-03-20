//
//  ServiceModel.h
//  AHFastWeather
//
//  Created by Rainer on 15/12/13.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceModel : NSObject

@property(nonatomic, assign) NSInteger isshow;
@property(nonatomic, copy) NSString *lstbatch;
@property(nonatomic, copy) NSString *pid;
@property(nonatomic, copy) NSString *pname;
@property(nonatomic, assign) NSInteger showorder;

@end
