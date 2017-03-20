//
//  AFServiceDao.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/27.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFServiceDao.h"

@implementation AFServiceDao

- (NSString *)setTableName:(NSString *)sql
{
    return [NSString stringWithFormat:sql,@"service"];
}

- (void)addService:(ServiceModel *)model product:(NSArray *)productArray completion:(CompletionWithObjectBlock)completion
{
    __block BOOL result;
    @synchronized(self){
        
        [self.queue inDatabase:^(FMDatabase *db) {
            
            FMResultSet *resultSet = [db executeQuery:[self setTableName:@"SELECT * FROM %@ WHERE pid = ?"],model.pid];
            
            if (resultSet) {
                
                [db executeUpdate:[self setTableName:@"DELETE FROM %@ WHERE pid = ?"],model.pid];
            }
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
            NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:productArray];
            result = [db executeUpdate:[self setTableName:@"INSERT INTO %@ (pid,model,pmodel) values(?,?,?)"],model.pid,data,archive];
            
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

- (void)getAllServiceCompletion:(CompletionWithDoubleBlock)completion
{
    __block NSMutableArray *resultArray = [NSMutableArray array];
    __block NSMutableArray *resultProArray = [NSMutableArray array];
    @synchronized(self){
        [self.queue inDatabase:^(FMDatabase *db) {
            
            FMResultSet *rs = [db executeQuery:[self setTableName:@"SELECT * FROM %@"]];
            
            while ([rs next]) {
                
                NSData *data = [rs objectForColumnName:@"model"];
                
                ServiceModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [resultArray addObject:model];
                
                NSData *pData = [rs objectForColumnName:@"pmodel"];
                NSArray *pArray = [NSKeyedUnarchiver unarchiveObjectWithData:pData];
                [resultProArray addObject:pArray];
            }
            
        }];
        
        completion(YES,resultArray,resultProArray);
    }
}

@end
