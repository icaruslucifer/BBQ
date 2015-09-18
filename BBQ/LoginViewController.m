//
//  LoginViewController.m
//  BBQ
//
//  Created by icarus on 15/8/7.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "LoginViewController.h"
#import "FMDBModel.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginBtnClick:(id)sender {
    NSDictionary *dict = [[FMDBModel sharedFMDBModel] getUserInfo:@"42028119890121" password:@"icarus"];
    if (dict!=nil) {
        NSString * path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"userInfo.plist"];
        [dict writeToFile:path atomically:YES];
        AppDelegate *app=  [[UIApplication sharedApplication] delegate];
        [app LoginSuccess];
    }
}
@end
