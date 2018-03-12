//
//  PurifyControlViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/28.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "PurifyControlViewController.h"
#import "LightViewController.h"
#import "PurifyModel.h"
#import "JHPickView.h"
#import "PurifyTwoViewController.h"
#import "LightPlanModel.h"
#import "LightQingJingModel.h"
#import "LoginViewController.h"
#import "WenDuLishiViewController.h"
@interface PurifyControlViewController ()<JHPickerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *fanganLabel;
@property (weak, nonatomic) IBOutlet UILabel *wenduLabel;
@property (weak, nonatomic) IBOutlet UILabel *wendupingguLabel;
@property (weak, nonatomic) IBOutlet UILabel *TVOCLabel;
@property (weak, nonatomic) IBOutlet UILabel *TVOCpingguLabel;
@property (weak, nonatomic) IBOutlet UILabel *shiduLabel;
@property (weak, nonatomic) IBOutlet UILabel *shiduPingguLabel;
@property (weak, nonatomic) IBOutlet UILabel *PMLabel;
@property (weak, nonatomic) IBOutlet UILabel *PMpingguLabel;
@property (weak, nonatomic) IBOutlet UILabel *co2Label;
@property (weak, nonatomic) IBOutlet UILabel *co2pingguLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationLabel;
@property (nonatomic,strong)PurifyModel *model;
@property (weak, nonatomic) IBOutlet UIScrollView *bgscrollview;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) LightPlanModel *lightplanModel;
@property (nonatomic,strong) NSMutableArray *lightplanArr;
@property (nonatomic,strong) LightQingJingModel *lightqingjingModel;
@property (nonatomic,strong) NSMutableArray *lightqingjingArr;
@property (assign,nonatomic) NSInteger* selectedIndexPath ;
@property (nonatomic,copy) NSString *bid;
@end

@implementation PurifyControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"净化器";
    [self requestData];
    [self requestqingjing];
    [self requestFangan];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.bgscrollview.contentSize = CGSizeMake(KWidth, 650);
}



- (IBAction)ManangerBtnClick:(id)sender {
    PurifyTwoViewController *vc = [[PurifyTwoViewController alloc] init];
    vc.location = self.locationLabel.titleLabel.text;
    vc.qingjing = self.statusLabel.text;
    vc.fangan= self.fanganLabel.text;
    vc.classroom_id = _model.classroom_id;
    vc.bid = _model.bid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)qingjingBtnClick:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        NSMutableArray *gradeArrTwo = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0; i<self.lightqingjingArr.count; i++) {
            self.lightqingjingModel = self.lightqingjingArr[i];
            [gradeArrTwo addObject:self.lightqingjingModel.name];
        }
        
        JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
        picker.gradeArr = gradeArrTwo;
        picker.delegate = self ;
        picker.arrayType = HeightArray;
        NSLog(@"%@",picker.gradeArr);
        [self.view addSubview:picker];
        self.selectedIndexPath = 0;
        
    }else {
        [MBProgressHUD showText:@"无权限控制"];
    }
    

    
}
-(void)PickerSelectorIndixString:(NSString *)str:(NSInteger)row
{
    
    
    if (self.selectedIndexPath==0) {
//        _lightqingjingModel = self.lightqingjingArr[row];
        _model = self.dataArr[row];
//        self.bid = _lightqingjingModel.ID;
        self.statusLabel.text = str;
        for (int i=0; i<self.lightqingjingArr.count; i++) {
            _lightqingjingModel = self.lightqingjingArr[i];
            NSString *string = [NSString stringWithFormat:@"%@",_lightqingjingModel.name];
            if ([string isEqualToString:str]) {
                self.bid = _lightqingjingModel.ID;
            }
        }

        [self SendQingjing];
        
    }else if (self.selectedIndexPath==1) {
        _lightplanModel = self.lightplanArr[row];
        self.bid = _lightplanModel.ID;
        self.fanganLabel.text = str;
        [self SendPlan];
    }
    
    
}


- (IBAction)fanganBtnClick:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        NSMutableArray *gradeArrTwo = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0; i<self.lightplanArr.count; i++) {
            self.lightplanModel = self.lightplanArr[i];
            [gradeArrTwo addObject:self.lightplanModel.name];
        }
        
        JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
        picker.gradeArr = gradeArrTwo;
        picker.delegate = self ;
        picker.arrayType = HeightArray;
        NSLog(@"%@",picker.gradeArr);
        [self.view addSubview:picker];
        self.selectedIndexPath = 1;
        
    }else {
        [MBProgressHUD showText:@"无权限控制"];
    }
    

    
}

-(void)SendPlan{
    NSString *URL = [NSString stringWithFormat:@"%@/app/lplan/plan/%@",kUrl,self.bid];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSString *type = [userDefaults valueForKey:@"type"];
    NSString *page = [NSString new];
    if([type isEqualToString:@"学生"]){
        page = @"appstu";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
    }else if([type isEqualToString:@"家长"]){
        page = @"appfamily";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
    }else{
        page = @"appteacher";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.fanganLabel.text forKey:@"plan"];
    NSLog(@"%@",parameters);
    
    [manager PUT:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"设置d灯光正确%@",responseObject);
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
            //            self.sliderone.value = self.oldClass;
            //            self.slidertwo.value = self.oldblack;
        }else{
            //            self.oldClass = self.sliderone.value;
            //            self.oldblack = self.slidertwo.value;
            //            [self requestData];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
    }];
    
}

-(void)SendQingjing{
    NSString *URL = [NSString stringWithFormat:@"%@/app/air_cleaners/air_cleaner/change-scene",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSString *type = [userDefaults valueForKey:@"type"];
    NSString *page = [NSString new];
    if([type isEqualToString:@"学生"]){
        page = @"appstu";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
    }else if([type isEqualToString:@"家长"]){
        page = @"appfamily";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
    }else{
        page = @"appteacher";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];

    [parameters setValue:self.classroom_id forKey:@"classroom_id"];
    [parameters setValue:self.lightqingjingModel.ID forKey:@"scene_id"];
   
    NSLog(@"%@",parameters);
    
    [manager POST:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"设置d灯光正确%@",responseObject);
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
            //            self.sliderone.value = self.oldClass;
            //            self.slidertwo.value = self.oldblack;
        }else{
            //            self.oldClass = self.sliderone.value;
            //            self.oldblack = self.slidertwo.value;
            //            [self requestData];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
    }];
    
}


-(void)requestFangan{
    NSString *URL = [NSString stringWithFormat:@"%@/app/lplan/plan",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSString *type = [userDefaults valueForKey:@"type"];
    NSString *page = [NSString new];
    if([type isEqualToString:@"学生"]){
        page = @"appstu";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
    }else if([type isEqualToString:@"家长"]){
        page = @"appfamily";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
    }else{
        page = @"appteacher";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
    }
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"获取灯光方案正确%@",responseObject);
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
        }else{
            for (NSDictionary *dic in responseObject[@"content"]) {
                _lightplanModel = [[LightPlanModel alloc] initWithDictionary:dic];
                [self.lightplanArr addObject:_lightplanModel];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

-(void)requestqingjing{
    NSString *URL = [NSString stringWithFormat:@"%@/app/lscene/scene",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSString *type = [userDefaults valueForKey:@"type"];
    NSString *page = [NSString new];
    if([type isEqualToString:@"学生"]){
        page = @"appstu";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
    }else if([type isEqualToString:@"家长"]){
        page = @"appfamily";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
    }else{
        page = @"appteacher";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
    }
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"获取灯光情景正确%@",responseObject);
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
        }else{
            for (NSDictionary *dic in responseObject[@"content"]) {
                _lightqingjingModel = [[LightQingJingModel alloc] initWithDictionary:dic];
                [self.lightqingjingArr addObject:_lightqingjingModel];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/app/air_cleaners/air_cleaner",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSString *type = [userDefaults valueForKey:@"type"];
    NSString *page = [NSString new];
    if([type isEqualToString:@"学生"]){
        page = @"appstu";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
    }else if([type isEqualToString:@"家长"]){
        page = @"appfamily";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
    }else{
        page = @"appteacher";
        [manager.requestSerializer  setValue:page forHTTPHeaderField:@"type"];
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.classroom_id forKey:@"classroom_id"];
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"获取净化器数据正确%@",responseObject);


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
            NSArray *arr = responseObject[@"content"][@"data"];
            if (arr.count>0) {
                for (NSDictionary *dic in responseObject[@"content"][@"data"]) {
                    _model = [[PurifyModel alloc] initWithDictionary:dic];
                    [self.dataArr addObject:_model];
                }
                [self.locationLabel setTitle:_model.localtion forState:UIControlStateNormal];
                self.statusLabel.text = _model.sence_name;
                self.fanganLabel.text = _model.plan_name;
                //            self.fanganLabel.text =
                self.wenduLabel.text = [NSString stringWithFormat:@"%@℃",_model.temperature];
                self.TVOCLabel.text = [NSString stringWithFormat:@"%@mg/m³",_model.TVOC];
                self.shiduLabel.text = [NSString stringWithFormat:@"%@%%",_model.wind_peed];
                self.PMLabel.text = [NSString stringWithFormat:@"%@mg/m³",_model.PM25];
                self.co2Label.text = [NSString stringWithFormat:@"%@ppm",_model.CO2];

            }else{
                [MBProgressHUD showText:@"当前教室没有硬件"];
//                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
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

-(PurifyModel *)model{
    if (!_model) {
        _model = [[PurifyModel alloc] init];
    }
    return _model;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
-(NSMutableArray *)lightqingjingArr{
    if (!_lightqingjingArr) {
        _lightqingjingArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _lightqingjingArr;
}

-(LightQingJingModel *)lightqingjingModel{
    if (!_lightqingjingModel) {
        _lightqingjingModel = [[LightQingJingModel alloc] init];
    }
    return _lightqingjingModel;
}
-(NSMutableArray *)lightplanArr{
    if (!_lightplanArr) {
        _lightplanArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _lightplanArr;
}

-(LightPlanModel *)lightplanModel{
    if (!_lightplanModel) {
        _lightplanModel = [[LightPlanModel alloc] init];
    }
    return _lightplanModel;
}
- (IBAction)wenduBtnClick:(id)sender {
    WenDuLishiViewController *vc = [[WenDuLishiViewController alloc] init];
    vc.leftLabel.text = @"当前温度";
    NSString *str= self.locationLabel.titleLabel.text;
    vc.RightBtn1.titleLabel.text = str;
    vc.charttip1 = @"教室温度";
    vc.charttip2 = @"一周平均温度";
    vc.chartleft1 = @"℃";
    vc.chartleft2 = @"℃";
    vc.chartright1 = @"温度";
    vc.chartright2 = @"温度";
    vc.index = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)tvocBtnClick:(id)sender {
    WenDuLishiViewController *vc = [[WenDuLishiViewController alloc] init];
    vc.leftLabel.text = @"TVOC含量";
    NSString *str= self.locationLabel.titleLabel.text;
    vc.RightBtn1.titleLabel.text = str;
    vc.leftLabel.text = @"";
    vc.charttip1 = @"教室TVOC值";
    vc.charttip2 = @"一周平均TVOC值";
    vc.chartleft1 = @"mg/m³";
    vc.chartleft2 = @"mg/m³";
    vc.chartright1 = @"TVOC含量";
    vc.chartright2 = @"TVOC含量";
    vc.index = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)shiduBtnClick:(id)sender {
    WenDuLishiViewController *vc = [[WenDuLishiViewController alloc] init];
    vc.leftLabel.text = @"当前湿度";
    NSString *str= self.locationLabel.titleLabel.text;
    vc.RightBtn1.titleLabel.text = str;
    vc.leftLabel.text = @"";
    vc.charttip1 = @"教室湿度";
    vc.charttip2 = @"一周平均湿度";
    vc.chartleft1 = @"%";
    vc.chartleft2 = @"%";
    vc.chartright1 = @"湿度";
    vc.chartright2 = @"湿度";
    vc.index = 2;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)PMBtnClick:(id)sender {
    WenDuLishiViewController *vc = [[WenDuLishiViewController alloc] init];
    vc.leftLabel.text = @"PM2.5值";
    NSString *str= self.locationLabel.titleLabel.text;
    vc.RightBtn1.titleLabel.text = str;
    vc.charttip1 = @"教室PM2.5值";
    vc.charttip2 = @"一周平均PM2.5值";
    vc.chartleft1 = @"mg/m³";
    vc.chartleft2 = @"mg/m³";
    vc.chartright1 = @"PM2.5值";
    vc.chartright2 = @"PM2.5值";
    vc.index = 3;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)co2BtnClick:(id)sender {
    WenDuLishiViewController *vc = [[WenDuLishiViewController alloc] init];
    vc.leftLabel.text = @"CO2值";
    NSString *str= self.locationLabel.titleLabel.text;
    vc.RightBtn1.titleLabel.text = str;
    vc.charttip1 = @"教室CO2值";
    vc.charttip2 = @"一周平均CO2值";
    vc.chartleft1 = @"ppm";
    vc.chartleft2 = @"ppm";
    vc.chartright1 = @"CO2值";
    vc.chartright2 = @"CO2值";
    vc.index = 4;
    [self.navigationController pushViewController:vc animated:YES];
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
