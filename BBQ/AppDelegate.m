//
//  AppDelegate.m
//  BBQ
//
//  Created by icarus on 15/8/6.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "AppDelegate.h"
#import "tabViewController.h"
#import "Login.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
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
    
    if ([Login isLogin]) {
        tabViewController * myTabBarViewController =[[tabViewController alloc] init];
        self.window.rootViewController =myTabBarViewController;
    }
    else{
        LoginViewController *loginViewController =[[LoginViewController alloc] init];
        self.window.rootViewController =loginViewController;
    }
    
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)LoginSuccess
{
    if ([Login isLogin]) {
        tabViewController * myTabBarViewController =[[tabViewController alloc] init];
        self.window.rootViewController =myTabBarViewController;
    }
}

-(void)LogoutSuccess
{
    if (![Login isLogin]) {
        LoginViewController *loginViewController =[[LoginViewController alloc] init];
        self.window.rootViewController =loginViewController;
    }
}
@end
