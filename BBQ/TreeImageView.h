//
//  TreeImageView.h
//  BBQ
//
//  Created by icarus on 15/9/9.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TreeImageViewDelegate <NSObject>

-(void)selectdImage:(NSInteger)index dic:(NSArray*)array;

@end

@interface TreeImageView : UIImageView
{
}

@property (nonatomic,strong)id <TreeImageViewDelegate> delegate;
@property (atomic,assign) NSInteger index;
@property (nonatomic,strong) NSArray * array;

-(instancetype)initWithFrame:(CGRect)frame;
@end
