//
//  ChangePassViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/31.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ChangePassViewController.h"

@interface ChangePassViewController ()

@property (weak, nonatomic) IBOutlet UITextField *PhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *PassCodeText;
@property (weak, nonatomic) IBOutlet UITextField *NewPassWprdText;
@property (weak, nonatomic) IBOutlet UIButton *SendButton;
@property (strong, nonatomic) NSTimer *timer;



@end

@implementation ChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机";
    // Do any additional setup after loading the view from its nib.
}
///定时器方法的实现, 倒计时开始
static NSInteger count = 0;
- (void)countdownTime:(NSTimer *)timer {
    count--;
    [_SendButton setTitle:[NSString stringWithFormat:@"(%ld)重新获取", (long)count] forState:UIControlStateNormal];
    //    _getCode.backgroundColor = [UIColor lightGrayColor];
    if (count == 0) {
        [self.timer invalidate];
        [_SendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _SendButton.enabled = YES;
    }
}
- (IBAction)requestBtnClick:(id)sender {
    [self checkCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendBtnClick:(id)sender {
    [self requestData];
}
#pragma mark - 请求数据
//请求数据,获取验证码
- (void)requestData {
    NSString *URLstring = [NSString stringWithFormat:@"%@/get-code",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html",  @"text/json",@"text/JavaScript", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.PhoneTextField.text forKey:@"phone"];
    [parameters setValue:@"apppwd" forKey:@"type"];
    //post请求
    [manager POST:URLstring parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求成功后，返回 responseObject 结果集
        MyLog(@"%@",responseObject);
        [self.timer invalidate];//在创建新的定时器之前,需要将之前的定时器置为无效
        count = 60;
        _SendButton.enabled = NO;
        //创建定时器对象
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownTime:) userInfo:nil repeats:YES];
        [self.PassCodeText becomeFirstResponder];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"%@",error);
        [MBProgressHUD showText:@"请求失败"];
    }];
    
    
    
}
#pragma mark - 请求数据
//验证验证码
- (void)checkCode {
    NSString *URLstring = [NSString stringWithFormat:@"%@/check-code",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html",  @"text/json",@"text/JavaScript", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.PhoneTextField.text forKey:@"phone"];
    [parameters setValue:@"apppwd" forKey:@"type"];
    [parameters setValue:self.PassCodeText.text forKey:@"code"];
    
    //post请求
    [manager POST:URLstring parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        [self requestPassWord];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求成功后，返回 responseObject 结果集
        MyLog(@"验证验证码%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"%@",error);
        [MBProgressHUD showText:@"验证码错误"];
    }];
    
    
    
}
#pragma mark - 验证账号密码
//验证账号密码
- (void)requestPassWord {
    NSString *URL = [NSString stringWithFormat:@"%@/up-appphone",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if ([type isEqualToString:@"学生"]) {
//        [parameters setValue:@"appstu" forKey:@"type"];
        [manager.requestSerializer  setValue:@"appstu" forHTTPHeaderField:@"type"];
    }else if([type isEqualToString:@"家长"]){
//        [parameters setValue:@"appfamily" forKey:@"type"];
        [manager.requestSerializer  setValue:@"appfamily" forHTTPHeaderField:@"type"];
    }else{
//        [parameters setValue:@"teacher" forKey:@"type"];
    }
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];

    [parameters setValue:self.PhoneTextField.text forKey:@"phone"];
//    [parameters setValue:self.userNameText.text forKey:@"username"];
    [parameters setValue:self.NewPassWprdText.text forKey:@"pwd"];
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"正确%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            [MBProgressHUD showText:@"设置成功"];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
