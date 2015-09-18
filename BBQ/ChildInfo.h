//
//  ChildInfo.h
//  BBQ
//
//  Created by icarus on 15/8/7.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface ChildInfo : NSObject{
    
}

@property (nonatomic,strong) NSString * childName;
@property (nonatomic,strong) NSString * childAge;
@property (nonatomic,strong) NSString * detailStr;
@property (nonatomic,strong) NSString * avatarUrl;
@property (nonatomic,strong) NSString * backgroundImageUrl;
@property (nonatomic,strong) NSString * childGender;
@property (strong,nonatomic) NSString * childSign;
@property (strong,nonatomic) NSString * childAnimal;
@property (strong,nonatomic) NSDate * childCrestedTime;
@property (strong,nonatomic) NSDate * childBirthday;

-(id)initWithChildID:(NSString*)childID;
@end
