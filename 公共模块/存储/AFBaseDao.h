//
//  JJSBaseDao.h
//  JJSButler
//
//  Created by 邱荷凌 on 15/7/4.
//  Copyright (c) 2015年 邱荷凌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface AFBaseDao : NSObject

@property (nonatomic, strong) FMDatabaseQueue * queue;

- (NSString *)setTableName:(NSString *)sql;

@end
