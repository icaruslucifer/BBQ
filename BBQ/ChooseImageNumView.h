//
//  ChooseImageNumView.h
//  BBQ
//
//  Created by icarus on 15/9/1.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseImageNumView : UIView
{
    UILabel* _numlabel;
    CAShapeLayer * _circleShaperLayer;
}


-(void)setAnimation:(NSInteger)num;

@end
