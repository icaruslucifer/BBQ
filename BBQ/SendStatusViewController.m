//
//  SendStatusViewController.m
//  BBQ
//
//  Created by icarus on 15/9/6.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "SendStatusViewController.h"
#import "tabViewController.h"
#import "RecordViewController.h"
#import "SendStatus.h"
#import "FMDBModel.h"
#import "GTreeViewController.h"


@interface SendStatusViewController ()

@end

@implementation SendStatusViewController
@synthesize s_imageUrlArray;
@synthesize locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    location = @"";
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    
    UIBarButtonItem *sendBtn =[[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(sendAction)];
    [sendBtn setTintColor:[UIColor greenColor]];
    self.navigationItem.rightBarButtonItem =sendBtn;
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _sendstatusView = [[SendStatus alloc] initWithFrame:CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height) Imgae:s_imageUrlArray];
    [self.view addSubview:_sendstatusView];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate =self;
    locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    locationManager.distanceFilter = 1000.0f;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    
}


-(void)sendAction
{
    NSMutableDictionary * gtreeDict =[[NSMutableDictionary alloc] init];
    NSString * objectList =@"";
    for (int i=0; i<[s_imageUrlArray count]; i++) {
        NSInteger objectID = [[FMDBModel sharedFMDBModel] writeObjectToDB:[s_imageUrlArray objectAtIndex:i]];
        if (objectID!=-1) {
            objectList = [objectList stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)objectID]];
        }
        if (i!=[s_imageUrlArray count]-1) {
            objectList = [objectList stringByAppendingString:@"#"];
        }
    }
    [gtreeDict setObject:objectList forKey:@"objectList"];
    [gtreeDict setObject:_sendstatusView.statusTV.text forKey:@"words"];
    [gtreeDict setObject:[[FMDBModel sharedFMDBModel] getUserID] forKey:@"userID"];
    [gtreeDict setObject:[[FMDBModel sharedFMDBModel] getCurrentChildID] forKey:@"childID"];
    [gtreeDict setObject:location forKey:@"userLocation"];
    if ([[FMDBModel sharedFMDBModel] writeGTreeToDB:gtreeDict]) {
        NSLog(@"send success!");
        [FMDBModel sharedFMDBModel].endIndex+=1;
        for (int i=0; i<[self.navigationController.viewControllers count];i++) {
            if ([[self.navigationController.viewControllers objectAtIndex:i] isKindOfClass:[RecordViewController class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:i] animated:YES];
                break;
            }
        }
    }
}

-(void)cancelAction
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"放弃此次编辑？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    alertview.delegate = self;
    alertview.tag = 101;
    [alertview show];
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==101) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                for (int i=0; i<[self.navigationController.viewControllers count];i++) {
                    if ([[self.navigationController.viewControllers objectAtIndex:i] isKindOfClass:[RecordViewController class]]) {
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:i] animated:YES];
                        break;
                    }
                }
                //[self.navigationController popViewControllerAnimated:YES];
                break;
            default:
                break;
        }

    }
}
-(void)viewWillAppear:(BOOL)animated
{
    
    tabViewController *tabbarcontroller = (tabViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarcontroller setMyHide:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
    tabViewController *tabbarcontroller = (tabViewController*)self.view.window.rootViewController;
    [tabbarcontroller setMyHide:NO];
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

#pragma mark -Location

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLGeocoder * geocoder =[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:[locations objectAtIndex:0]  completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count]>0) {
            CLPlacemark *place =[placemarks objectAtIndex:0];
            NSLog(@"%@",place.name);
            location = place.name;
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

@end
