//
//  AFShowViewController.h
//  AHFastWeather
//
//  Created by Rainer on 15/12/21.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFBaseViewController.h"
#import "AFPhotoModel.h"

@interface AFShowViewController : AFBaseViewController

@property(nonatomic, strong) UIImage *image;

@property(nonatomic, strong) NSURL *videoUrl;

@property(nonatomic, strong) AFPhotoModel *model;

@end
