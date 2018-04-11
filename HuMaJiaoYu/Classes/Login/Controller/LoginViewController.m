//
//  LoginViewController.m
//  HuMaProject
//
//  Created by Zhouhoo on 2017/4/26.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"
#import "PopUpView.h"
#import "PopModel.h"
#import "Header.h"
//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface LoginViewController ()<UITextFieldDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *PassNameText;
@property (weak, nonatomic) IBOutlet UITextField *PassWordText;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIButton *selectbtn;
@property (nonatomic, strong) PopUpView *showView;

@end

@implementation LoginViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES ];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIApplication *app =[UIApplication sharedApplication];
//    AppDelegate *app2 = app.delegate;
//    app2.window.rootViewController = self;
    [self setSelect];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setSelect{
    self.dataArr = [NSMutableArray array];
    NSArray *arr = @[@{@"name":@"学生"},@{@"name":@"家长"},@{@"name":@"老师"}];
    for (NSDictionary *dic in arr) {
        [_dataArr addObject:[PopModel modelWithdic:dic]];
    }
 
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];

    
}
- (void)tap:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}
- (IBAction)dengluBtnClick:(id)sender {
    [self requestPassWord];
   //    [self goHomeController];

}
- (IBAction)ForgetMimaBtnClick:(id)sender {
    NSLog(@"忘记密码");
    ForgetViewController *vc = [[ForgetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)SelectBtnClick:(id)sender {
    
    UIActionSheet *actionsheet03 = [[UIActionSheet alloc] initWithTitle:@"选择身份" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"学生", @"家长",@"教师",  nil];
    // 显示
    [actionsheet03 showInView:self.view];

}
// UIActionSheetDelegate实现代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex=%ld", buttonIndex);
    
   
        if (0 == buttonIndex)
        {
            NSLog(@"点击了学生按钮");
            [_selectbtn setTitle:@"学生" forState:0];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:@"学生" forKey:@"type"];
            [userDefaults synchronize];
        }
        else if (1 == buttonIndex)
        {
            NSLog(@"点击了家长按钮");
            [_selectbtn setTitle:@"家长" forState:0];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:@"家长" forKey:@"type"];
            [userDefaults synchronize];
        }
        else if (2 == buttonIndex)
        {
            NSLog(@"点击了教师按钮");
            [_selectbtn setTitle:@"教师" forState:0];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:@"教师" forKey:@"type"];
            [userDefaults synchronize];
        }else if (3 == buttonIndex)
        {
            NSLog(@"点击了取消按钮");
        }
    
}
- (IBAction)registerBtnClick:(id)sender {
    NSLog(@"立即注册");
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 验证账号密码
//验证账号密码
- (void)requestPassWord {
    NSString *URL = [NSString stringWithFormat:@"%@/login",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([self.selectbtn.titleLabel.text isEqualToString:@"学生"]) {
        [userDefaults setValue:@"学生" forKey:@"type"];
    }else if([self.selectbtn.titleLabel.text isEqualToString:@"家长"]){
       [userDefaults setValue:@"家长" forKey:@"type"];
    }else{
        [userDefaults setValue:@"教师" forKey:@"type"];
    }
    [parameters setValue:self.PassNameText.text forKey:@"username"];
    [parameters setValue:self.PassWordText.text forKey:@"password"];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *regis = [userDefaults valueForKey:@"registerid"];
    [parameters setValue:regis forKey:@"register_id"];
//     [parameters setValue:@"12312312312312" forKey:@"register_id"];
    NSLog(@"登陆参数:%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"正确%@",responseObject);
        if([responseObject[@"code"] intValue] ==0){
            NSString *token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
            NSString *schoolID = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"me"][@"school_id"]];
            NSString *name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"me"][@"name"]];
            NSString *phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"me"][@"phone"]];
            NSString *username = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"me"][@"username"]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:self.PassWordText.text forKey:@"password"];
            [userDefaults setValue:self.PassNameText.text forKey:@"username"];
            [userDefaults setValue:schoolID forKey:@"schoolID"];
            [userDefaults setValue:token forKey:@"token"];
            [userDefaults setValue:name forKey:@"name"];
            [userDefaults setValue:username forKey:@"username"];
            [userDefaults setValue:phone forKey:@"phone"];
            [userDefaults synchronize];

            [self goHomeController];
                        
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text =responseObject[@"msg"];
            [hud hideAnimated:YES afterDelay:2.f];
//            [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"errorMsg"]]];
//            NSLog(@"%@",responseObject[@"result"][@"errorMsg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
}

- (void)goHomeController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *baseNaviVC = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController =baseNaviVC;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma textField delegate
//限制输入字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    
    if (textField == self.PassNameText) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    } else if (textField == self.PassWordText){
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }
//    return [string isEqualToString:filtered];
    return YES;
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
