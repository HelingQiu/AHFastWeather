//
//  AFPhotoModel.h
//  AHFastWeather
//
//  Created by Rainer on 15/12/22.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFPhotoModel : NSObject

@property(nonatomic, copy) NSString *filename;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *lat;
@property(nonatomic, copy) NSString *lng;
@property(nonatomic, copy) NSString *address;

@end
