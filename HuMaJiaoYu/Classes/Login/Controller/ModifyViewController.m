//
//  ModifyViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/20.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "ModifyViewController.h"

@interface ModifyViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;
@property (weak, nonatomic) IBOutlet UITextField *NewPassWord;
@property (weak, nonatomic) IBOutlet UITextField *NewPassWordTwo;

@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ModifyBtnClick:(id)sender {
    if (_oldPassWord.text.length>0&&_NewPassWord.text.length>0&&_NewPassWordTwo.text.length>0){
        if ([_NewPassWord.text isEqualToString:_NewPassWordTwo.text]) {
            [self requestData];
        }else{
            [MBProgressHUD showText:@"两次新密码输入不一致"];
        }
    }else{
        [MBProgressHUD showText:@"请输入完整"];
    }
    
}

- (void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/app/users/user/change-password",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.oldPassWord.text forKey:@"oldpassword"];
    [parameters setValue:self.NewPassWord.text forKey:@"password"];
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"正确%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            NSLog(@"%@",responseObject);
            [MBProgressHUD showText:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"errorMsg"]]];
            NSLog(@"%@",responseObject[@"result"][@"errorMsg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];

}

- (IBAction)cancelBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidChange:(UITextField *)textField
{
  
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
        }
    
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
