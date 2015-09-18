//
//  tabViewController.m
//  BBQ
//
//  Created by icarus on 15/8/6.
//  Copyright (c) 2015年 icarus. All rights reserved.
//

#import "tabViewController.h"
#import "GTreeViewController.h"
#import "MyViewController.h"
#import "RecordViewController.h"

#import "MyTabBarButton.h"

@interface tabViewController ()

@end

@implementation tabViewController
@synthesize selectedBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //成长树
    GTreeViewController* gTreeViewController = [[GTreeViewController alloc] init];
    UINavigationController * childTreeNav = [[UINavigationController alloc] initWithRootViewController:gTreeViewController];
    childTreeNav.tabBarItem.title =@"成长树";
    childTreeNav.tabBarItem.image = [UIImage imageNamed:@"GTree_normal"];
    childTreeNav.tabBarItem.selectedImage = [UIImage imageNamed:@"GTree_press"];
    
    //我的
    MyViewController * myViewController =[[MyViewController alloc] init];
    UINavigationController * MyNav  = [[UINavigationController alloc] initWithRootViewController:myViewController];
    MyNav.tabBarItem.title =@"我的";
    MyNav.tabBarItem.image = [UIImage imageNamed:@"My_normal"];
    MyNav.tabBarItem.selectedImage = [UIImage imageNamed:@"My_press"];
    
    
    //记录
    RecordViewController * recordViewController =[[RecordViewController alloc] init];
    recordViewController.tabBarItem.image =[UIImage imageNamed:@"Record_normal"];
    UINavigationController * RecordNav  = [[UINavigationController alloc] initWithRootViewController:recordViewController];
    RecordNav.tabBarItem.title =@"记录";
    
    
    
    self.viewControllers = [NSArray arrayWithObjects:childTreeNav,RecordNav,MyNav, nil];
 
    CGRect rect_tabbar = self.tabBar.frame;
    [self.tabBar removeFromSuperview];
    
    for (int i=0; i<3; i++) {
        MyTabBarButton * btn = [MyTabBarButton buttonWithType:UIButtonTypeCustom];
        btn.tag =10000 + 1 +i;
        switch (i) {
            case 0:
                [btn setImage:[UIImage imageNamed:@"GTree_normal"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"GTree_press"] forState:UIControlStateSelected];
                break;
            case 2:
                [btn setImage:[UIImage imageNamed:@"My_normal"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"My_press"] forState:UIControlStateSelected];
                break;
            case 1:
                [btn setImage:[UIImage imageNamed:@"Record_normal"] forState:UIControlStateNormal];
                //[btn setImage:[UIImage imageNamed:@"Record_press"] forState:UIControlStateSelected];
                break;
            default:
                break;
        }
        
        [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        float x = i*rect_tabbar.size.width/3;
        [btn setFrame:CGRectMake(x, rect_tabbar.origin.y, rect_tabbar.size.width/3, rect_tabbar.size.height)];
        [self.view addSubview:btn];
        if (i==0) {
            self.selectedIndex =0;
            self.selectedBtn =btn;
            btn.selected =YES;
        }
    }
}

-(void)selectBtn:(id)sender
{
    self.selectedBtn.selected =NO;
    self.selectedBtn = (UIButton *)sender;
    selectedBtn.selected =YES;
    self.selectedIndex = selectedBtn.tag -10001;

}

-(void)setMyHide:(BOOL)hide{
    for (int i=0; i<[self.view subviews].count; i++) {
        if ([[[self.view subviews] objectAtIndex:i] isKindOfClass:[MyTabBarButton class]]) {
            MyTabBarButton *btn = (MyTabBarButton*)[self.view.subviews objectAtIndex:i];
            [btn setHidden:hide];
        }
    }
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
