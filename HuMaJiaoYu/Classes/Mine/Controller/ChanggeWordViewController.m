//
//  ChanggeWordViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/31.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ChanggeWordViewController.h"

@interface ChanggeWordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *OldWordText;
@property (weak, nonatomic) IBOutlet UITextField *NewWordText;
@property (weak, nonatomic) IBOutlet UITextField *NewWordTextTwo;

@end

@implementation ChanggeWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)requestBtnClick:(id)sender {
    if([self.NewWordText.text isEqualToString:self.NewWordTextTwo.text]){
        [self requestPassWord];
    }else{
        [MBProgressHUD showText:@"两次输入的密码不同"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//验证账号密码
- (void)requestPassWord {
    NSString *URL = [NSString stringWithFormat:@"%@/change-password",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   
    NSString *token = [userDefaults valueForKey:@"token"];
    [parameters setValue:token forKey:@"token"];
    
    [parameters setValue:self.OldWordText.text forKey:@"password"];
    //    [parameters setValue:self.userNameText.text forKey:@"username"];
    [parameters setValue:self.NewWordText.text forKey:@"new_password"];
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"修改密码正确%@",responseObject);
        if([responseObject[@"code"] intValue] ==0){
            [MBProgressHUD showText:@"设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            NSLog(@"%@",responseObject[@"msg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
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
