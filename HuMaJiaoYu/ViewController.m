//
//  ViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/24.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ViewController.h"
#import "SDCycleScrollView.h"
#import "PurifyViewController.h"
#import "JPUSHService.h"
@interface ViewController ()<SDCycleScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UIScrollView *bgView;
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)NSArray *dataArr1;
@property (nonatomic,strong)NSArray *dataArr2;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UICollectionView *collectionView1;
@property (nonatomic,strong) NSMutableArray *PicArr;
@property (nonatomic,strong) UIButton *leftButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
    [self requestHeaderData];
    [self setUI];
//    [self setLunBo];
    [self setButton];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)setUI{
    self.dataArr = @[@"智能净化",@"智能照明",@"家校通",@"智慧教室",@"文化校园",@"智能多媒体",@"云教育",@"平安动态"];
//    self.dataArr1 =  @[@"在线作业",@"口语作业",@"中学单词宝",@"微门户",@"听学宝",@"3D实验"];
//    self.dataArr2 = @[@"告别传统作业模式",@"听力口语双丰收",@"发现单词之美",@"及时了解学校动态",@"边听边学",@"看3D大片"];
    self.bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.bgView.backgroundColor = [UIColor whiteColor];
//    self.bgView.contentSize = CGSizeMake(self.view.bounds.size.width, KHeight);
    self.bgView.bounces = NO;
    [self.view addSubview:self.bgView];

}

- (void)setLunBo{
    
    // 情景一：采用本地图片实现
    NSArray *images = @[[UIImage imageNamed:@"首页轮播-1"],
                        [UIImage imageNamed:@"首页轮播-2"]
                        ];
    
    // 本地加载 --- 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, KHeight/3-KHeight/667*20) shouldInfiniteLoop:YES imageNamesGroup:self.PicArr];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [self.bgView addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    cycleScrollView.autoScrollTimeInterval = 3.0;
    
    UIView *blueView = [[UIView alloc] init];
    blueView.backgroundColor = RGBColor(117, 164, 221);
    blueView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 30);
    blueView.alpha = 0.7;
    [self.bgView addSubview:blueView];
    
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 150, 30)];
    [self.leftButton setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [self.leftButton setTitle:@"  幼儿园" forState:UIControlStateNormal];
    [self.leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [blueView addSubview:self.leftButton];
    
    UIImageView *jiaImage = [[UIImageView alloc] init];
    jiaImage.frame = CGRectMake(10, 8, 15, 15);
    jiaImage.image = [UIImage imageNamed:@"图层-33"];
    [blueView addSubview:jiaImage];
    
//    UILabel *jiaLabel = [[UILabel alloc] init];
//    jiaLabel.frame = CGRectMake(30, 5, 70, 20);
//    jiaLabel.text = @"幼儿园";
//    jiaLabel.font = [UIFont systemFontOfSize:13];
//    jiaLabel.textColor = [UIColor whiteColor];
//    [blueView addSubview:jiaLabel];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-30, 5, 20, 20)];
    [rightButton setImage:[UIImage imageNamed:@"图层-16"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [blueView addSubview:rightButton];
    
    [self requestSchool];
}

- (void)rightBtnClick{
    self.tabBarController.selectedIndex=3;
}

- (void)setButton{
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //创建collectionView 通过一个布局策略layout来创建
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KHeight/3-KHeight/667*20, [UIScreen mainScreen].bounds.size.width, KHeight/667*150) collectionViewLayout:layout];
    _collectionView.tag= 10001;
    _collectionView.backgroundColor =[UIColor whiteColor];
    //代理设置
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.bounces = NO;
    //注册item类型 这里使用系统的类型
    //    _collectionView.alwaysBounceVertical = YES;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [self.bgView addSubview:_collectionView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,KHeight/3+KHeight/667*150-KHeight/667*20, self.view.bounds.size.width, KHeight/667*10)];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self.bgView addSubview:line];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,KHeight/3+KHeight/667*155-KHeight/667*15 , KWidth, KHeight/667*120)];
//    image.backgroundColor = [UIColor greenColor];
    image.image = [UIImage imageNamed:@"广告页"];
    [self.bgView addSubview:image];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, KHeight/3+KHeight/667*275-KHeight/667*15, self.view.bounds.size.width,KHeight/667* 10)];
    line1.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self.bgView addSubview:line1];

    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, KHeight/3+KHeight/667*370, self.view.bounds.size.width, KHeight/667*10)];
    line2.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self.bgView addSubview:line2];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-50, KHeight/3+KHeight/667*275-KHeight/667*2, 100, KHeight/667*20)];
    textLabel.text = @"快捷区";
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:13];
    textLabel.textColor = [UIColor darkGrayColor];
    [self.bgView addSubview:textLabel];
    
    for (int i=0; i<3; i++) {
        UIButton *kuaijieBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/3*i+(KWidth/3-45)/2, KHeight/3+KHeight/667*295, 45, KHeight/667*45)];
        UILabel *kuaijieLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/3*i, KHeight/3+KHeight/667*340, KWidth/3, KHeight/667*30)];
        kuaijieLabel.textAlignment = NSTextAlignmentCenter;
        kuaijieLabel.font = [UIFont systemFontOfSize:14];
        kuaijieLabel.textColor = [UIColor darkGrayColor];
        if (i==0) {
            [kuaijieBtn setImage:[UIImage imageNamed:@"净化"] forState:UIControlStateNormal];
            [kuaijieBtn addTarget:self action:@selector(FirstBtnClick) forControlEvents:UIControlEventTouchUpInside];
            kuaijieLabel.text = @"智能净化";
        }else if (i==1){
            [kuaijieBtn setImage:[UIImage imageNamed:@"智能照明"] forState:UIControlStateNormal];
            kuaijieLabel.text = @"智能照明";
            [kuaijieBtn addTarget:self action:@selector(SecondBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [kuaijieBtn setImage:[UIImage imageNamed:@"家校"] forState:UIControlStateNormal];
            kuaijieLabel.text = @"家校通";
            [kuaijieBtn addTarget:self action:@selector(ThiredBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }

        [self.bgView addSubview:kuaijieBtn];
        [self.bgView addSubview:kuaijieLabel];
    }

}

- (void)FirstBtnClick{
    PurifyViewController *vc = [[PurifyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = @"净化器";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)SecondBtnClick{
    PurifyViewController *vc = [[PurifyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = @"灯光";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)ThiredBtnClick{}

-(void)requestHeaderData{
    NSString *URL = [NSString stringWithFormat:@"%@/app-banners",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSString *schoolID = [userDefaults valueForKey:@"schoolID"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
//    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
        [parameters setValue:@"index_banner" forKey:@"key"];
    [parameters setValue:schoolID forKey:@"school_id"];
    
    NSLog(@"%@",parameters);
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"获取轮播图正确%@",responseObject);
        
        if ([responseObject[@"code"] intValue] !=0) {
           
                NSString *str = responseObject[@"msg"];
                [MBProgressHUD showText:str];
            
        }else{
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                NSString *picStr = dic[@"image"];
                [self.PicArr addObject:picStr];
            }
            [self setLunBo];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
-(void)requestSchool{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSString *schoolID = [userDefaults valueForKey:@"schoolID"];
    [userDefaults synchronize];
    NSString *URL = [NSString stringWithFormat:@"%@/schools/%@",kUrl,schoolID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setValue:schoolID forKey:@"id"];
    [parameters setValue:token forKey:@"token"];
    
    NSLog(@"%@",parameters);
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"获取学校正确%@",responseObject);
        
        if ([responseObject[@"code"] intValue] !=0) {
            
            NSString *str = responseObject[@"msg"];
            [MBProgressHUD showText:str];
            
        }else{
            NSString *str = responseObject[@"data"][@"name"];
            [self.leftButton setTitle:str forState:UIControlStateNormal];
            
            
           
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/me",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    
    [userDefaults synchronize];
    //    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:token forKey:@"token"];
    
    NSLog(@"%@",parameters);
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"获取个人信息正确%@",responseObject);
        NSNumber *code = responseObject[@"code"];
        if (code !=0) {
            
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"4003"])  {
                [MBProgressHUD showText:@"请重新登陆"];
//                [self newLogin];
            }else{
                //            NSString *str = responseObject[@"msg"];
                //            [MBProgressHUD showText:str];
            }
        }else{
            if([responseObject[@"content"] isEqual:[NSNull null]])
            {
                
            }else{
                
                
                NSString *school_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"me"][@"school_id"]];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *type = [userDefaults valueForKey:@"type"];
                if ([type isEqualToString:@"学生"]) {
                    NSString *classroome = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"me"][@"student"][@"classroom_id"]];
                    NSString *str = [NSString stringWithFormat:@"school_%@_class_%@",school_id,classroome];
                    [JPUSHService setTags:str alias:str fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        NSLog(@"设置别名成功%d-------------%@,-------------%@",iResCode,iTags,iAlias);
                    }];
                    [JPUSHService setAlias:@"123" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:nil];
                }else{
                    NSString *classroome = @"";
                    NSString *str = [NSString stringWithFormat:@"school_%@_class_%@",school_id,classroome];
                    [JPUSHService setTags:str alias:str fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        NSLog(@"设置别名成功%d-------------%@,-------------%@",iResCode,iTags,iAlias);
                    }];
                    [JPUSHService setAlias:@"123" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:nil];
                }
//                NSString *nameText = stuname;
//                [self.nameBtn setTitle:nameText forState:UIControlStateNormal];
//                NSString *tel = responseObject[@"data"][@"phone"];
//                self.phoneLabel.text = [NSString stringWithFormat:@"手机:%@",tel];
//                NSString *picURL = responseObject[@"data"][@"avatar"];
//
//                //然后就是添加照片语句，这次不是`imageWithName`了，是 imageWithData。
//                if (![picURL.class isEqual:[NSNull class]]) {
//                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]];
//                    self.touImage.image = [UIImage imageWithData:data];
//                }else{
//                    self.touImage.image = [UIImage imageNamed:@"moren"];
//                }
                
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width/4-10,220/3);
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
    return self.dataArr.count;
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor =[UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width/4-1, 10)];
    //    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-30, cell.bounds.size.height/2-20, 100, 40)];
    nameLabel.text = self.dataArr[indexPath.row];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:12];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.contentView addSubview:nameLabel];
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake((cell.bounds.size.width-45)/2+2, (cell.bounds.size.height-59)/2+3, 40, 40)];
    imageView.image =[UIImage imageNamed:[NSString stringWithFormat:@"home%zd",indexPath.row+1]];
    [cell.contentView addSubview:imageView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld个",(long)indexPath.row+ 1);
    if (indexPath.row == 3) {
       
    }else if (indexPath.row == 1){
        PurifyViewController *vc = [[PurifyViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = @"灯光";
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 0){
        PurifyViewController *vc = [[PurifyViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.type = @"净化器";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [MBProgressHUD showText:@"暂未开放"];
    }
}

-(NSMutableArray *)PicArr{
    if (!_PicArr) {
        _PicArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _PicArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
