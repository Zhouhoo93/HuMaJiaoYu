//
//  StudentRegisterViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/26.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "StudentRegisterViewController.h"
#import "PopUpView.h"
#import "PopModel.h"
#import "Header.h"
#import "JHPickView.h"
#import "AppDelegate.h"
#import "GradeModel.h"
#import "ClassModel.h"
#import "LoginViewController.h"
#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface StudentRegisterViewController ()<JHPickerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollerView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTwoTextField;
@property (weak, nonatomic) IBOutlet UITextField *studentNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UIButton *gradeBtn;
@property (weak, nonatomic) IBOutlet UIButton *classBtn;
@property (weak, nonatomic) IBOutlet UITextField *studentIDTextField;
@property (weak, nonatomic) IBOutlet UIButton *birthdayBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addresstEXTfIELD;
@property (weak, nonatomic) IBOutlet UITextField *emergencyManTextField;
@property (weak, nonatomic) IBOutlet UITextField *emergencyPhoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *relationshipBtn;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) PopUpView *showView;
@property (assign,nonatomic) NSInteger* selectedIndexPath ;
@property (nonatomic,strong)GradeModel *gradeModel;
@property (nonatomic,strong)NSMutableArray *gradeArr;
@property (nonatomic,copy)NSString *gradeID;
@property (nonatomic,strong)ClassModel *classModel;
@property (nonatomic,strong)NSMutableArray *ClassArr;
@property (nonatomic,copy)NSString *ClassID;
@end

@implementation StudentRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self requestGrade];
    [self setSelect];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.bgScrollerView.contentSize = CGSizeMake(KWidth, 850);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectSexBtn:(id)sender {
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.delegate = self ;
    picker.arrayType = GenderArray;
    [self.view addSubview:picker];
    self.selectedIndexPath = 0;
}
- (IBAction)selectGradeBtnClick:(id)sender {
    NSMutableArray *gradeArrTwo = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<self.gradeArr.count; i++) {
        self.gradeModel = self.gradeArr[i];
        [gradeArrTwo addObject:self.gradeModel.grade_alias];
    }
    
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.gradeArr = gradeArrTwo;
    picker.delegate = self ;
    picker.arrayType = HeightArray;
    NSLog(@"%@",picker.gradeArr);
    [self.view addSubview:picker];
    self.selectedIndexPath = 1;
}
- (IBAction)selectClassBtnClick:(id)sender {
    NSMutableArray *gradeArrThree = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<self.ClassArr.count; i++) {
        self.classModel = self.ClassArr[i];
        [gradeArrThree addObject:self.classModel.class_alias];
    }

    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.classArr = gradeArrThree;
    picker.delegate = self ;
    picker.arrayType = weightArray;
    [self.view addSubview:picker];
    self.selectedIndexPath = 2;
}
- (IBAction)selectBirthdayBtnClick:(id)sender {
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.delegate = self ;
    picker.arrayType = DeteArray;
    [self.view addSubview:picker];
   self.selectedIndexPath = 3;
}

#pragma mark - JHPickerDelegate

-(void)PickerSelectorIndixString:(NSString *)str:(NSInteger)row
{
    
    
    if (self.selectedIndexPath==0) {
        [self.sexBtn setTitle:str forState:UIControlStateNormal];
    }else if (self.selectedIndexPath==1) {
        [self.gradeBtn setTitle:str forState:UIControlStateNormal];
        _gradeModel = _gradeArr[row];
        self.gradeID = _gradeModel.ID;
        [self requestClass];
    }else if (self.selectedIndexPath==2) {
        [self.classBtn setTitle:str forState:UIControlStateNormal];
        _classModel = _ClassArr[row];
        self.ClassID = _classModel.ID;
    }else if (self.selectedIndexPath==3) {
        [self.birthdayBtn setTitle:str forState:UIControlStateNormal];
    }
    
    
}

-(NSDateComponents*)getDateComponentsFromDate:(NSDate*)date{
    
    //    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit =  NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    return theComponents ;
    
}



- (IBAction)relationshipBtnClick:(id)sender {
    UIActionSheet *actionsheet03 = [[UIActionSheet alloc] initWithTitle:@"选择身份" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"父子", @"母子",@"爷孙",  nil];
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
        [self.relationshipBtn setTitle:@"父子" forState:0];
    }
    else if (1 == buttonIndex)
    {
        NSLog(@"点击了家长按钮");
        [self.relationshipBtn setTitle:@"母子" forState:0];
    }
    else if (2 == buttonIndex)
    {
        NSLog(@"点击了教师按钮");
        [self.relationshipBtn setTitle:@"爷孙" forState:0];
    }else if (3 == buttonIndex)
    {
        NSLog(@"点击了取消按钮");
    }
    
}

-(void)setSelect{
    self.dataArr = [NSMutableArray array];
    NSArray *arr = @[@{@"name":@"父子"},@{@"name":@"母子"},@{@"name":@"爷孙"},@{@"name":@"叔侄"},@{@"name":@"其他"}];
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

- (void)requestGrade{
    NSString *URL = [NSString stringWithFormat:@"%@/select-grade",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"查询年级正确%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            for (NSDictionary *goodsDic in responseObject[@"content"]) {
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

//验证账号密码
- (void)requestPassWord {
    NSString *URL = [NSString stringWithFormat:@"%@/stu-register",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.userNameTextField.text forKey:@"username"];
    [parameters setValue:@"1" forKey:@"num"];
    [parameters setValue:self.passWordTextField.text forKey:@"pwd"];
    [parameters setValue:self.studentNameTextField.text forKey:@"stu_name"];
    if ([self.sexBtn.titleLabel.text isEqualToString:@"男"]) {
         [parameters setValue:@"1" forKey:@"sex"];
    }else{
        [parameters setValue:@"0" forKey:@"sex"];
    }
    [parameters setValue:self.ClassID forKey:@"class"];
    [parameters setValue:self.studentIDTextField.text forKey:@"stu_id"];
    NSString *birStr = self.birthdayBtn.titleLabel.text;
    
    NSString *str1 = [birStr stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"日" withString:@""];
    [parameters setValue:str3 forKey:@"birth"];
    [parameters setValue:self.phoneTextField.text forKey:@"tel"];
    [parameters setValue:self.addresstEXTfIELD.text forKey:@"addr"];
    [parameters setValue:self.emergencyManTextField.text forKey:@"family_name"];
    [parameters setValue:self.emergencyPhoneTextField.text forKey:@"family_tel"];
    [parameters setValue:self.relationshipBtn.titleLabel.text forKey:@"relationship"];
    NSLog(@"参数:%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"正确%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            [MBProgressHUD showText:@"注册成功"];
            LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            loginViewController.navigationController.navigationBar.hidden = YES;
            [self.navigationController pushViewController:loginViewController animated:YES];
            
            
        }else{
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"errorMsg"]]];
            NSLog(@"%@",responseObject[@"result"][@"errorMsg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
}
- (IBAction)sendBtnclick:(id)sender {
    [self requestPassWord];
}
- (void)goHomeController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *baseNaviVC = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController =baseNaviVC;
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
