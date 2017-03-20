//
//  AFRoadDao.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/29.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFRoadDao.h"

@implementation AFRoadDao

- (NSString *)setTableName:(NSString *)sql
{
    return [NSString stringWithFormat:sql,@"road"];
}

- (void)addproduct:(NSArray *)productArray completion:(CompletionWithObjectBlock)completion
{
    __block BOOL result;
    @synchronized(self){
        
        [self.queue inDatabase:^(FMDatabase *db) {
            
            FMResultSet *resultSet = [db executeQuery:[self setTableName:@"SELECT * FROM %@"]];
            
            if (resultSet) {
                
                [db executeUpdate:[self setTableName:@"DELETE FROM %@"]];
            }
            
            NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:productArray];
            result = [db executeUpdate:[self setTableName:@"INSERT INTO %@ (road) values(?)"],archive];
            
            if (result){
                NSLog(@"photo insert successfully");
            }
            else{
                NSLog(@"photo insert failure");
            }
            
        }];
        
        completion(result,nil);
        
    }
}

- (void)getAllServiceCompletion:(CompletionWithObjectBlock)completion
{
    __block NSMutableArray *resultArray = [NSMutableArray array];
    @synchronized(self){
        [self.queue inDatabase:^(FMDatabase *db) {
            
            FMResultSet *rs = [db executeQuery:[self setTableName:@"SELECT * FROM %@"]];
            
            while ([rs next]) {
                
                NSData *pData = [rs objectForColumnName:@"road"];
                NSArray *pArray = [NSKeyedUnarchiver unarchiveObjectWithData:pData];
                [resultArray addObjectsFromArray:pArray];
            }
            
        }];
        
        completion(YES,resultArray);
    }
}

@end
