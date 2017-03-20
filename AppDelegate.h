//
//  AppDelegate.h
//  AHFastWeather
//
//  Created by Rainer on 15/10/21.
//  Copyright (c) 2015年 ahqxfw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FMDB.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic , strong) FMDatabaseQueue * queue;

@end

