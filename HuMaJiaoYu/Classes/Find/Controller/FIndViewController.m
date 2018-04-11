//
//  FIndViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/24.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "FIndViewController.h"
#import "FindTableViewCell.h"
#import "SearchViewController.h"
#import "FindModel.h"
#import "searchview.h"
#import "searchview.h"
#import "WebViewController.h"
static NSString * const cellIdentifier = @"cellIdentifier";
@interface FIndViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating,UITextFieldDelegate>
@property (nonatomic,strong)UITableView *table;
//搜索控制器
@property (nonatomic, strong) UISearchController *searchController;
//存放tableView中显示数据的数组
@property (strong,nonatomic) NSMutableArray  *dataList;
//存放搜索列表中显示数据的数组
@property (strong,nonatomic) NSMutableArray  *searchList;
@property (nonatomic,assign)int page;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong)FindModel *findModel;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) searchview *headerview;
@end

@implementation FIndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self requestData];
//    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUI{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 66)];
    self.headerview = [[NSBundle mainBundle]loadNibNamed:@"searchview" owner:self options:nil][0];
    self.headerview.searchtextfield.delegate = self;
    [self.topView addSubview:self.headerview];
    [self.view addSubview:self.topView];
//    topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self.view addSubview:self.topView];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0,64 , KWidth, KHeight-64) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.tag = 100102;
    self.table.backgroundColor = [UIColor groupTableViewBackgroundColor];
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


-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%@",textField.text);
    [textField resignFirstResponder];
}


//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _dataArr.count;
    if(tableView==self.table){
        return _dataArray.count;
    }else{
               //如果searchController被激活就返回搜索数组的行数，否则返回数据数组的行数
        if (self.searchController.active) {
            return [self.searchList count];
        }else{
            return [self.dataList count];
        }
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.table) {
        
        static NSString *cellIdentifier =@"Cell";
        FindTableViewCell *cell = (FindTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell ==nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"FindTableViewCell" owner:self options:nil];
                    _findModel = self.dataArray[indexPath.row];
            cell = [nibs lastObject];
                    cell.tipLabel.text = _findModel.title;
                    cell.detailLabel.text = _findModel.subtitle;
                    NSString *string = [_findModel.created_at substringToIndex:10];
                    cell.dateLabel.text = string;
                    cell.rightImage.image = [UIImage imageNamed:@"i1"];
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_findModel.thumbnail]];
            
                    //然后就是添加照片语句，这次不是`imageWithName`了，是 imageWithData。
                    if (data.length > 0) {
                        cell.rightImage.image = [UIImage imageWithData:data];
                    }else{
                        cell.rightImage.image = [UIImage imageNamed:@"图片加载失败"];
                    }
            if (indexPath.row==0){
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWidth, 30)];
                //            imageView.image = [UIImage imageNamed:@"imageName.png"];
                UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 9, 2, 12)];
                line.image = [UIImage imageNamed:@"发现页竖线"];
//                line.backgroundColor = [UIColor grayColor];
                [view addSubview:line];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 100, 20)];
                label.font= [UIFont systemFontOfSize:13];
                label.text = @"热门通知";
                [view addSubview:label];
                [cell.contentView addSubview:view];
            }
        }
        return cell;

    }else{
        static NSString *flag=@"cellFlag";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
        }
        //如果搜索框被激活，就显示搜索数组的内容，否则显示数据数组的内容
        if (self.searchController.active) {
            [cell.textLabel setText:self.searchList[indexPath.row]];
        }
        else{
            [cell.textLabel setText:self.dataList[indexPath.row]];
        }
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 139;
    }else{
        return 109;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.headerview.searchtextfield resignFirstResponder];
    WebViewController *vc = [[WebViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    _findModel = _dataArray[indexPath.row];
    vc.str = _findModel.desc;
//    vc.article_id = _model.ID;
//    vc.title1 = _model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //获取搜索框中用户输入的字符串
    NSString *searchString = [self.searchController.searchBar text];
    //指定过滤条件，SELF表示要查询集合中对象，contain[c]表示包含字符串，%@是字符串内容
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    //如果搜索数组中存在对象，即上次搜索的结果，则清除这些对象
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //通过过滤条件过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.table reloadData];
}

-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/app-notices",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //    [parameters setValue:@"5" forKey:@"limit"];
    //    [parameters setValue:@"文章id" forKey:@"id"];
    NSString *page = [NSString stringWithFormat:@"%d",self.page];
    [parameters setValue:page forKey:@"page"];
    NSString *schoolID = [userDefaults valueForKey:@"schoolID"];
    [parameters setValue:schoolID forKey:@"school_id"];
    NSLog(@"%@",parameters);
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"获取通知正确%@",responseObject);
        if ([responseObject[@"code"] intValue] !=0) {
            NSString *str = responseObject[@"msg"];
            [MBProgressHUD showText:str];
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
                _findModel = [[FindModel alloc] initWithDictionary:dic];
                [self.dataArray addObject:_findModel];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return  _dataArray;
}

-(FindModel *)findModel{
    if (!_findModel) {
        _findModel = [[FindModel alloc] init];
    }
    return _findModel;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.headerview.searchtextfield resignFirstResponder];
}
@end
