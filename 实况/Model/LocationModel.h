//
//  LocationModel.h
//  AHFastWeather
//
//  Created by Rainer on 15/12/17.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModel : NSObject

@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *latitude;
@property(nonatomic, copy) NSString *longtitude;
@property(nonatomic, copy) NSString *addr;
@property(nonatomic, copy) NSString *describe;

@end
