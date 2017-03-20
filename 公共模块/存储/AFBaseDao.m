//
//  JJSBaseDao.m
//  JJSButler
//
//  Created by 邱荷凌 on 15/7/4.
//  Copyright (c) 2015年 邱荷凌. All rights reserved.
//

#import "AFBaseDao.h"
#import "AppDelegate.h"

@implementation AFBaseDao

@synthesize queue;

- (id)init {
    
    if (self = [super init]) {
        
        [self initDB];
        
    }
    return self;
}

// Get DataBase From AppDelegate
- (void)initDB
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.queue = [appDelegate queue];
    
}

// Implement by sub class
- (NSString *)setTableName:(NSString *)sql
{
    
    return NULL;
    
}

@end
