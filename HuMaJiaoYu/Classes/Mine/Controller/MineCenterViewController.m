//
//  MineCenterViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/25.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "MineCenterViewController.h"
#import "FamilyMineModel.h"
#import "LoginViewController.h"
@interface MineCenterViewController ()
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *familyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentID;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *realitionLabel;
@property (nonatomic,strong)FamilyMineModel *familyMineModel;
@end

@implementation MineCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号中心";
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    NSString *URL = [[NSString alloc] init];
//    if([type isEqualToString:@"学生"]){
//        URL = [NSString stringWithFormat:@"%@/select-stuinfo",kUrl];
//    }else if([type isEqualToString:@"家长"]){
        URL = [NSString stringWithFormat:@"%@/select-familyinfo",kUrl];
//    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *page = [NSString new];
//    if([type isEqualToString:@"学生"]){
//        page = @"appstu";
//        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
//    }else if([type isEqualToString:@"家长"]){
        page = @"appfamily";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
//    }else{
//        page = @"appteacher";
//        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
//    }
    
    //    [parameters setValue:page forKey:@"type"];
    
//    NSLog(@"%@",parameters);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"获取个人信息正确%@",responseObject);


            if ([responseObject[@"result"][@"success"] intValue] ==0) {
                NSNumber *code = responseObject[@"result"][@"errorCode"];
                NSString *errorcode = [NSString stringWithFormat:@"%@",code];
                if ([errorcode isEqualToString:@"4200"])  {
                    [MBProgressHUD showText:@"请重新登陆"];
                    [self newLogin];
                }else{
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
                }
            }else{
                if([type isEqualToString:@"学生"]){
                    for (NSDictionary *dic in responseObject[@"content"]) {
                        _familyMineModel = [[FamilyMineModel alloc] initWithDictionary:dic];
                        [self.dataArray addObject:_familyMineModel];
                    }
                    self.userNameLabel.text = self.familyMineModel.username;
                    self.familyNameLabel.text = _familyMineModel.family_name;
                    self.phoneLabel.text = _familyMineModel.tel;
                    NSArray *dic = _familyMineModel.has_many_stu;
                    NSLog(@"%@",dic);
                    self.studentID.text = dic[0][@"stu_id"];
                    self.realitionLabel.text = dic[0][@"relationship"];
                }else if([type isEqualToString:@"家长"]){
                    for (NSDictionary *dic in responseObject[@"content"]) {
                        _familyMineModel = [[FamilyMineModel alloc] initWithDictionary:dic];
                        [self.dataArray addObject:_familyMineModel];
                    }
                    self.userNameLabel.text = self.familyMineModel.username;
                    self.familyNameLabel.text = _familyMineModel.family_name;
                    self.phoneLabel.text = _familyMineModel.tel;
                    NSArray *dic = _familyMineModel.has_many_stu;
                    NSLog(@"%@",dic);
                    NSString *stuID =dic[0][@"stu_id"];
                    NSString *relationship =dic[0][@"relationship"];
                    if (![stuID.class isEqual:[NSNull class]]) {
                        self.studentID.text = dic[0][@"stu_id"];
                    }
                    if (![relationship.class isEqual:[NSNull class]]) {
                        self.realitionLabel.text = dic[0][@"relationship"];
                    }
                }

                
    
            }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

-(FamilyMineModel *)familyMineModel{
    if (!_familyMineModel) {
        _familyMineModel = [[FamilyMineModel alloc] init];
    }
    return _familyMineModel;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}
- (void)newLogin{
    [MBProgressHUD showText:@"请重新登录"];
    [self performSelector:@selector(backTo) withObject: nil afterDelay:2.0f];
}
-(void)backTo{
    [self clearLocalData];
    LoginViewController *VC =[[LoginViewController alloc] init];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)clearLocalData{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:nil forKey:@"phone"];
    [userDefaults setValue:nil forKey:@"passWord"];
    [userDefaults setValue:nil forKey:@"token"];
    [userDefaults setValue:nil forKey:@"registerid"];
    [userDefaults synchronize];
    
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
