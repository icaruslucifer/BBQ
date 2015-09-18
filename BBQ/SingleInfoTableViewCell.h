//
//  SingleInfoTableViewCell.h
//  BBQ
//
//  Created by icarus on 15/9/8.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDBModel.h"
#import "TreeImageView.h"

@protocol SingleInfoTableViewCellDelegate <NSObject>

-(void)selectImage:(NSInteger)index array:(NSArray*)array;

@end

@interface SingleInfoTableViewCell : UITableViewCell<TreeImageViewDelegate>



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)str frame:(CGRect)frame ;

@property(nonatomic,strong) UILabel * month;
@property(nonatomic,strong) UILabel * day;
@property(nonatomic,strong) UILabel * author;
@property(nonatomic,strong) UILabel * location;
@property(nonatomic,strong) UILabel * textDescription;
@property (nonatomic,strong) id<SingleInfoTableViewCellDelegate> delegate;


-(CGSize)getImageSize:(NSString* )urlstr;
-(void)setImageViewContent:(UIImageView*)imageview url:(NSString*)urlstr;

-(void)setcontent:(NSDictionary*)dic frame:(CGRect)frame;
@end
