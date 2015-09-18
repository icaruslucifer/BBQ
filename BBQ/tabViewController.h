//
//  tabViewController.h
//  BBQ
//
//  Created by icarus on 15/8/6.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tabViewController : UITabBarController<UIAlertViewDelegate>


@property (assign,nonatomic) UIButton *selectedBtn;


-(void)setMyHide:(BOOL)hide;

@end
