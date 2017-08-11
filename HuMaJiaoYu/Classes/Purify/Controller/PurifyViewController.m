//
//  PurifyViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/26.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "PurifyViewController.h"
#import "PurifyCollectionViewCell.h"
#import "LightViewController.h"
#import "PurifyControlViewController.h"
#import "ClassListModel.h"
#import "LoginViewController.h"
@interface PurifyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) ClassListModel *model;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation PurifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择教室";
    // Do any additional setup after loading the view.
    [self setUI];
    [self requestData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)setUI{
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
    bgView.image = [UIImage imageNamed:@"教室选择-智能净化bg"];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //创建collectionView 通过一个布局策略layout来创建
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, KHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.tag= 10001;
    //    _collectionView.backgroundColor =[UIColor whiteColor];
    //代理设置
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.bounces = NO;
    //注册item类型 这里使用系统的类型
    //    _collectionView.alwaysBounceVertical = YES;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [bgView addSubview:_collectionView];
    
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(KWidth/2-5,KHeight/667*84);
}
//定义每个Section 的 margin
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UINib *nib = [UINib nibWithNibName:@"PurifyCollectionViewCell"bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"cellid"];
    PurifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    _model = _dataArr[indexPath.row];
    NSInteger status = [_model.status integerValue];
    if (status ==1) {
        cell.statusBgImg.image = [UIImage imageNamed:@"绿圆"];
    }else if (status ==2) {
        cell.statusBgImg.image = [UIImage imageNamed:@"红圆"];
    }else if (status ==3) {
        cell.statusBgImg.image = [UIImage imageNamed:@"灰圆"];
    }
    cell.locationLabel.text = _model.location;
    cell.classroomLabel.text = _model.class_name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld个",(long)indexPath.row+ 1);
    if([self.type isEqualToString:@"净化器"]){
        PurifyControlViewController *vc = [[PurifyControlViewController alloc] init];
        _model = _dataArr[indexPath.row];
        vc.classroom_id = _model.classroom_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        LightViewController *vc = [[LightViewController alloc] init];
                _model = _dataArr[indexPath.row];
                vc.classroom_id = _model.classroom_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)requestData{
    if([self.type isEqualToString:@"净化器"]){
        NSString *URL = [NSString stringWithFormat:@"%@/app/air_cleaners/air_cleaner/get-classes-status",kUrl];
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
            MyLog(@"获取净化器列表正确%@",responseObject);
            
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
                NSArray *arr = responseObject[@"content"][@"class_list"];
                if (arr.count>0) {
                    for (int i=0; i<arr.count; i++) {
                        NSDictionary *dic = arr[i];
                        _model = [[ClassListModel alloc] initWithDictionary:dic];
                        [self.dataArr addObject:_model];
                    }
                    [self.collectionView reloadData];
                }else{
                   [MBProgressHUD showText:@"暂无班级列表"];
                }
                
                
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            MyLog(@"失败%@",error);
            //        [MBProgressHUD showText:@"%@",error[@"error"]];
        }];
    }else {
        NSString *URL = [NSString stringWithFormat:@"%@/app/lights/light/get-classes-status",kUrl];
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
            MyLog(@"获取灯光列表正确%@",responseObject);

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
                NSArray *arr = responseObject[@"content"][@"class_list"];
                if (arr.count>0) {
                    for (int i=0; i<arr.count; i++) {
                        NSDictionary *dic = arr[i];
                        _model = [[ClassListModel alloc] initWithDictionary:dic];
                        [self.dataArr addObject:_model];
                    }
                    [self.collectionView reloadData];

                }else{
                    [MBProgressHUD showText:@"暂无班级列表"];
                }
                
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            MyLog(@"失败%@",error);
            //        [MBProgressHUD showText:@"%@",error[@"error"]];
        }];
    }
    
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


-(ClassListModel *)model{
    if (!_model) {
        _model = [[ClassListModel alloc] init];
    }
    return _model;
}

-(NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
