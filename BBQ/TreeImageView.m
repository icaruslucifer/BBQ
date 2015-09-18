//
//  TreeImageView.m
//  BBQ
//
//  Created by icarus on 15/9/9.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "TreeImageView.h"

@implementation TreeImageView

@synthesize delegate,index,array;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer* singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
        singleTap.numberOfTouchesRequired = 1; //手指数
        singleTap.numberOfTapsRequired = 1; //tap次数
        singleTap.delegate= self;
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

-(void)imageClick:(id)sender
{
    if ([delegate respondsToSelector:@selector(selectdImage: dic:)]) {
        [delegate selectdImage:index dic:array];
    }
}

@end
