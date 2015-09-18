//
//  FMDBModel.m
//  BBQ
//
//  Created by icarus on 15/9/7.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "FMDBModel.h"

@implementation FMDBModel

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self loadDBFile:@"BBQ"];
        _startIndex =1;
        _endIndex =5;
    }
    return self;
}


+(FMDBModel*)sharedFMDBModel
{
    static FMDBModel* instance =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
-(void)loadDBFile:(NSString *)dbName
{
    NSString * documentPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * sqliteDBPath = [documentPath stringByAppendingPathComponent:[dbName stringByAppendingString:@".db"]];
    NSFileManager * fileManager =[ NSFileManager defaultManager];
    NSError * error = nil;
    if (![fileManager fileExistsAtPath:sqliteDBPath]) {
        [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:dbName ofType:@"db"]  toPath:sqliteDBPath error:&error];
        if (!error) {
            NSLog(@"copy db files success!");
        }
        else {
            NSLog(@"copy db file failed!");
        }
    }
    _db = [FMDatabase databaseWithPath:sqliteDBPath];
}

-(void)setCurrrentChildID:(NSString *)str
{
    _currentChild =str;
}

-(NSString*)getCurrentChildID
{
    if (_currentChild!=nil) {
        return _currentChild;
    }
    return nil;
}

-(NSString *)getCurrentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDate =[dateFormatter stringFromDate:[NSDate date]];
    return currentDate;
}

-(NSInteger)writeObjectToDB:(NSDictionary *)imageDict
{
    if ([_db open]) {
        FMResultSet* resultSet = [_db executeQuery:@"SELECT objectID FROM bbq_object order by objectID desc"];
        int maxindex = -1;
        if([resultSet next]) {
            maxindex = [resultSet intForColumn:@"objectID"];
        }
        maxindex +=1;
        [_db executeUpdate:@"INSERT INTO bbq_object(objectID,objectPublishTime,objectCollectionTime,objectType,objectUrl) VALUES (?,?,?,?,?)",[NSNumber numberWithInt:maxindex],[self getCurrentDate],[imageDict objectForKey:@"createtime"],@"1",[imageDict objectForKey:@"imageurl"]];
        return maxindex;
    }
    return -1;
}

-(BOOL)writeGTreeToDB:(NSDictionary *)treeDict
{
    if ([_db open]) {
        FMResultSet* resultSet = [_db executeQuery:@"SELECT gtreeID FROM bbq_gtree order by gtreeID desc"];
        int maxindex = -1;
        if([resultSet next]) {
            maxindex = [resultSet intForColumn:@"gtreeID"];
        }
        maxindex +=1;
        NSLog(@"%@",[treeDict objectForKey:@"objectList"]);
        [_db executeUpdate:@"INSERT INTO bbq_gtree(gtreeID,childID,publishTime,words,objectList,userID,userLocation) VALUES (?,?,?,?,?,?,?)",[NSNumber numberWithInt:maxindex],[treeDict objectForKey:@"childID"],[self getCurrentDate],[treeDict objectForKey:@"words"],[treeDict objectForKey:@"objectList"],[treeDict objectForKey:@"userID"],[treeDict objectForKey:@"userLocation"]];
        return TRUE;
    }
    return FALSE;
}

-(NSDictionary*)getUserInfo:(NSString *)username password:(NSString *)password
{
    if ([_db open]) {
        FMResultSet * resultSet =[_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM bbq_users WHERE userID='%@' AND userPassword='%@'",username,password]];
        if ([resultSet next]) {
            NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
            [dict setObject:[resultSet stringForColumn:@"userID"] forKey:@"userID"];
            [dict setObject:[resultSet stringForColumn:@"userEmail"] forKey:@"userEmail"];
            [dict setObject:[resultSet stringForColumn:@"userPassword"] forKey:@"userPassword"];
            [dict setObject:[resultSet stringForColumn:@"userName"] forKey:@"userName"];
            [dict setObject:[resultSet stringForColumn:@"isEmail"] forKey:@"isEmail"];
            //[dict setObject:[resultSet stringForColumn:@"userAvatar"] forKey:@"userAvatar"];
            //[dict setValue:[NSString stringWithFormat:@"%d",[resultSet intForColumn:@"userGender"]] forKey:@"userGender"];
            //[dict setObject:[resultSet stringForColumn:@"userInfo"] forKey:@"userInfo"];
            [dict setObject:[resultSet stringForColumn:@"userArea"] forKey:@"userArea"];
            //[dict setObject:[resultSet stringForColumn:@"userChildList"] forKey:@"userChildList"];
            return dict;
        }
    }
    return  nil;
}

-(NSString*)getUserID
{
    NSString *path =[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"userInfo.plist"];
    NSFileManager* manager =[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        return [dict objectForKey:@"userName"];
    }
    return  nil;
}

-(NSDictionary *)getImageInfoByObjectID:(NSInteger)objectID{
    if ([_db open]) {
        FMResultSet* resultSet = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM bbq_object WHERE objectID=%ld",(long)objectID]];
        if([resultSet next]) {
            NSMutableDictionary * dict =[[NSMutableDictionary alloc] init];
            [dict setObject:[resultSet stringForColumn:@"objectCollectionTime"] forKey:@"objectCollectionTime"];
            [dict setObject:[resultSet stringForColumn:@"objectPublishTime"] forKey:@"objectPublishTime"];
            [dict setObject:[resultSet stringForColumn:@"objectUrl"] forKey:@"objectUrl"];
            return  dict;
        }
    }
    return  nil;
}


-(NSArray*)getGTreeInfo:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    if ([_db open]) {
        NSString *sqlstr = [NSString stringWithFormat:@"select * from bbq_gtree order by gtreeID desc limit %ld,%ld",startIndex,endIndex];
        FMResultSet* resultSet = [_db executeQuery:sqlstr];
        NSMutableArray * array = [[NSMutableArray alloc] init];
        while([resultSet next]) {
            NSMutableDictionary * dic =[[NSMutableDictionary alloc] init];
            [dic setValue:[NSNumber numberWithInt:[resultSet intForColumn:@"gtreeID"]] forKey:@"gtreeID"];
            [dic setObject:[resultSet stringForColumn:@"publishTime"] forKey:@"publishTime"];
            if ([resultSet stringForColumn:@"words"]!=nil) {
                [dic setObject:[resultSet stringForColumn:@"words"] forKey:@"words"];

            }
            if ([resultSet stringForColumn:@"objectList"]!=nil) {
                [dic setObject:[resultSet stringForColumn:@"objectList"] forKey:@"objectList"];
                
            }
            if ([resultSet stringForColumn:@"userLocation"]!=nil) {
                [dic setObject:[resultSet stringForColumn:@"userLocation"] forKey:@"userLocation"];
            }
            [dic setObject:[resultSet stringForColumn:@"userID"] forKey:@"userID"];
            [dic setObject:[resultSet stringForColumn:@"childID"] forKey:@"childID"];
            [array addObject:dic];
        }
        return array;
    }
    return  nil;
}

-(NSArray*)getNewGTreeInfo:(NSInteger)currentLastIndex{
    if ([_db open]) {
        NSString *sqlstr =[NSString stringWithFormat:@"select * from bbq_gtree where gtreeID>%ld order by gtreeID desc ",currentLastIndex];
        FMResultSet* resultSet = [_db executeQuery:sqlstr];
        NSMutableArray * array = [[NSMutableArray alloc] init];
        while([resultSet next]) {
            NSMutableDictionary * dic =[[NSMutableDictionary alloc] init];
            [dic setValue:[NSNumber numberWithInt:[resultSet intForColumn:@"gtreeID"]] forKey:@"gtreeID"];
            [dic setObject:[resultSet stringForColumn:@"publishTime"] forKey:@"publishTime"];
            if ([resultSet stringForColumn:@"words"]!=nil) {
                [dic setObject:[resultSet stringForColumn:@"words"] forKey:@"words"];
                
            }
            if ([resultSet stringForColumn:@"objectList"]!=nil) {
                [dic setObject:[resultSet stringForColumn:@"objectList"] forKey:@"objectList"];
                
            }
            if ([resultSet stringForColumn:@"userLocation"]!=nil) {
                [dic setObject:[resultSet stringForColumn:@"userLocation"] forKey:@"userLocation"];
            }
            [dic setObject:[resultSet stringForColumn:@"userID"] forKey:@"userID"];
            [dic setObject:[resultSet stringForColumn:@"childID"] forKey:@"childID"];
            [array addObject:dic];
        }
        return array;
    }
    return nil;
}

@end
