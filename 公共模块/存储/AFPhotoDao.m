//
//  AFPhotoDao.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/22.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFPhotoDao.h"

@implementation AFPhotoDao

- (NSString *)setTableName:(NSString *)sql
{
    return [NSString stringWithFormat:sql,@"photo"];
}

- (void)addPhoto:(AFPhotoModel *)model completion:(CompletionWithObjectBlock)completion
{
    __block BOOL result;
    @synchronized(self){
        
        [self.queue inDatabase:^(FMDatabase *db) {
            
            FMResultSet *resultSet = [db executeQuery:[self setTableName:@"SELECT * FROM %@ WHERE filename = ?"],model.filename];
            
            if (resultSet) {
                
                [db executeUpdate:[self setTableName:@"DELETE FROM %@ WHERE filename = ?"],model.filename];
            }
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
            
            result = [db executeUpdate:[self setTableName:@"INSERT INTO %@ (filename,model) values(?,?)"],model.filename,data];
            
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

- (void)getPhotoByFileName:(NSString *)filename completion:(CompletionWithObjectBlock)completion
{
    __block AFPhotoModel *model;
    @synchronized(self){
        [self.queue inDatabase:^(FMDatabase *db) {
            
            FMResultSet *rs = [db executeQuery:[self setTableName:@"SELECT * FROM %@ WHERE filename = ?"],filename];
            model = [[AFPhotoModel alloc] init];
            while ([rs next]) {
                
                NSData *data = [rs objectForColumnName:@"model"];
                
                model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
            
        }];
        
        completion(YES,model);
    }
}

@end
