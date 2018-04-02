//
//  PurifyTwoViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/31.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "PurifyTwoViewController.h"
#import "SEFilterControl.h"
#import "LightPlanModel.h"
#import "LightQingJingModel.h"
#import "PurifyModel.h"
#import "JHPickView.h"
#import "LoginViewController.h"
@interface PurifyTwoViewController ()<JHPickerDelegate>
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property(nonatomic,strong) SEFilterControl *filter;
@property (nonatomic,strong) LightPlanModel *lightplanModel;
@property (nonatomic,strong) NSMutableArray *lightplanArr;
@property (nonatomic,strong) LightQingJingModel *lightqingjingModel;
@property (nonatomic,strong) NSMutableArray *lightqingjingArr;
@property (assign,nonatomic) NSInteger* selectedIndexPath ;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *device_on;
@property (nonatomic,copy) NSString *runmodel;
@property (nonatomic,strong)PurifyModel *model;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,copy) NSString *planID;
@property (nonatomic,copy) NSString *fangID;
@end

@implementation PurifyTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备管理";
//    [self requestAirData];
    [self setButton];
    [self requestData];
    [self requestqingjing];
    [self requestFangan];
    self.runmodel = @"1";
    self.locationLabel.text = self.location;
    self.qingjingLabel.text = self.qingjing;
    self.fanganLabel.text = self.fangan;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        
    }else {
        self.filter.enabled = NO;
        [MBProgressHUD showText:@"无权限控制"];
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)autoBtnClick:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        if (sender.selected) {
            sender.selected = NO;
//            self.UVlightONBtn.enabled = YES;
//            self.UVLightOffBtn.enabled = YES;
//            self.changgeOnBtn.enabled = YES;
//            self.changgeOffBtn.enabled = YES;
//            self.oneSpeedBtn.enabled = YES;
//            self.twoSpeedBtn.enabled = YES;
//            self.threeSpeedBtn.enabled = YES;
            self.runmodel = @"1";
            [self Sendauto];
        }else{
            sender.selected = YES;
//            self.UVlightONBtn.selected = YES;
//            self.UVLightOffBtn.selected = NO;
//            self.uv_on = @"1";
//            self.changgeOnBtn.selected = YES;
//            self.changgeOffBtn.selected = NO;
//            self.fresh_air_open = @"1";
//            self.oneSpeedBtn.selected = NO;
//            self.twoSpeedBtn.selected = NO;
//            self.threeSpeedBtn.selected = YES;
//            self.wind_speed = @"3";
//            [self SendData];
//            self.UVlightONBtn.enabled = NO;
//            self.UVLightOffBtn.enabled = NO;
//            self.changgeOnBtn.enabled = NO;
//            self.changgeOffBtn.enabled = NO;
//            self.oneSpeedBtn.enabled = NO;
//            self.twoSpeedBtn.enabled = NO;
//            self.threeSpeedBtn.enabled = NO;
            self.runmodel = @"0";
            [self Sendauto];
        }
        
    }else {
        [MBProgressHUD showText:@"无权限控制"];
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
//        _model = self.dataArr[row];
//        self.bid = _lightqingjingModel.ID;
        self.qingjingLabel.text = str;
        for (int i=0; i<self.lightqingjingArr.count; i++) {
            _lightqingjingModel = self.lightqingjingArr[i];
            NSString *string = [NSString stringWithFormat:@"%@",_lightqingjingModel.name];
            if ([string isEqualToString:str]) {
                self.bid = _lightqingjingModel.ID;
                self.planID = _lightqingjingModel.ID;
            }
        }

        [self SendQingjing];
        
    }else if (self.selectedIndexPath==1) {
        _lightplanModel = self.lightplanArr[row];
        self.bid = _lightplanModel.ID;
        self.fangID = _lightplanModel.ID;
        self.fanganLabel.text = str;
        [self SendPlan];
    }else if (self.selectedIndexPath==2) {
        
    }else if (self.selectedIndexPath==3) {
        
    }
    
    
}


- (void)setButton{
    _filter = [[SEFilterControl alloc]initWithFrame:CGRectMake(0,0 , self.buttonView.frame.size.width, 15) Titles:[NSArray arrayWithObjects:@"0档", @"1档", @"2档", @"3档",@"4档",@"5档", nil]];
    [_filter addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    [_filter setProgressColor:[UIColor groupTableViewBackgroundColor]];//设置滑杆的颜色
    [_filter setTopTitlesColor:[UIColor orangeColor]];//设置滑块上方字体颜色
    [_filter setSelectedIndex:0];//设置当前选中
    [_buttonView addSubview:_filter];

}
#pragma mark -- 点击底部按钮响应事件
-(void)filterValueChanged:(SEFilterControl *)sender
{
    NSLog(@"当前滑块位置%d",sender.SelectedIndex);
    NSInteger num = sender.SelectedIndex;
    self.wind_speed = [NSString stringWithFormat:@"%d",num];
    [self SendData];

}

- (IBAction)oneSpeedBtnClick:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        if (sender.selected) {
            //        sender.selected = NO;
            
        }else{
            sender.selected = YES;
            self.twoSpeedBtn.selected = NO;
            self.threeSpeedBtn.selected = NO;
            self.wind_speed = @"1";
            [self SendData];
        }

    }else {
        [MBProgressHUD showText:@"无权限控制"];
    }

}
- (IBAction)twoSpeedBtnClick:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        if (sender.selected) {
            //        sender.selected = NO;
        }else{
            sender.selected = YES;
            self.oneSpeedBtn.selected = NO;
            self.threeSpeedBtn.selected = NO;
            self.wind_speed = @"2";
            [self SendData];
        }
        
    }else {
        [MBProgressHUD showText:@"无权限控制"];
    }

}
- (IBAction)threeSpeedBtnClick:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        if (sender.selected) {
            //        sender.selected = NO;
        }else{
            sender.selected = YES;
            self.twoSpeedBtn.selected = NO;
            self.oneSpeedBtn.selected = NO;
            self.wind_speed = @"3";
            [self SendData];
        }
        
    }else {
        [MBProgressHUD showText:@"无权限控制"];
    }

}
- (IBAction)UVOnBtnClick:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        if (sender.selected) {
            //        sender.selected = NO;
        }else{
            sender.selected = YES;
            self.UVLightOffBtn.selected = NO;
            self.uv_on = @"1";
            [self SendData];
        }
        
    }else {
        [MBProgressHUD showText:@"无权限控制"];
    }

}
- (IBAction)UVOffBtnClick:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        if (sender.selected) {
            //        sender.selected = NO;
        }else{
            sender.selected = YES;
            self.UVlightONBtn.selected = NO;
            self.uv_on = @"0";
            [self SendData];
        }
        
    }else {
        [MBProgressHUD showText:@"无权限控制"];
    }

}
- (IBAction)changgeOnBtnClick:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        if (sender.selected) {
            //        sender.selected = NO;
        }else{
            sender.selected = YES;
            self.changgeOffBtn.selected = NO;
            self.fresh_air_open = @"1";
            [self SendData];
        }
        
    }else {
        [MBProgressHUD showText:@"无权限控制"];
    }

}
- (IBAction)changgeOffBtnClick:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        if (sender.selected) {
            //        sender.selected = NO;
            
        }else{
            sender.selected = YES;
            self.changgeOnBtn.selected = NO;
            self.fresh_air_open = @"0";
            [self SendData];
        }
        
    }else {
        [MBProgressHUD showText:@"无权限控制"];
    }

}
- (IBAction)ALLONBtnClick:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        if (sender.selected) {
            sender.selected = NO;
        }else{
            sender.selected = YES;
//            self.UVlightONBtn.selected = YES;
//            self.UVLightOffBtn.selected = NO;
//            self.uv_on = @"1";
//            self.changgeOnBtn.selected = YES;
//            self.changgeOffBtn.selected = NO;
//            self.fresh_air_open = @"1";
//            self.oneSpeedBtn.selected = NO;
//            self.twoSpeedBtn.selected = NO;
//            self.threeSpeedBtn.selected = YES;
//            self.wind_speed = @"3";
//            self.runmodel = @"0";
//            [self SendData];
            
            
            [self Sendkaiqi];
        }
        
    }else {
        [MBProgressHUD showText:@"无权限控制"];
    }
    

}
- (IBAction)AllOffBtnClick:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        if (sender.selected) {
            sender.selected = NO;
        }else{
            sender.selected = YES;
//            self.UVlightONBtn.selected = NO;
//            self.UVLightOffBtn.selected = YES;
//            self.uv_on = @"0";
//            self.changgeOnBtn.selected = NO;
//            self.changgeOffBtn.selected = YES;
//            self.fresh_air_open = @"0";
//            self.oneSpeedBtn.selected = NO;
//            self.twoSpeedBtn.selected = NO;
//            self.threeSpeedBtn.selected = NO;
//            self.wind_speed = @"0";
//            self.runmodel = @"0";
//            [self SendData];
            [self Sendguanbi];
        }
        
    }else {
        [MBProgressHUD showText:@"无权限控制"];
    }

}

-(void)Sendkaiqi{
    NSString *URL = [NSString stringWithFormat:@"%@/my-equipments/%@/air-cleaner-ctrl",kUrl,self.IID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    //    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:token forKey:@"token"];
//    [parameters setValue:self.classroom_id forKey:@"classroom_id"];
//    [parameters setValue:self.wind_speed forKey:@"wind_speed"];
//    [parameters setValue:self.uv_on forKey:@"uv_on"];
//    [parameters setValue:self.fresh_air_open forKey:@"fresh_air_open"];
//    [parameters setValue:self.runmodel forKey:@"run_mode"];
    [parameters setValue:@"0" forKey:@"device_on"];
//    [parameters setValue:self.bid forKey:@"bid"];
    NSLog(@"%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"开启净化器正确%@",responseObject);
        
        if ([responseObject[@"code"] intValue] !=0) {
            NSNumber *code = responseObject[@"code"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"4003"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text =responseObject[@"msg"];
                [hud hideAnimated:YES afterDelay:2.f];
            }
        }else{
            //            [self requestData];
            self.autoOffBtn.enabled = YES;
            self.autoOnBtn.enabled = NO;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

-(void)Sendauto{
    NSString *URL = [NSString stringWithFormat:@"%@/my-equipments/%@/air-cleaner-ctrl",kUrl,self.IID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    //    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:token forKey:@"token"];
    //    [parameters setValue:self.classroom_id forKey:@"classroom_id"];
    //    [parameters setValue:self.wind_speed forKey:@"wind_speed"];
    //    [parameters setValue:self.uv_on forKey:@"uv_on"];
    //    [parameters setValue:self.fresh_air_open forKey:@"fresh_air_open"];
        [parameters setValue:self.runmodel forKey:@"run_mode"];
//    [parameters setValue:@"0" forKey:@"device_on"];
    //    [parameters setValue:self.bid forKey:@"bid"];
    NSLog(@"%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"自动正确%@",responseObject);
        
        if ([responseObject[@"code"] intValue] !=0) {
            NSNumber *code = responseObject[@"code"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"4003"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text =responseObject[@"msg"];
                [hud hideAnimated:YES afterDelay:2.f];
            }
        }else{
            //            [self requestData];
            self.autoOffBtn.selected = NO;
            self.autoOnBtn.selected = NO;
            self.autoBtn.enabled = NO;
            self.autoBtn.selected = YES;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

-(void)Sendguanbi{
    NSString *URL = [NSString stringWithFormat:@"%@/my-equipments/%@/air-cleaner-ctrl",kUrl,self.IID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    //    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:token forKey:@"token"];
    //    [parameters setValue:self.classroom_id forKey:@"classroom_id"];
    //    [parameters setValue:self.wind_speed forKey:@"wind_speed"];
    //    [parameters setValue:self.uv_on forKey:@"uv_on"];
    //    [parameters setValue:self.fresh_air_open forKey:@"fresh_air_open"];
    //    [parameters setValue:self.runmodel forKey:@"run_mode"];
    [parameters setValue:@"1" forKey:@"device_on"];
    //    [parameters setValue:self.bid forKey:@"bid"];
    NSLog(@"%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"关闭净化器正确%@",responseObject);
        
        if ([responseObject[@"code"] intValue] !=0) {
            NSNumber *code = responseObject[@"code"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"4003"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text =responseObject[@"msg"];
                [hud hideAnimated:YES afterDelay:2.f];
            }
        }else{
            //            [self requestData];
            self.autoOffBtn.enabled = NO;
            self.autoOnBtn.enabled = YES;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/my-equipments/%@",kUrl,self.IID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    //    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:token forKey:@"token"];
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"获取净化器正确%@",responseObject);

        if ([responseObject[@"code"] intValue] !=0) {
            NSNumber *code = responseObject[@"code"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"4200"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
            NSString *str = responseObject[@"msg"];
            [MBProgressHUD showText:str];
            }
        }else{
            NSMutableDictionary *arr = responseObject[@"data"];
            if (arr.count>0) {
                self.classroom_id = arr[@"room"][@"classroom_id"];
                //            self.bid = dic[@"bid"];
                self.device_on = arr[@"ctrl_data"][@"device_on"];
                self.runmodel = arr[@"ctrl_data"][@"run_mode"];
                NSInteger num;
                if ([self.device_on isEqual:[NSNull null]]) {
                    num = 1;
                }else{
                    num = [self.device_on integerValue];
                }
                if ( num==0) {
                    self.autoOnBtn.enabled = NO;
                    self.autoOnBtn.selected = YES;
                }else if(num==1){
                    self.autoOffBtn.enabled = NO;
                    self.autoOffBtn.selected = YES;
                }
                NSInteger num1;
                if ([self.runmodel isEqual:[NSNull null]]) {
                    num1 = 1;
                }else{
                    num1 = [self.runmodel integerValue];
                }
                if ( num1==0) {
//                    self.autoOnBtn.enabled = NO;
                    self.autoOnBtn.selected = NO;
                    self.autoBtn.selected = YES;
                    self.autoOffBtn.selected = NO;
                    self.autoBtn.enabled = NO;
                }
                
                self.uv_on= arr[@"ctrl_data"][@"uv_on"];
                self.fresh_air_open = arr[@"ctrl_data"][@"fresh_air_open"];
                NSString *str = arr[@"temperature"];
                if (str.length>0) {
                    self.wenduLabel.text = [NSString stringWithFormat:@"%@",arr[@"temperature"]];
                }else{
                
                    self.wenduLabel.text = @"";

                }
                NSNumber *wind_peed = arr[@"ctrl_data"][@"wind_speed"];
                NSNumber *uv_on = arr[@"ctrl_data"][@"uv_on"];
                NSNumber *fresh_air_open = arr[@"ctrl_data"][@"fresh_air_open"];
                _wind_speed = [NSString stringWithFormat:@"%@",wind_peed];
                _uv_on = [NSString stringWithFormat:@"%@",uv_on];
                _fresh_air_open = [NSString stringWithFormat:@"%@",fresh_air_open];
                _filter.SelectedIndex = [_wind_speed integerValue];
                if ([_uv_on isEqualToString:@"0"]) {
                    _UVlightONBtn.selected = NO;
                    _UVLightOffBtn.selected = YES;
                }else{
                    _UVlightONBtn.selected = YES;
                    _UVLightOffBtn.selected = NO;
                }
                if ([_fresh_air_open isEqualToString:@"0"]) {
                    _changgeOnBtn.selected = NO;
                    _changgeOffBtn.selected = YES;
                }else{
                    _changgeOnBtn.selected = YES;
                    _changgeOffBtn.selected = NO;
                }

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

-(void)requestAirData{
   
NSString *URL = [NSString stringWithFormat:@"%@/my-equipments/%@",kUrl,self.IID];
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
NSString *token = [userDefaults valueForKey:@"token"];
//    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];

NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
[parameters setValue:token forKey:@"token"];
[manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    MyLog(@"获取净化器数据正确%@",responseObject);
    
    
    if ([responseObject[@"code"] intValue] !=0) {
        NSNumber *code = responseObject[@"code"];
        NSString *errorcode = [NSString stringWithFormat:@"%@",code];
        if ([errorcode isEqualToString:@"4200"])  {
            [MBProgressHUD showText:@"请重新登陆"];
            [self newLogin];
        }else{
            NSString *str = responseObject[@"msg"];
            [MBProgressHUD showText:str];
        }
    }else{
        NSMutableDictionary *arr = responseObject[@"data"];
//        if (arr.count>0) {
            for (NSDictionary *dic in responseObject[@"data"]) {
                _model = [[PurifyModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:_model];
            }
            
            self.classroom_id = arr[@"room"][@"classroom_id"];
//            self.bid = dic[@"bid"];
            self.device_on = arr[@"ctrl_data"][@"device_on"];
            self.uv_on= arr[@"ctrl_data"][@"uv_on"];
            self.fresh_air_open = arr[@"ctrl_data"][@"fresh_air_open"];
            self.wenduLabel.text = [NSString stringWithFormat:@"%@",arr[@"temperature"]];
            
//            [self.locationLabel setTitle:_model.localtion forState:UIControlStateNormal];
//            self.statusLabel.text = _model.sence_name;
//            self.fanganLabel.text = _model.plan_name;
//            //            self.fanganLabel.text =
//            self.wenduLabel.text = [NSString stringWithFormat:@"%@℃",_model.temperature];
//            self.TVOCLabel.text = [NSString stringWithFormat:@"%@mg/m³",_model.TVOC];
//            self.shiduLabel.text = [NSString stringWithFormat:@"%@%%",_model.wind_peed];
//            self.PMLabel.text = [NSString stringWithFormat:@"%@mg/m³",_model.PM25];
//            self.co2Label.text = [NSString stringWithFormat:@"%@ppm",_model.CO2];
            
//        }else{
//            [MBProgressHUD showText:@"当前教室没有硬件"];
//            //                [self.navigationController popViewControllerAnimated:YES];
//        }
        
    }
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    MyLog(@"失败%@",error);
    //        [MBProgressHUD showText:@"%@",error[@"error"]];
}];


}


-(void)SendPlan{
    NSString *URL = [NSString stringWithFormat:@"%@/my-equipments/%@/update-plan",kUrl,self.ID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
//    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSString *type = [userDefaults valueForKey:@"type"];
    NSString *page = [NSString new];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.ID forKey:@"id"];
    [parameters setValue:self.fangID forKey:@"plan_id"];
    [parameters setValue:token forKey:@"token"];
    NSLog(@"%@",parameters);
    
    [manager POST:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"设置d灯光正确%@",responseObject);
        if ([responseObject[@"code"] intValue] !=0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text =responseObject[@"msg"];
            [hud hideAnimated:YES afterDelay:2.f];
            //            self.sliderone.value = self.oldClass;
            //            self.slidertwo.value = self.oldblack;
        }else{
            //            self.oldClass = self.sliderone.value;
            //            self.oldblack = self.slidertwo.value;
            //            [self requestData];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text =@"设置成功";
            [hud hideAnimated:YES afterDelay:2.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
    }];
    
}

-(void)SendQingjing{
    NSString *URL = [NSString stringWithFormat:@"%@/my-equipments/%@/update-scene",kUrl,self.ID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSString *type = [userDefaults valueForKey:@"type"];
   
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.ID forKey:@"id"];
    [parameters setValue:self.planID forKey:@"scene_id"];
    [parameters setValue:token forKey:@"token"];
    NSLog(@"%@",parameters);
    
    [manager POST:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"设置d灯光正确%@",responseObject);
        if ([responseObject[@"code"] intValue] !=0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text =responseObject[@"msg"];
            [hud hideAnimated:YES afterDelay:2.f];
            //            self.sliderone.value = self.oldClass;
            //            self.slidertwo.value = self.oldblack;
        }else{
            //            self.oldClass = self.sliderone.value;
            //            self.oldblack = self.slidertwo.value;
            //            [self requestData];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text =@"设置成功";
            [hud hideAnimated:YES afterDelay:2.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
    }];
    
}


-(void)requestFangan{
    NSString *URL = [NSString stringWithFormat:@"%@/plans/light/all",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    //    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:token forKey:@"token"];
    
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"获取灯光方案正确%@",responseObject);
        if ([responseObject[@"code"] intValue] !=0) {
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
        }else{
            for (NSDictionary *dic in responseObject[@"data"]) {
                _lightplanModel = [[LightPlanModel alloc] initWithDictionary:dic];
                [self.lightplanArr addObject:_lightplanModel];
                if (_lightplanModel.ID ==self.plan_id) {
                    self.fanganLabel.text = _lightplanModel.name;
                }
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
}

-(void)requestqingjing{
    NSString *URL = [NSString stringWithFormat:@"%@/scenes/air-cleaner/all",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    //    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:token forKey:@"token"];
    
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"获取灯光情景正确%@",responseObject);
        if ([responseObject[@"code"] intValue] !=0) {
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
        }else{
            NSMutableArray *arr = responseObject[@"data"];
            for (int i=0; i<arr.count; i++) {
                //                for (NSDictionary *dic in arr[i]) {
                _lightqingjingModel = [[LightQingJingModel alloc] init];
                _lightqingjingModel.change_air = arr[i][@"change_air"];
                _lightqingjingModel.ID = arr[i][@"id"];
                _lightqingjingModel.name = arr[i][@"name"];
                _lightqingjingModel.school_id = arr[i][@"school_id"];
                _lightqingjingModel.speed_value = arr[i][@"speed_value"];
                _lightqingjingModel.uv_value = arr[i][@"uv_value"];
                //                    _lightqingjingModel = [[LightQingJingModel alloc] initWithDictionary:dic];
                [self.lightqingjingArr addObject:_lightqingjingModel];
                if (_lightqingjingModel.ID ==self.scene_id) {
                    self.qingjingLabel.text = _lightqingjingModel.name;
                }
                //                }
            }
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}


-(void)SendData{
    NSString *URL = [NSString stringWithFormat:@"%@/my-equipments/%@/air-cleaner-ctrl",kUrl,self.IID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
//    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
   
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:token forKey:@"token"];
    [parameters setValue:self.classroom_id forKey:@"classroom_id"];
    [parameters setValue:self.wind_speed forKey:@"wind_speed"];
    [parameters setValue:self.uv_on forKey:@"uv_on"];
    [parameters setValue:self.fresh_air_open forKey:@"fresh_air_open"];
    [parameters setValue:self.runmodel forKey:@"run_mode"];
    [parameters setValue:self.device_on forKey:@"device_on"];
    [parameters setValue:self.bid forKey:@"bid"];
    NSLog(@"%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"设置净化器正确%@",responseObject);

        if ([responseObject[@"code"] intValue] !=0) {
            NSNumber *code = responseObject[@"code"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"4003"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text =responseObject[@"msg"];
                [hud hideAnimated:YES afterDelay:2.f];
            }
        }else{
//            [self requestData];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
