//
//  QiniuToken.m
//  BBQ
//
//  Created by icarus on 15/9/18.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "QiniuToken.h"
#import <Qiniu/GTM_Base64.h>
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>


@implementation QiniuToken



// Make a token string conform to the UpToken spec.

+ (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey
{
    const char *secretKeyStr = [secretKey UTF8String];
    
    NSString *policy = [self marshal];
    
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodedPolicy = [GTM_Base64 stringByWebSafeEncodingData:policyData padded:TRUE];
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
    
    NSString *encodedDigest = [GTM_Base64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, encodedDigest, encodedPolicy];
    
    return token;
}

+(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

// Marshal as JSON format string.

+ (NSString *)marshal
{
    time_t deadline;
    time(&deadline);
    
    //deadline += (self.expires > 0) ? self.expires : 3600; // 1 hour by default.
    deadline =3600;
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@"bbqforios" forKey:@"scope"];
//    if (self.scope) {
//        [dic setObject:self.scope forKey:@"scope"];
//    }
//    if (self.callbackUrl) {
//        [dic setObject:self.callbackUrl forKey:@"callbackUrl"];
//    }
//    if (self.callbackBodyType) {
//        [dic setObject:self.callbackBodyType forKey:@"callbackBodyType"];
//    }
//    if (self.customer) {
//        [dic setObject:self.customer forKey:@"customer"];
//    }
    
    [dic setObject:deadlineNumber forKey:@"deadline"];
    NSNumber *escapeNumber = [NSNumber numberWithLongLong:1];
    [dic setObject:escapeNumber forKey:@"escape"];
    
//    if (self.escape) {
//        NSNumber *escapeNumber = [NSNumber numberWithLongLong:escape];
//        [dic setObject:escapeNumber forKey:@"escape"];
//    }
    
    NSString *json = [self DataTOjsonString:dic];
    
    return json;
}


@end
