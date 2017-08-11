//
//  NewPassViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/24.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "NewPassViewController.h"

@interface NewPassViewController ()
@property (weak, nonatomic) IBOutlet UITextField *NewPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfIELD;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

@implementation NewPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sendbTNcLICK:(id)sender {
//    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma textField delegate
//限制输入字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.codeTextField) {
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
    NSString *URLstring = [NSString stringWithFormat:@"%@/xapi/get-code",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html",  @"text/json",@"text/JavaScript", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //    [parameters setValue:self.telNum forKey:@"phone"];
    
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
        [self.codeTextField becomeFirstResponder];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"%@",error);
        [MBProgressHUD showText:@"请求失败"];
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
