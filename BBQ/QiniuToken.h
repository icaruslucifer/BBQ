//
//  QiniuToken.h
//  BBQ
//
//  Created by icarus on 15/9/18.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QiniuSDK.h>

@interface QiniuToken : NSObject

+ (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey;
+ (NSString *)marshal;
+(NSString*)DataTOjsonString:(id)object;
@end
