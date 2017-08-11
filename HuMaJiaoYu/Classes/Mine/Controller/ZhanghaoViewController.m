//
//  ZhanghaoViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/31.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ZhanghaoViewController.h"
#import "ChangePassViewController.h"
#import "ChanggeWordViewController.h"
#import "LoginViewController.h"
@interface ZhanghaoViewController ()

@end

@implementation ZhanghaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (IBAction)ChangePassWordBtnClick:(id)sender {
    ChanggeWordViewController *vc = [[ChanggeWordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)changgePhoneBtnClick:(id)sender {
    ChangePassViewController *vc = [[ChangePassViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
