//
//  StuMineCenterViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/30.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "StuMineCenterViewController.h"
#import "StudentMineModel.h"
#import "LoginViewController.h"
@interface StuMineCenterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *realationshipLabel;
@property (weak, nonatomic) IBOutlet UILabel *familyTelLabel;
@property (weak, nonatomic) IBOutlet UILabel *familyManLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *telphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (nonatomic,strong) StudentMineModel *studentModel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation StuMineCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.scrollview.frame = CGRectMake(0, 0, KWidth, KHeight);
    self.scrollview.contentSize = CGSizeMake(0, 664);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/me",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    
    [userDefaults synchronize];
    //    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:token forKey:@"token"];
    
    NSLog(@"%@",parameters);
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"获取个人信息正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] !=0) {
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
            if([responseObject[@"content"] isEqual:[NSNull null]])
            {
                
            }else{
                
                NSString *stuname = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"name"]];
                self.nameLabel.text = stuname;
                NSString *username = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"username"]];
                self.userNameLabel.text = username;
                NSNumber *i = responseObject[@"data"][@"student"][@"sex"];
                if ([i integerValue]==1) {
                    self.sexLabel.text = @"男";
                }else{
                    self.sexLabel.text = @"女";
                }
                NSString *grade_name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"student"][@"grade_name"]];
                self.gradeLabel.text = grade_name;
                NSString *classroom_name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"student"][@"classroom_name"]];
                self.classLabel.text = classroom_name;
                NSString *no = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"student"][@"no"]];
                self.studentIDLabel.text = no;
                NSString *birthday = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"student"][@"birthday"]];
                self.birthdayLabel.text = birthday;
                NSString *phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"phone"]];
                self.telphoneLabel.text = phone;
               
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
-(StudentMineModel *)studentModel{
    if (!_studentModel) {
        _studentModel = [[StudentMineModel alloc] init];
    }
    return _studentModel;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
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
