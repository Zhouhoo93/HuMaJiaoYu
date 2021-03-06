//
//  ParentRegisterViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/26.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ParentRegisterViewController.h"
#import "AppDelegate.h"
#import "FSComboListView.h"
#import "JHPickView.h"
#import "GradeModel.h"
#import "ClassModel.h"
#import "LoginViewController.h"
@interface ParentRegisterViewController ()<FSComboPickerViewDelegate,JHPickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *studentTextfield;
@property (nonatomic,strong)UIPickerView *pickView;
@property (nonatomic,strong)UIView *pick;
@property (weak, nonatomic) IBOutlet UIButton *relationshipBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTwoTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *parentNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *studentIDTextField;
@property (weak, nonatomic) IBOutlet UIButton *gradebtn;
@property (weak, nonatomic) IBOutlet UIButton *classBtn;
@property (nonatomic,strong)NSArray *relationshipArr;
@property (assign,nonatomic) NSInteger* selectedIndexPath ;
@property (nonatomic,strong)GradeModel *gradeModel;
@property (nonatomic,strong)NSMutableArray *gradeArr;
@property (nonatomic,copy)NSString *gradeID;
@property (nonatomic,strong)ClassModel *classModel;
@property (nonatomic,strong)NSMutableArray *ClassArr;
@property (nonatomic,copy)NSString *ClassID;
@property (nonatomic,copy)NSString *guanxi;
@end

@implementation ParentRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self requestGrade];
    self.relationshipArr = @[@"父子",@"母子",@"其他"];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)registerBtnClick:(id)sender {
//    [self goHomeController];
    [self requestPassWord];
}
- (IBAction)relationshipBtnClick:(id)sender {
    [self setPick];
}
- (IBAction)gradeBtnClick:(id)sender {
    NSMutableArray *gradeArrTwo = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<self.gradeArr.count; i++) {
        self.gradeModel = self.gradeArr[i];
        [gradeArrTwo addObject:self.gradeModel.alias];
    }
    
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.gradeArr = gradeArrTwo;
    picker.delegate = self ;
    picker.arrayType = HeightArray;
    NSLog(@"%@",picker.gradeArr);
    [self.view addSubview:picker];
    self.selectedIndexPath = 1;

}
- (IBAction)classBtnClick:(id)sender {
    NSMutableArray *gradeArrThree = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<self.ClassArr.count; i++) {
        self.classModel = self.ClassArr[i];
        [gradeArrThree addObject:self.classModel.alias];
    }
    
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.classArr = gradeArrThree;
    picker.delegate = self ;
    picker.arrayType = weightArray;
    [self.view addSubview:picker];
    self.selectedIndexPath = 2;

}
#pragma mark - JHPickerDelegate

-(void)PickerSelectorIndixString:(NSString *)str:(NSInteger)row
{
    
    
    if (self.selectedIndexPath==0) {
        [self.relationshipBtn setTitle:str forState:UIControlStateNormal];
        if ([str isEqualToString:@"父子"]) {
            self.guanxi = @"1";
        }else if ([str isEqualToString:@"母子"]) {
            self.guanxi = @"2";
        }else{
            self.guanxi = @"3";
        }
    }else if (self.selectedIndexPath==1) {
        [self.gradebtn setTitle:str forState:UIControlStateNormal];
        _gradeModel = _gradeArr[row];
        self.gradeID = _gradeModel.ID;
        //        [self requestClass];
        for (NSDictionary *goodsDic in self.gradeModel.classrooms) {
            self.classModel =[[ClassModel alloc] initWithDictionary:goodsDic];
            [self.ClassArr addObject:self.classModel];
        }
    }else if (self.selectedIndexPath==2) {
        [self.classBtn setTitle:str forState:UIControlStateNormal];
        _classModel = _ClassArr[row];
        self.ClassID = _classModel.ID;
    }else if (self.selectedIndexPath==3) {
//        [self.birthdayBtn setTitle:str forState:UIControlStateNormal];
    }
    
    
}

- (void)requestGrade{
    NSString *URL = [NSString stringWithFormat:@"%@/grades",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *schoolID = [ user objectForKey:@"schoolID"];
    [parameters setValue:schoolID forKey:@"school_id"];
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"查询年级正确%@",responseObject);
        if([responseObject[@"code"] intValue] ==0){
            for (NSDictionary *goodsDic in responseObject[@"data"]) {
                self.gradeModel =[[GradeModel alloc] initWithDictionary:goodsDic];
                [self.gradeArr addObject:self.gradeModel];
            }
            
            
        }else{
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"errorMsg"]]];
            NSLog(@"%@",responseObject[@"result"][@"errorMsg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
}
- (void)requestClass{
    NSString *URL = [NSString stringWithFormat:@"%@/select-class",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.gradeID forKey:@"id"];
    [parameters setValue:@"100" forKey:@"limit"];
    [parameters setValue:@"1" forKey:@"page"];
    NSLog(@"年级ID:%@",self.gradeID);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"查询班级正确%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            for (NSDictionary *goodsDic in responseObject[@"content"]) {
                self.classModel =[[ClassModel alloc] initWithDictionary:goodsDic];
                [self.ClassArr addObject:self.classModel];
            }
            
            
            
        }else{
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"errorMsg"]]];
            NSLog(@"%@",responseObject[@"result"][@"errorMsg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
}

- (void)setPick{
    NSArray *gradeArrTwo = @[@"父子",@"母子",@"其他"];
    
    
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.gradeArr = gradeArrTwo;
    picker.delegate = self ;
    picker.arrayType = HeightArray;
    NSLog(@"%@",picker.gradeArr);
    [self.view addSubview:picker];
    self.selectedIndexPath = 0;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}
- (void)selectPick{
    
    self.relationshipBtn.enabled = YES;
    [_pick removeFromSuperview];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userNameTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    [self.passWordTwoTextField resignFirstResponder];
    [self.parentNameTextField resignFirstResponder];
    [self.studentTextfield resignFirstResponder];
    [self.studentIDTextField resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];

}

#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return  _relationshipArr.count;
}



#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (component == 1) {
        return KWidth;
    }
    return KWidth;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [_relationshipBtn setTitle:_relationshipArr[row] forState:UIControlStateNormal];
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_relationshipArr objectAtIndex:row];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)goHomeController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *baseNaviVC = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController =baseNaviVC;
    
}

-(NSMutableArray *)relationshipArr{
    if (!_relationshipArr) {
        _relationshipArr  = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _relationshipArr;
}

//验证账号密码
- (void)requestPassWord {
    NSString *URL = [NSString stringWithFormat:@"%@/register",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.userNameTextField.text forKey:@"username"];
    [parameters setValue:self.schoolCode forKey:@"school_invited_code"];
    [parameters setValue:@"2" forKey:@"type"];
    [parameters setValue:self.passWordTextField.text forKey:@"password"];
    [parameters setValue:self.parentNameTextField.text forKey:@"name"];

    [parameters setValue:self.ClassID forKey:@"classroom_id"];
    [parameters setValue:self.studentIDTextField.text forKey:@"no"];

    [parameters setValue:self.phoneNumTextField.text forKey:@"phone"];

    [parameters setValue:self.guanxi forKey:@"family_type"];
    NSLog(@"参数:%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"正确%@",responseObject);
        if([responseObject[@"code"] intValue] ==0){
            [MBProgressHUD showText:@"注册成功"];
            NSString *token = responseObject[@"data"][@"token"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:token forKey:@"token"];
            //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [user setValue:self.passWordTextField.text forKey:@"password"];
            [user setValue:self.userNameTextField.text forKey:@"username"];
            //            [userDefaults setValue:token forKey:@"token"];
            [user synchronize];
            
            
            LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            loginViewController.navigationController.navigationBar.hidden = YES;
            [self.navigationController pushViewController:loginViewController animated:YES];
            
            
        }else{
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            NSLog(@"%@",responseObject[@"msg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
}
-(NSMutableArray *)gradeArr{
    if (!_gradeArr) {
        _gradeArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _gradeArr;
}
-(NSMutableArray *)ClassArr{
    if (!_ClassArr) {
        _ClassArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _ClassArr;
}
- (void)tap:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
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
