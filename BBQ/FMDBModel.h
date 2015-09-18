//
//  FMDBModel.h
//  BBQ
//
//  Created by icarus on 15/9/7.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface FMDBModel : NSObject
{
    FMDatabase * _db;
    NSString * _currentChild;
}

@property (assign,atomic)NSInteger startIndex;
@property (atomic,assign) NSInteger endIndex;



-(void)loadDBFile:(NSString*)dbName;
+(FMDBModel*)sharedFMDBModel;

-(void)setCurrrentChildID:(NSString*)str;
-(NSString *)getCurrentChildID;


-(NSInteger)writeObjectToDB:(NSDictionary*)imageDict;
-(BOOL)writeGTreeToDB:(NSDictionary*)treeDict;


-(NSDictionary *)getUserInfo:(NSString *)username password:(NSString*)password;
-(NSString *)getUserID;

-(NSDictionary *)getImageInfoByObjectID:(NSInteger)objectID;

-(NSArray*)getGTreeInfo:(NSInteger)startIndex endIndex:(NSInteger)endIndex;
-(NSArray*)getNewGTreeInfo:(NSInteger)currentLastIndex;
@end
