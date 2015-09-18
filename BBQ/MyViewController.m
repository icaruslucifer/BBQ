//
//  MyViewController.m
//  BBQ
//
//  Created by icarus on 15/8/6.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "MyViewController.h"
#import "AppDelegate.h"
#import "Login.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"我";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] currentMode].size.width/2, [[UIScreen mainScreen] currentMode].size.height/2)];
    NSLog(@"width:%f,heigth:%f",self.view.frame.size.width,self.view.frame.size.height);
    _BackgroundImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 140)];
    [_BackgroundImageView setBackgroundColor:[UIColor lightGrayColor]];
    
    _UserImageView =[[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 74, 100, 100)];
    [_UserImageView setBackgroundColor:[UIColor greenColor]];
    _UserImageView.layer.cornerRadius = _UserImageView.frame.size.width/2;
    
    _UserName = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 174, 100, 30)];
    [_UserName setTextAlignment:NSTextAlignmentCenter];
    
    
    [self.view addSubview:_BackgroundImageView];
    [self.view addSubview:_UserImageView];
    [self.view addSubview:_UserName];
    
    
    NSString *path =[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"userInfo.plist"];
    NSFileManager* manager =[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        [_UserName setText:[dict objectForKey:@"userName"]];
    }
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, self.view.frame.size.height-30-70, self.view.frame.size.width, 30)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnLogout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


-(void)btnLogout:(id)sender
{
    [Login LogOut];
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app LogoutSuccess];
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

@end
