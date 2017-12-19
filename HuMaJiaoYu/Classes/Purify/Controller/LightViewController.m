//
//  LightViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/28.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "LightViewController.h"
#import "ASValueTrackingSlider.h"
#import "LightModel.h"
#import "JHPickView.h"
#import "LightPlanModel.h"
#import "LightQingJingModel.h"
#import "LoginViewController.h"
#import "LightLishiViewController.h"
@interface LightViewController ()<ASValueTrackingSliderDataSource,JHPickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *qingjingLabel;
@property (weak, nonatomic) IBOutlet UILabel *planLabel;

@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slidertwo;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *sliderone;
@property (nonatomic,strong) LightModel *model;
@property (nonatomic,strong) LightPlanModel *lightplanModel;
@property (nonatomic,strong) NSMutableArray *lightplanArr;
@property (nonatomic,strong) LightQingJingModel *lightqingjingModel;
@property (nonatomic,strong) NSMutableArray *lightqingjingArr;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign)CGFloat oldClass;
@property (nonatomic,assign)CGFloat oldblack;
@property (assign,nonatomic) NSInteger* selectedIndexPath ;
@property (nonatomic,copy) NSString *bid;
@end

@implementation LightViewController
{
    NSArray *_sliders;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"灯光调整";
    // Do any additional setup after loading the view from its nib.
//    self.sliderone.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:14];
    [self requestData];
    [self requestFangan];
    [self requestqingjing];
    self.sliderone.textColor = [UIColor whiteColor];
    self.sliderone.textColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    UIColor *coldBlue = [UIColor colorWithHue:0.6 saturation:0.7 brightness:1.0 alpha:1.0];
    [self.sliderone setPopUpViewAnimatedColors:@[coldBlue]];
    //                               withPositions:@[@-20, @0, @5, @25, @60]];
    //    左右轨的图片
    UIImage *stetchLeftTrack3= [UIImage imageNamed:@"圆角矩形-5"];
    UIImage *stetchRightTrack3 = [UIImage imageNamed:@"圆角矩形-5"];
    //滑块图片
    UIImage *thumbImage3 = [UIImage imageNamed:@"滑动条球"];
    
    [self.sliderone setMinimumTrackImage:stetchLeftTrack3 forState:UIControlStateNormal];
    [self.sliderone setMaximumTrackImage:stetchRightTrack3 forState:UIControlStateNormal];
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
    [self.sliderone setThumbImage:thumbImage3 forState:UIControlStateHighlighted];
    [self.sliderone setThumbImage:thumbImage3 forState:UIControlStateNormal];
    self.sliderone.dataSource = self;
    self.sliderone.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:14];
    self.sliderone.textColor = [UIColor whiteColor];
    [self.sliderone addTarget:self action:@selector(touchOver) forControlEvents:UIControlEventTouchUpInside];
    self.sliderone.textColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    [self.slidertwo setPopUpViewAnimatedColors:@[coldBlue]];
    [self.slidertwo addTarget:self action:@selector(touchOver) forControlEvents:UIControlEventTouchUpInside];
    [self.slidertwo setMinimumTrackImage:stetchLeftTrack3 forState:UIControlStateNormal];
    [self.slidertwo setMaximumTrackImage:stetchRightTrack3 forState:UIControlStateNormal];
    self.slidertwo.dataSource = self;
    self.slidertwo.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:14];
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
    [self.slidertwo setThumbImage:thumbImage3 forState:UIControlStateHighlighted];
    [self.slidertwo setThumbImage:thumbImage3 forState:UIControlStateNormal];
    _sliders = @[_sliderone, _slidertwo];
    [_sliderone showPopUpView];
    [_slidertwo showPopUpView];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        
    }else {
        self.sliderone.enabled = NO;
        self.slidertwo.enabled = NO;
        [MBProgressHUD showText:@"无权限控制"];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ASValueTrackingSliderDataSource

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value;
{
    value = roundf(value);
    NSString *s;
    //    if (value < -10.0) {
    //        s = @"❄️Brrr!⛄️";
    //    } else if (value > 29.0 && value < 50.0) {
    s = [NSString stringWithFormat:@"当前值:%@Lx,适中", [slider.numberFormatter stringFromNumber:@(value)]];
    //    } else if (value >= 50.0) {
    //        s = @"I’m Melting!";
    //    }
    return s;
}

- (void)touchOver{
   [self SendData];
}
// the behaviour of setValue:animated: is different between iOS6 and iOS7
// need to use animation block on iOS7
- (void)animateSlider:(ASValueTrackingSlider*)slider toValue:(float)value
{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        [UIView animateWithDuration:0.5 animations:^{
            [slider setValue:value animated:YES];
        }];
    }
    else {
        [slider setValue:value animated:YES];
    }
}


-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/app/lights/light",kUrl];
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
    NSLog(@"class:%@",self.classroom_id);
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"获取灯光数据正确%@",responseObject);
        
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
                _model = [[LightModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:_model];
            }
            self.locationLabel.text = _model.localtion;
            self.qingjingLabel.text = _model.scene_name;
            self.planLabel.text = _model.plan_name;
            for (int i=0; i<_dataArr.count; i++) {
                _model = _dataArr[i];
                
                    _sliderone.value = [_model.currentbpower floatValue];
                
                    _slidertwo.value = [_model.currentapower floatValue];
                
            }
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

-(void)SendData{
    NSString *URL = [NSString stringWithFormat:@"%@/app/lights/light/open-light",kUrl];
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
    [parameters setValue:self.model.bid forKey:@"bid"];
    //黑板灯
    NSString *heiban = [NSString stringWithFormat:@"%f",self.sliderone.value];
    [parameters setValue:heiban forKey:@"lamp_a"];
    //教室灯
    NSString *jiaoshi = [NSString stringWithFormat:@"%f",self.slidertwo.value];
    [parameters setValue:jiaoshi forKey:@"lamp_b"];

    NSLog(@"%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"设置净化器正确%@",responseObject);
        

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
//            self.sliderone.value = self.oldClass;
//            self.slidertwo.value = self.oldblack;
        }else{
//            self.oldClass = self.sliderone.value;
//            self.oldblack = self.slidertwo.value;
//            [self requestData];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
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
    [parameters setValue:self.planLabel.text forKey:@"plan"];
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
    NSString *URL = [NSString stringWithFormat:@"%@/app/lights/light/change-scene",kUrl];
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
    [parameters setValue:self.bid forKey:@"scene_id"];

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


-(LightModel *)model{
    if (!_model) {
        _model = [[LightModel alloc] init];
    }
    return  _model;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
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
- (IBAction)lightPlanBtnClick:(id)sender {
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

-(void)PickerSelectorIndixString:(NSString *)str:(NSInteger)row
{
    
    
    if (self.selectedIndexPath==0) {
//        _lightqingjingModel = self.lightqingjingArr[row];
        _model = self.dataArr[row];
//        self.bid = _lightqingjingModel.ID;
        self.qingjingLabel.text = str;
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
        self.planLabel.text = str;
        [self SendPlan];
    }
    
    
}

- (IBAction)AllOnBtnClick:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        if (sender.selected) {
            sender.selected = NO;
        }else{
            sender.selected = YES;

        }
        
    }else {
        [MBProgressHUD showText:@"无权限控制"];
    }

}
- (IBAction)AllOfBtnClick:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [userDefaults valueForKey:@"type"];
    if([type isEqualToString:@"教师"]){
        if (sender.selected) {
            sender.selected = NO;
        }else{
            sender.selected = YES;
            
        }
        
    }else {
        [MBProgressHUD showText:@"无权限控制"];
    }

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
- (IBAction)midBtnClick:(id)sender {
    LightLishiViewController *vc = [[LightLishiViewController alloc] init];
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
