//
//  ChooseImageViewController.h
//  BBQ
//
//  Created by icarus on 15/8/31.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "RecordCollectionViewCell.h"
#import "tabViewController.h"
#import "ChooseImageNumView.h"



@interface ChooseImageViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView * _collectionView;
    NSMutableArray * _imagesArray;
    NSMutableArray * _selectImageUrlArray;
    ChooseImageNumView * _numView;
    UIButton * _finishBtn;
}

-(void)getImageFromDevice;

@end
