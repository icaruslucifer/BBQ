//
//  GTreeViewController.m
//  BBQ
//
//  Created by icarus on 15/8/6.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "GTreeViewController.h"
#import "ChildView.h"
#import "FMDBModel.h"
#import "SingleInfoTableViewCell.h"
#import "EGORefreshTableHeaderView.h"
#import "ShowImage.h"
#import "QiniuToken.h"
#include <objc/runtime.h>

@interface GTreeViewController ()<EGORefreshTableHeaderDelegate,SingleInfoTableViewCellDelegate>
{
    EGORefreshTableHeaderView * _refreshHeaderView;
}

@end

@implementation GTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
    self.title =@"成长树";
    ChildView * childView =[[ChildView alloc] initWithChildInfo:@"42000420150220"];
    
    objc_property_attribute_t type = {"T", "@\"NSString\""};
    objc_property_attribute_t ownership = { "C", "" };
    objc_property_attribute_t backingivar = { "V", "_ivar1"};
    objc_property_attribute_t attrs[] = {type, ownership, backingivar};
    class_addProperty([ChildView class], "test", attrs, 3);
    
    
    
    unsigned int count = 0;
    objc_property_t  * ivar = class_copyPropertyList([ChildView class], &count);
    for (int i=0; i<count; i++) {
        objc_property_t var = ivar[i];
        NSLog(@"%s------%s",property_getName(var),property_getAttributes(var));
        
    }
    
    [[FMDBModel sharedFMDBModel] setCurrrentChildID:@"42000420150220"];
    
    UILabel* view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    [view setTextColor:[UIColor lightGrayColor]];
    [view setTextAlignment:NSTextAlignmentCenter];
    [view setText:@"上拉加载更多.."];
    //[view setHidden:YES];
    

    
    _tableview =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] currentMode].size.width/2, [[UIScreen mainScreen] currentMode].size.height/2-49-64)];
    _tableview.dataSource=self;
    _tableview.delegate =self;
    
    
    _tableview.tableHeaderView =childView;
    _tableview.tableFooterView =view;
    
    
    if (_refreshHeaderView==nil) {
        EGORefreshTableHeaderView *view  =[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -65, self.view.bounds.size.width, 65)];
        view.delegate =self;
        [view setBackgroundColor:[UIColor clearColor]];
        [_tableview addSubview:view];
        _refreshHeaderView =view;
    }
    
    _gtreeArray =[[FMDBModel sharedFMDBModel] getGTreeInfo:[FMDBModel sharedFMDBModel].startIndex endIndex:[FMDBModel sharedFMDBModel].endIndex];
    if ([_gtreeArray count]<5) {
        [FMDBModel sharedFMDBModel].endIndex =[_gtreeArray count];
    }
    [self.view addSubview:_tableview];
    
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

#pragma mark -tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_gtreeArray ==nil) {
        return 0;
    }
    return [_gtreeArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString*  str = @"infocell";
    
    SingleInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (cell == nil) {
        cell = [[SingleInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell" frame:self.view.frame];
        [cell setcontent:[_gtreeArray objectAtIndex:[indexPath row]] frame:self.view.frame];
        cell.delegate=self;
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SingleInfoTableViewCell *cell =(SingleInfoTableViewCell*)[self tableView:_tableview cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(void)selectImage:(NSInteger)index array:(NSArray *)array{
    NSLog(@"%ld",(long)index);
    ShowImage *showimage = [[ShowImage alloc] init];
    showimage.index =index;
    showimage.array =array;
    [self presentViewController:showimage animated:YES completion:^{
        
    }];
    
}

#pragma mark -EGO

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView ==_tableview) {
        [_refreshHeaderView egoRefreshScrollViewWillBeginScroll:scrollView];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView ==_tableview) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        if(scrollView.contentOffset.y > scrollView.contentSize.height-self.view.frame.size.height+80){
            if (scrollView == _tableview) {
                UILabel * label = (UILabel*)_tableview.tableFooterView;
                [label setText:@"正在加载..."];
                [self loadMoreData];
            }
        }
    }
}

-(void)loadMoreData
{
    NSArray * array = [[FMDBModel sharedFMDBModel] getGTreeInfo:[FMDBModel sharedFMDBModel].endIndex+1 endIndex:[FMDBModel sharedFMDBModel].endIndex+5];
    if ([array count]>0) {
        [_gtreeArray addObjectsFromArray:array];
        [_tableview reloadData];
        [FMDBModel sharedFMDBModel].endIndex +=[array count];
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView==_tableview) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

//下拉刷新
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    if (view==_refreshHeaderView) {
        [self performSelector:@selector(doneLoadingTableViewData:) withObject:_refreshHeaderView afterDelay:1];
        NSNumber* num = [NSNumber numberWithInt:0];
        if ([_gtreeArray count]>0) {
            num =[[_gtreeArray objectAtIndex:0] objectForKey:@"gtreeID"];
        }
        
        NSInteger lastindex = [num integerValue];
        NSArray * newArray = [[FMDBModel sharedFMDBModel] getNewGTreeInfo:lastindex];
        if ([newArray count]>0) {
            for (int i=[newArray count]-1; i>=0; i--) {
                [_gtreeArray insertObject:[newArray objectAtIndex:i] atIndex:0];
            }
            [FMDBModel sharedFMDBModel].endIndex +=[newArray count];
            [_tableview reloadData];
        }
        
    }
}

//刷新完成时候调用
- (void)doneLoadingTableViewData:(EGORefreshTableHeaderView*)view{
    NSLog(@"doneLoadingTableViewData");
    //NSLog(@"end Refresh");
    //  model should call this when its done loading
    if (view == _refreshHeaderView) {
        
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableview];
        
    }
}


@end
