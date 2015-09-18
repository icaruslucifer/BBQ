//
//  Login.m
//  BBQ
//
//  Created by icarus on 15/9/8.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "Login.h"

@implementation Login



+ (BOOL)isLogin {
    NSString* path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"userInfo.plist"];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:path]) {
        return YES;
    }
    
    return NO;
}

+ (NSDictionary *)getUserInfo {
    
    NSString* path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"userInfo.plist"];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    NSDictionary* userInfo = nil;
    
    if ([manager fileExistsAtPath:path]) {
        userInfo = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    return userInfo;
}

+ (void)LogOut {
    
    NSString* path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"userInfo.plist"];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
}

@end
