//
//  SendStatusViewController.h
//  BBQ
//
//  Created by icarus on 15/9/6.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendStatus.h"
#import <CoreLocation/CoreLocation.h>

@interface SendStatusViewController : UIViewController<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    SendStatus * _sendstatusView;
    NSString * location;
}


@property (nonatomic,strong) NSMutableArray * s_imageUrlArray;
@property (nonatomic,strong) CLLocationManager *locationManager;

-(void)cancelAction;
@end
