//
//  FirstAnnotationView.h
//  AHFastWeather
//
//  Created by Rainer on 15/12/17.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "ActuallyModel.h"

@interface FirstAnnotationView : BMKAnnotationView

@property (nonatomic, strong) UIImageView *annotationImageView;

@property (nonatomic, strong) ActuallyModel *model;

@end
