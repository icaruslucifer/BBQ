//
//  ShowImage.m
//  BBQ
//
//  Created by icarus on 15/9/9.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "ShowImage.h"
#import "FMDBModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ShowImage ()<UIGestureRecognizerDelegate>

@end

@implementation ShowImage
@synthesize scrollview,pageControl,index,array;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    CGFloat width = self.view.frame.size.width;
    // Do any additional setup after loading the view.
    scrollview = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollview.delegate =self;
    scrollview.userInteractionEnabled =YES;
    scrollview.pagingEnabled =YES;
    scrollview.showsHorizontalScrollIndicator =NO;
    scrollview.showsVerticalScrollIndicator =NO;
    [self.view addSubview:scrollview];
    
    UITapGestureRecognizer* singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollviewClick:)];
    singleTap.numberOfTouchesRequired = 1; //手指数
    singleTap.numberOfTapsRequired = 1; //tap次数
    singleTap.delegate= self;
    [scrollview addGestureRecognizer:singleTap];
    
    pageControl= [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 20)];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor greenColor]];
    [pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
    pageControl.numberOfPages =[array count];
    pageControl.currentPage = index;
    [self.view addSubview:pageControl];
    
    for (int i= 0; i<[array count]; i++) {
        NSDictionary *dic_imageinfo =[[FMDBModel sharedFMDBModel] getImageInfoByObjectID:[[array objectAtIndex:i] integerValue]];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(width*i, (self.view.frame.size.height-width)/2, width, width)];
        [self setImageViewContent:imageview url:[dic_imageinfo objectForKey:@"objectUrl"]];
        [scrollview addSubview:imageview];
    }
    [scrollview setContentSize:CGSizeMake(width*[array count], self.view.frame.size.height)];
    [scrollview setContentOffset:CGPointMake(width*index, 0)];
    [scrollview scrollRectToVisible:CGRectMake(width*index, 0, width, self.view.frame.size.height) animated:NO];
}


-(void)setImageViewContent:(UIImageView*)imageview url:(NSString*)urlstr
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    NSURL *imageurl = [NSURL URLWithString:urlstr];
    [library assetForURL:imageurl resultBlock:^(ALAsset* asset){
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        CGSize s = [asset defaultRepresentation].dimensions;
        CGFloat height = s.height/s.width*imageview.frame.size.width;
        [imageview setFrame:CGRectMake(imageview.frame.origin.x, (self.view.frame.size.height-height)/2, imageview.frame.size.width, height)];
        imageview.image = image;
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width =scrollview.frame.size.width;
    CGFloat page = pageControl.currentPage;
    if ((scrollview.contentOffset.x/width -page)>=0.5) {
        page++;
    }
    else if((scrollview.contentOffset.x/width -page)<=-0.5){
        page--;
    }
    pageControl.currentPage =page;
    
}

-(void)scrollviewClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
