//
//  ChildInfo.m
//  BBQ
//
//  Created by icarus on 15/8/7.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "ChildInfo.h"

@implementation ChildInfo

@synthesize childAge,childAnimal,childBirthday,childCrestedTime,childGender,childName,childSign,avatarUrl,detailStr,backgroundImageUrl;

-(instancetype)init
{
    self =[super init];
    if (self) {
        
    }
    return  self;
}

-(id)initWithChildID:(NSString*)childID
{
    self =[self init];
    if (self) {
        NSString * documentPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * sqliteDBPath = [documentPath stringByAppendingPathComponent:@"BBQ.db"];
        NSFileManager * fileManager =[ NSFileManager defaultManager];
        NSError * error = nil;
        if (![fileManager fileExistsAtPath:sqliteDBPath]) {
            [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"BBQ" ofType:@"db"]  toPath:sqliteDBPath error:&error];
            if (!error) {
                NSLog(@"copy db files success!");
            }
            else {
                NSLog(@"copy db file failed!");
            }
        }
        
        FMDatabase * db = [FMDatabase databaseWithPath:sqliteDBPath];
        if ([db open]) {
            FMResultSet * s =[db executeQuery:[NSString stringWithFormat:@"select bbq_child.*, bbq_childmeta.* from bbq_child left join bbq_childmeta on bbq_child.childID=bbq_childmeta.childID where bbq_child.childID ='%@'",childID]];
            if ([db intForQuery:[NSString stringWithFormat:@"select count(*) from bbq_child where childID ='%@'",childID]]==1) {
                while ([s next]) {
                    childName = [s stringForColumn:@"childName"];
                    childBirthday =[s dateForColumn:@"childBirthDay"];
                    childAnimal = [s stringForColumn:@"childAnimal"];
                    childSign = [s stringForColumn:@"childSign"];
                    childGender = [s stringForColumn:@"childGender"];
                    childCrestedTime =[s dateForColumn:@"childCreatedTime"];
                }
            }
           
        }
    }
    return self;
}



@end
