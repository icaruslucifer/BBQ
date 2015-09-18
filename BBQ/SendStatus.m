//
//  SendStatus.m
//  BBQ
//
//  Created by icarus on 15/9/6.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "SendStatus.h"

@implementation SendStatus

@synthesize statusTV;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame Imgae:(NSArray*)imageArray
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat cellWidth = frame.size.width/4;
        if ([imageArray count]>4) {
            [self setFrame:CGRectMake(0, frame.origin.y, frame.size.width, 110+cellWidth)];
        }
        else{
            [self setFrame:CGRectMake(0,frame.origin.y, frame.size.width, 105+cellWidth)];
        }
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setFont:[UIFont systemFontOfSize:18.0f]];
        label.text =@"此时此刻，文字和图片更配哦！";
        label.textColor=[UIColor lightGrayColor];
        
        statusTV = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
        [statusTV setFont:[UIFont systemFontOfSize:18.0f]];
        statusTV.editable =YES;
        statusTV.delegate =self;
        statusTV.text =@"";
        statusTV.textColor = [UIColor lightGrayColor];
        //statusTV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleBottomMargin;
        
        //statusTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [statusTV setBackgroundColor:AllGray];
        [self addSubview:statusTV];
        [self addSubview:label];
        
        //[statusTV becomeFirstResponder];
        
        for (int i=0;i<[imageArray count]; i++) {
            UIImageView *imageview =[[UIImageView alloc] initWithFrame:CGRectMake(5+(i%4)*cellWidth, (NSInteger)(i/4)*cellWidth+110, cellWidth-10, cellWidth-10)];
            [self setImage:[[imageArray objectAtIndex:i] objectForKey:@"imageurl"] ImageView:imageview];
            [self addSubview:imageview];
        }
    }
    return self;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [label setHidden:YES];
    textView.text=@"";
    textView.textColor=[UIColor blackColor];
    //[textView becomeFirstResponder];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        [label setHidden:NO];
    }
    else{
        [label setHidden:YES];
    }
}


-(void)setImage:(NSString *)strURL ImageView:(UIImageView*)imageview
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSURL *imageurl = [NSURL URLWithString:strURL];
    [library assetForURL:imageurl resultBlock:^(ALAsset* asset){
        UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
        imageview.image = image;
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
