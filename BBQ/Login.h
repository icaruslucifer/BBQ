//
//  Login.h
//  BBQ
//
//  Created by icarus on 15/9/8.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Login : NSObject


+ (BOOL)isLogin;

+ (NSDictionary*)getUserInfo;

+ (void)LogOut;

@end
