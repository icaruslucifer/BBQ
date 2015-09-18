//
//  ShowImage.h
//  BBQ
//
//  Created by icarus on 15/9/9.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImage : UIViewController<UIScrollViewDelegate>
{
    
}

@property (nonatomic,strong)UIScrollView * scrollview;
@property (nonatomic,strong)UIPageControl * pageControl;
@property (assign,atomic)NSInteger index;
@property (nonatomic,strong)NSArray * array;

@end
