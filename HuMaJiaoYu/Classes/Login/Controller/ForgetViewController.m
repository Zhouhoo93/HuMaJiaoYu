//
//  ForgetViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/24.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ForgetViewController.h"
#import "AppDelegate.h"
#import "PopUpView.h"
#import "PopModel.h"
#import "Header.h"
@interface ForgetViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectbtn;
@property (weak, nonatomic) IBOutlet UITextField *twoPassWordTextField;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) PopUpView *showView;



@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSelect];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)commitBtnClick:(id)sender {
    [self checkCode];
}
- (IBAction)sendPassBtnClick:(id)sender {
    
    [self requestData];
}
///定时器方法的实现, 倒计时开始
static NSInteger count = 0;
- (void)countdownTime:(NSTimer *)timer {
    count--;
    [self.sendBtn setTitle:[NSString stringWithFormat:@"(%ld)重新获取", (long)count] forState:UIControlStateNormal];
    //    _getCode.backgroundColor = [UIColor lightGrayColor];
    if (count == 0) {
        [self.timer invalidate];
        [_sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _sendBtn.enabled = YES;
    }
}
- (IBAction)selectBtnClick:(id)sender {
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
    }
    else if (1 == buttonIndex)
    {
        NSLog(@"点击了家长按钮");
        [_selectbtn setTitle:@"家长" forState:0];
    }
    else if (2 == buttonIndex)
    {
        NSLog(@"点击了教师按钮");
        [_selectbtn setTitle:@"教师" forState:0];
    }else if (3 == buttonIndex)
    {
        NSLog(@"点击了取消按钮");
    }
    
}

#pragma textField delegate
//限制输入字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.codeText) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
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
    [parameters setValue:self.phoneNumText.text forKey:@"phone"];
    [parameters setValue:@"apppwd" forKey:@"type"];
    //post请求
    [manager POST:URLstring parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求成功后，返回 responseObject 结果集
        MyLog(@"%@",responseObject);
        [self.timer invalidate];//在创建新的定时器之前,需要将之前的定时器置为无效
        count = 60;
        self.sendBtn.enabled = NO;
        //创建定时器对象
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownTime:) userInfo:nil repeats:YES];
        [self.codeText becomeFirstResponder];
        
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
    [parameters setValue:self.phoneNumText.text forKey:@"phone"];
    [parameters setValue:@"apppwd" forKey:@"type"];
    [parameters setValue:self.codeText.text forKey:@"code"];
    //post请求
    [manager POST:URLstring parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        [self requestPassWord];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求成功后，返回 responseObject 结果集
        MyLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"%@",error);
        [MBProgressHUD showText:@"验证码错误"];
    }];
    
    
    
}

#pragma mark - 验证账号密码
//验证账号密码
- (void)requestPassWord {
    NSString *URL = [NSString stringWithFormat:@"%@/app-pwd",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([self.selectbtn.titleLabel.text isEqualToString:@"学生"]) {
        [parameters setValue:@"students" forKey:@"type"];
    }else if([self.selectbtn.titleLabel.text isEqualToString:@"家长"]){
        [parameters setValue:@"family" forKey:@"type"];
    }else{
        [parameters setValue:@"teacher" forKey:@"type"];
    }
    [parameters setValue:self.phoneNumText.text forKey:@"tel"];
    [parameters setValue:self.userNameText.text forKey:@"username"];
    [parameters setValue:self.passWordTextField.text forKey:@"pwd"];
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

- (void)goHomeController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *baseNaviVC = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController =baseNaviVC;
    
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
