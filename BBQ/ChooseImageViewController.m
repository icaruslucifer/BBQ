//
//  ChooseImageViewController.m
//  BBQ
//
//  Created by icarus on 15/8/31.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "ChooseImageViewController.h"
#import "SendStatusViewController.h"
#import "RecordViewController.h"

@interface ChooseImageViewController ()

@end

@implementation ChooseImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"所有照片";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBtnItemClick)];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc ]init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-30) collectionViewLayout:flowLayout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    _collectionView.delegate =self;
    _collectionView.dataSource =self;
    [_collectionView registerClass:[RecordCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoImageCell"];
    [self.view addSubview:_collectionView];
    [self getImageFromDevice];
    _selectImageUrlArray =[[NSMutableArray alloc] init];
    
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-30, self.view.frame.size.width, 30)];
    [buttonView setBackgroundColor:AllGray];
    [self.view addSubview:buttonView];
    _numView = [[ChooseImageNumView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-90, 2, 26, 26)];
    [_numView setHidden:YES];
    [buttonView addSubview:_numView];
    _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_finishBtn setFrame:CGRectMake(self.view.frame.size.width-60,4, 48, 22)];
    [_finishBtn setBackgroundColor:AllGreen];
    [_finishBtn.layer setCornerRadius:3.0f];
    [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_finishBtn setHidden:YES];
    [_finishBtn addTarget:self action:@selector(GotoPublishStatus:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:_finishBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    tabViewController *tabbarcontroller = (tabViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarcontroller setMyHide:YES];
     
}

-(void)viewWillDisappear:(BOOL)animated
{
    tabViewController *tabbarcontroller = (tabViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarcontroller setMyHide:NO];

}

-(void)getImageFromDevice
{
    _imagesArray = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        ALAssetsGroupEnumerationResultsBlock groupEnumerAction = ^(ALAsset *result,NSUInteger index,BOOL * stop){
            if (result !=NULL) {
                NSString * imageurl = [NSString stringWithFormat:@"%@",result.defaultRepresentation.url];
                NSDate *createTime = [result valueForProperty:ALAssetPropertyDate];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:imageurl forKey:@"imageurl"];
                [dict setValue:[dateFormatter stringFromDate:createTime] forKey:@"createtime"];
                [_imagesArray addObject:dict];
                [_collectionView reloadData];
            }
        };
        ALAssetsLibraryAccessFailureBlock failtureBlock = ^(NSError *error){
            NSLog(@"获取相册照片失败！%@",error);
        };
        ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupEnumerAction =^(ALAssetsGroup *group,BOOL *stop)
        {
            if (group!=nil) {
                [group enumerateAssetsUsingBlock:groupEnumerAction];
            }
            else{
                NSLog(@"获取相册照片失败2！");
            }
        };
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:libraryGroupEnumerAction failureBlock:failtureBlock];
        
    });
    
}


#pragma mark - CollectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imagesArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.view.frame.size.width-PADDING_IMAGE*(NUMSOFCELL+1))/NUMSOFCELL, (self.view.frame.size.width-PADDING_IMAGE*(NUMSOFCELL+1))/NUMSOFCELL);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(PADDING_IMAGE, PADDING_IMAGE, PADDING_IMAGE, PADDING_IMAGE);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return PADDING_IMAGE;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return PADDING_IMAGE;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"PhotoImageCell";
    RecordCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    NSURL *imageurl = [NSURL URLWithString:[[_imagesArray objectAtIndex:[indexPath row]] objectForKey:@"imageurl"]];
    UIImageView * imageview  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    imageview.tag = 20000+[indexPath row];
    [library assetForURL:imageurl resultBlock:^(ALAsset* asset){
        UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
        imageview.image = image;
        } failureBlock:^(NSError *error) {
            NSLog(@"%@",error);
        }];

    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setFrame:CGRectMake(cell.frame.size.width-30, cell.frame.size.width-30, 25, 25)];
    [selectBtn setImage:[UIImage imageNamed:@"NoSelectedImage"] forState:UIControlStateNormal];
    [selectBtn setHighlighted:NO];
    selectBtn.userInteractionEnabled = NO;
    selectBtn.tag = 30000+[indexPath row];
    
    //判断
    if ([_selectImageUrlArray containsObject:[_imagesArray objectAtIndex:[indexPath row]]]) {
        [imageview setAlpha:0.5f];
        [selectBtn setImage:[UIImage imageNamed:@"SelectedImage"] forState:UIControlStateNormal];
    }
    else
    {
        [imageview setAlpha:1.0f];
        [selectBtn setImage:[UIImage imageNamed:@"NoSelectedImage"] forState:UIControlStateNormal];
    }
    for (id subview in cell.subviews) {
        [subview removeFromSuperview];
    }
    
    [cell addSubview:imageview];
    [cell addSubview:selectBtn];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_selectImageUrlArray count] >=6 && ![_selectImageUrlArray containsObject:[_imagesArray objectAtIndex:[indexPath row]]]) {
        UIAlertView *alertview =[[UIAlertView alloc] initWithTitle:@"提示" message:@"最多选择9张图片。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertview show];
    }
    else
    {
        RecordCollectionViewCell * cell = (RecordCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        UIImageView *imageview =(UIImageView *)[cell viewWithTag:20000+[indexPath row]];
        UIButton *btn =(UIButton *)[cell viewWithTag:30000+[indexPath row]];
        if (imageview.alpha<1) {
            [imageview setAlpha:1];
            [btn setImage:[UIImage imageNamed:@"NoSelectedImage"] forState:UIControlStateNormal];
            [_selectImageUrlArray removeObject:[_imagesArray objectAtIndex:[indexPath row]]];
        }
        else{
            [imageview setAlpha:0.5];
            [btn setImage:[UIImage imageNamed:@"SelectedImage"] forState:UIControlStateNormal];
            [_selectImageUrlArray addObject:[_imagesArray objectAtIndex:[indexPath row]]];
        }
        if ([_selectImageUrlArray count]==0) {
            if (!_numView.isHidden) {
                [_numView setHidden:YES];
            }
            if (!_finishBtn.isHidden) {
                [_finishBtn setHidden:YES];
            }
        }
        else{
            if (_numView.isHidden) {
                [_numView setHidden:NO];
            }
            if (_finishBtn.isHidden) {
                [_finishBtn setHidden:NO];
            }
            [_numView setAnimation:[_selectImageUrlArray count]];
        }
    }
    
}


#pragma mark - Navigation
-(void)rightBtnItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -qita

-(void)GotoPublishStatus:(id)sender
{
    SendStatusViewController * senderStatusViewController = [[SendStatusViewController alloc] init];
    senderStatusViewController.s_imageUrlArray = _selectImageUrlArray;
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:senderStatusViewController animated:YES];
}




#pragma mark -didReceiveMemoryWarning
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
