//
//  SingleInfoTableViewCell.m
//  BBQ
//
//  Created by icarus on 15/9/8.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "SingleInfoTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>


@implementation SingleInfoTableViewCell
@synthesize day,month,author,location,textDescription;
@synthesize delegate;


- (void)awakeFromNib {
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)str frame:(CGRect)frame {
    self =[super initWithStyle:style reuseIdentifier:str];
    if (self) {
        [self setFrame:CGRectMake(0, 0, frame.size.width, 60)];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

-(CGSize)getImageSize:(NSString* )urlstr
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    __block CGSize size;
    NSURL *imageurl = [NSURL URLWithString:urlstr];
    [library assetForURL:imageurl resultBlock:^(ALAsset* asset){
         size = [asset defaultRepresentation].dimensions;
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    return size;
}

-(void)setImageViewContent:(TreeImageView*)imageview url:(NSString*)urlstr
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    NSURL *imageurl = [NSURL URLWithString:urlstr];
    [library assetForURL:imageurl resultBlock:^(ALAsset* asset){
        UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
        imageview.image = image;
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setcontent:(NSDictionary *)dic frame:(CGRect)frame
{
    NSArray * imageIDArray= [(NSString*)[dic objectForKey:@"objectList"] componentsSeparatedByString:@"#"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[dic objectForKey:@"publishTime"]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit |NSWeekdayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    
    
    day =[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 30, 25)];
    day.textColor = [UIColor redColor];
    day.font = [UIFont systemFontOfSize:25.0f];
    day.textAlignment =  NSTextAlignmentRight;
    day.text = [NSString stringWithFormat:@"%ld",(long)[comps day]];
    month =[[UILabel alloc] initWithFrame:CGRectMake(32, 13, 30, 15)];
    month.font =[UIFont systemFontOfSize:15.0f];
    month.textColor = [UIColor blackColor];
    month.textAlignment =NSTextAlignmentCenter;
    month.text = [[NSString stringWithFormat:@"%ld",(long)[comps month]] stringByAppendingString:@"月"];
    [self addSubview:day];
    [self addSubview:month];
    
    if ([dic objectForKey:@"userID"]!=nil) {
        author =[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 70, 13)];
        author.font =[UIFont systemFontOfSize:13.0f];
        author.textAlignment =NSTextAlignmentCenter;
        author.text = [dic objectForKey:@"userID"];
        [self addSubview:author];
    }
    if ([dic objectForKey:@"userLocation"]!=nil) {
        location =[[UILabel alloc] initWithFrame:CGRectMake(10, 43, 50, 15)];
    }
    
    CGFloat wordsHeight = 5.0f;
    if ([dic objectForKey:@"words"]!=nil&&![[dic objectForKey:@"words"] isEqualToString:@""]) {
        textDescription = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, frame.size.width-90, 0)];
        [textDescription setNumberOfLines:0];
        textDescription.font =[UIFont systemFontOfSize:13.0f];
        [textDescription setBackgroundColor:[UIColor lightGrayColor]];
        CGSize size = CGSizeMake(frame.size.width-90,40);
        CGSize labelsize = [[dic objectForKey:@"words"] sizeWithFont:textDescription.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        [textDescription setFrame:CGRectMake(90, 5, frame.size.width-90, labelsize.height)];
        textDescription.textAlignment =NSTextAlignmentLeft;
        textDescription.text = [dic objectForKey:@"words"];
        wordsHeight = textDescription.frame.size.height+10.0f;
        [self addSubview:textDescription];
    }
    
    if([imageIDArray count]>0 )
    {
        [self setFrame:CGRectMake(0, 0, frame.size.width, wordsHeight+80*(NSInteger)(([imageIDArray count]-1)/3+1))];
        for (int i=0;i<[imageIDArray count]; i++) {
            TreeImageView *imageview = [[TreeImageView alloc] initWithFrame:CGRectMake(90+(NSInteger)(i%3)*80, 80*(NSInteger)(i/3)+wordsHeight, 75, 75)];
            imageview.tag =i+1;
            imageview.delegate =self;
            imageview.index =i;
            imageview.array =imageIDArray;
            NSDictionary *dic_imageinfo =[[FMDBModel sharedFMDBModel] getImageInfoByObjectID:[[imageIDArray objectAtIndex:i] integerValue]];
            [self setImageViewContent:imageview url:[dic_imageinfo objectForKey:@"objectUrl"]];
            [self addSubview:imageview];
        }
    }
}

-(void)selectdImage:(NSInteger)index dic:(NSArray *)array{
    if ([delegate respondsToSelector:@selector(selectImage:array:)]) {
        [delegate selectImage:index array:array];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
