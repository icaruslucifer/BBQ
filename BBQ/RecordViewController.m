//
//  RecordViewController.m
//  BBQ
//
//  Created by icarus on 15/8/6.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "RecordViewController.h"
#import <QiniuSDK.h>
#import "ChooseImageViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(100, 100, 50, 50)];
    [btn setTitle:@"上传" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(UploadImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
//        tabViewController *tabbarcontroller = (tabViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//        [tabbarcontroller setMyHide:NO];
}

-(void)UploadImage:(id)sender
{
    ChooseImageViewController * chooseImageViewController = [[ChooseImageViewController alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationController pushViewController:chooseImageViewController animated:YES];
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
