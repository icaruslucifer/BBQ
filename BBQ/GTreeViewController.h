//
//  GTreeViewController.h
//  BBQ
//
//  Created by icarus on 15/8/6.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INFOCELLHEGHT 250

@interface GTreeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableview;
    NSMutableArray * _gtreeArray;
}




@end
