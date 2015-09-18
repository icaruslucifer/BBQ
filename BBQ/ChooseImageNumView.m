//
//  ChooseImageNumView.m
//  BBQ
//
//  Created by icarus on 15/9/1.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "ChooseImageNumView.h"

@implementation ChooseImageNumView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        _circleShaperLayer = [CAShapeLayer layer];
        _circleShaperLayer.frame =CGRectMake(0, 0, frame.size.width, frame.size.height);
        _circleShaperLayer.cornerRadius = frame.size.width/2;
        _circleShaperLayer.backgroundColor =AllGreen.CGColor;
        [self.layer addSublayer:_circleShaperLayer];
        
        _numlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_numlabel setFont:[UIFont systemFontOfSize:frame.size.width-5]];
        [_numlabel setTextColor:[UIColor whiteColor]];
        [_numlabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_numlabel];
        
    }
    return self;
}

-(void)setAnimation:(NSInteger)num
{
    CABasicAnimation *zoomOut= [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomOut.duration =0.2f;
    zoomOut.fromValue =@(1);
    zoomOut.toValue =@(0.2);
    [_circleShaperLayer addAnimation:zoomOut forKey:@"zoomOut"];
    [_numlabel setText:[NSString stringWithFormat:@"%ld",num]];
    [_numlabel.layer addAnimation:zoomOut forKey:@"zoomout"];
}


@end
