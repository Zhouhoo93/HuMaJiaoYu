//
//  NoticeViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/25.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"
#import "NoticeModel.h"
#import "LoginViewController.h"
@interface NoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,assign)int page;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong)NoticeModel *noticeModel;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.title = @"学校信息";
    self.page = 1;
    [self requestData];
    self.title = @"发现";
    [self setUI];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.hidden = NO;
}
-(void)setUI{
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64-44) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    
    //     设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    // 隐藏时间
    //    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    //    header.stateLabel.hidden = YES;
    self.table.mj_header = header;
    self.table.mj_header.ignoredScrollViewContentInsetTop = self.table.contentInset.top;
    
    //上拉加载
    self.table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //在刷新数据覆盖不显示数据的 cell 的分割线,如果不设置,则会显示 cell 的分割线
    UIView *footView = [UIView new];
    self.table.tableFooterView = footView;

}
- (void)refresh{
    self.page = 1;
    
    [self requestData];
    
}
- (void)loadMoreData {
    //    //1, 获取数据源
    //    for (int i = 0; i < 5; i++) {
    //        NSString *string = [NSString stringWithFormat:@"+++山本%d", arc4random_uniform(1000)];
    //        [self.dataSource addObject:string];
    //    }
    //    //2,刷新数据
    //    [self.tableView reloadData];
    //    //3,关闭刷新
    //    [self.tableView.mj_footer endRefreshing];
    self.page++;
     [self.table.mj_footer resetNoMoreData];
    [self requestData];
    
}
-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/app-posts",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *schoolID = [userDefaults valueForKey:@"schoolID"];
//    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setValue:@"5" forKey:@"limit"];
    //    [parameters setValue:@"文章id" forKey:@"id"];
    NSString *page = [NSString stringWithFormat:@"%d",self.page];
    [parameters setValue:page forKey:@"page"];
    [parameters setValue:schoolID forKey:@"school_id"];
    
    NSLog(@"%@",parameters);
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"获取文章正确%@",responseObject);

        if ([responseObject[@"code"] intValue] !=0) {
            NSNumber *code = responseObject[@"code"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"4003"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
            NSString *str = responseObject[@"msg"];
            [MBProgressHUD showText:str];
            }
        }else{
            if (self.page<2) {
                [self.dataArr removeAllObjects];
            }
            NSArray *arr = responseObject[@"content"];
            if (arr.count>0) {
                
            }else{
                self.page--;
            }
            for (NSDictionary *dic in responseObject[@"data"][@"data"]) {
                _noticeModel = [[NoticeModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:_noticeModel];
            }
            [self.table reloadData];
            if (self.table) {
                [self.table.mj_header endRefreshing];
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell)
    {
       
        [tableView registerNib:[UINib nibWithNibName:@"NoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
    }
    NoticeModel *model = self.dataArr[indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    cell.titleLabel.text = model.title;
    cell.creatTimelabel.text = model.created_at;
    cell.descLabel.text = model.desc;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.thumbnail]];
    
    //然后就是添加照片语句，这次不是`imageWithName`了，是 imageWithData。
    if (data.length > 0) {
        cell.pictureImage.image = [UIImage imageWithData:data];
    }else{
        cell.pictureImage.image = [UIImage imageNamed:@"图片加载失败"];
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    
    NSDateFormatter *date1 = [[NSDateFormatter alloc]init];
    [date1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date1 dateFromString:model.created_at];
    NSDate *endD = [date1 dateFromString:DateTime];
    NSString *str;
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 4.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:startD toDate:endD options:0];
    // 5.输出结果
    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    if (cmps.day != 0) {
        NSString *str1 = [NSString stringWithFormat:@"%@",model.created_at];
        str = [str1 substringToIndex:10];;
        
    }else if (cmps.day==0 && cmps.hour != 0) {
        str = [NSString stringWithFormat:@"%zd小时前",cmps.hour];
        
    }else if (cmps.day== 0 && cmps.hour== 0 && cmps.minute!=0) {
        str = [NSString stringWithFormat:@"%zd分钟前",cmps.minute];
        
    }else{
        str = [NSString stringWithFormat:@"1分钟前"];
        
    }
    cell.topTime.text = str;

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 296;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return  _dataArr;
}

-(NoticeModel *)noticeModel{
    if (!_noticeModel) {
        _noticeModel = [[NoticeModel alloc] init];
    }
    return _noticeModel;
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
