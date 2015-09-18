//
//  ChildView.h
//  BBQ
//
//  Created by icarus on 15/8/6.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChildInfo.h"

@interface ChildView : UIView


@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UILabel *ageLabel;
@property (strong,nonatomic) UILabel *detailLabel;
@property (strong,nonatomic) UIImageView * avatarView;
@property (strong,nonatomic) UIImageView * backgroundView;
@property (strong,nonatomic) UIButton * detailBtn;



- (id)initWithChildInfo:(NSString*) childID;
@end
