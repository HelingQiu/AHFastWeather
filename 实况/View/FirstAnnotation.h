//
//  FirstAnnotation.h
//  AHFastWeather
//
//  Created by Rainer on 15/12/17.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "ActuallyModel.h"

@interface FirstAnnotation : BMKPointAnnotation

@property(nonatomic, strong) ActuallyModel *model;

@end
