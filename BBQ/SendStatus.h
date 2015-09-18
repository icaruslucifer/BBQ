//
//  SendStatus.h
//  BBQ
//
//  Created by icarus on 15/9/6.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SendStatus : UIView<UITextViewDelegate>
{
    UILabel * label;
}


@property (nonatomic,strong) UITextView *statusTV;

-(instancetype)initWithFrame:(CGRect)frame Imgae:(NSArray*)imageArray;
@end
