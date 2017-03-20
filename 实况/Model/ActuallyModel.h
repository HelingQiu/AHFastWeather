//
//  ActuallyModel.h
//  AHFastWeather
//
//  Created by Rainer on 15/12/15.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActuallyModel : NSObject

@property(nonatomic, copy) NSString *Latitude;

@property(nonatomic, copy) NSString *Longtitude;

@property(nonatomic, copy) NSString *OBTime;

@property(nonatomic, copy) NSString *Rainfall;

@property(nonatomic, copy) NSString *SiteKind;

@property(nonatomic, copy) NSString *StationID;

@property(nonatomic, copy) NSString *StationName;

@property(nonatomic, copy) NSString *StationNum;

@property(nonatomic, copy) NSString *Temperature;

@property(nonatomic, copy) NSString *Visibility;

@property(nonatomic, copy) NSString *WindSpeed;

@end
