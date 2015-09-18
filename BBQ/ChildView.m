//
//  ChildView.m
//  BBQ
//
//  Created by icarus on 15/8/6.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "ChildView.h"

@implementation ChildView

@synthesize nameLabel,ageLabel,detailLabel,detailBtn,avatarView,backgroundView;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithChildInfo:(NSString*) childID
{
    self =[self init];
    if (self) {
        [self setFrame:CGRectMake(0, 64, [[UIScreen mainScreen] currentMode].size.width/2, 110)];
        avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
        [avatarView.layer setCornerRadius:CGRectGetHeight(avatarView.bounds)/2];
        avatarView.layer.masksToBounds =YES;
        avatarView.layer.borderWidth =2;
        avatarView.layer.borderColor =[UIColor whiteColor].CGColor;
        
        nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(90, 15, 80, 25)];
        ageLabel =[[UILabel alloc] initWithFrame:CGRectMake(90, 45, 200, 25)];
        
        backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 110)];
        backgroundView.alpha=0.6;
        
        detailBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [detailBtn setTitle:@"进入" forState:UIControlStateNormal];
        [detailBtn setFrame:CGRectMake(330, 50, 40,20)];
        
        
        [self addSubview:backgroundView];
        [self addSubview:avatarView];
        [self addSubview:nameLabel];
        [self addSubview:ageLabel];
        [self addSubview:detailBtn];
        
        ChildInfo * childInfo =[[ChildInfo alloc] initWithChildID:childID];
        if (childInfo != nil) {
            [avatarView setImage:[UIImage imageNamed:@"login_bg_normal"]];
            [nameLabel setText:childInfo.childName];
            [backgroundView setImage:[UIImage imageNamed:@"login_bg_normal"]];
        }
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

@end
