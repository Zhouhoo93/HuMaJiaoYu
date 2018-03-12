//
//  RegisterViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/24.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "RegisterViewController.h"
#import "ParentRegisterViewController.h"
#import "StudentRegisterViewController.h"
#import "PopUpView.h"
#import "PopModel.h"
#import "Header.h"
@interface RegisterViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *yaoqingmaText;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIButton *selectbtn;
@property (nonatomic, strong) PopUpView *showView;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSelect];
    // Do any additional setup after loading the view from its nib.
}
-(void)setSelect{
    self.dataArr = [NSMutableArray array];
    NSArray *arr = @[@{@"name":@"教师"},@{@"name":@"学生"},@{@"name":@"家长"}];
    for (NSDictionary *dic in arr) {
        [_dataArr addObject:[PopModel modelWithdic:dic]];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    
}

- (IBAction)selectBtnClick:(id)sender {
    UIActionSheet *actionsheet03 = [[UIActionSheet alloc] initWithTitle:@"选择身份" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"学生", @"家长",@"教师",  nil];
    // 显示
    [actionsheet03 showInView:self.view];
    

}
- (void)tap:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (IBAction)registerBtnClick:(id)sender {
    [self requestSchoolid];

    
}

- (void)requestSchoolid {
    NSString *URL = [NSString stringWithFormat:@"%@/schools/get-by-code",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.yaoqingmaText.text forKey:@"code"];
    NSLog(@"参数:%@",parameters);
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"正确%@",responseObject);
        NSString *schoolID = [[NSString alloc] init];
        schoolID = [responseObject[@"data"][@"id"] stringValue];
        
        if(schoolID.length>0){
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:schoolID forKey:@"schoolID"];
            
            if ([self.selectbtn.titleLabel.text isEqualToString:@"家长"]) {
                ParentRegisterViewController *vc = [[ParentRegisterViewController alloc] init];
                vc.schoolCode = self.yaoqingmaText.text;
                [self.navigationController pushViewController:vc animated:YES];
            }else if([self.selectbtn.titleLabel.text isEqualToString:@"学生"]){
                StudentRegisterViewController *vc = [[StudentRegisterViewController alloc] init];
                vc.schoolCode = self.yaoqingmaText.text;
                [self.navigationController pushViewController:vc animated:YES];
            }else if([self.selectbtn.titleLabel.text isEqualToString:@"教师"]){
                
            }else{
                [MBProgressHUD showText:@"请先选择身份"];
            }
            
        }else{
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// UIActionSheetDelegate实现代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex=%ld", buttonIndex);
    
    
    if (0 == buttonIndex)
    {
        NSLog(@"点击了学生按钮");
        [_selectbtn setTitle:@"学生" forState:0];
    }
    else if (1 == buttonIndex)
    {
        NSLog(@"点击了家长按钮");
        [_selectbtn setTitle:@"家长" forState:0];
    }
    else if (2 == buttonIndex)
    {
        NSLog(@"点击了教师按钮");
        [_selectbtn setTitle:@"教师" forState:0];
    }else if (3 == buttonIndex)
    {
        NSLog(@"点击了取消按钮");
    }
    
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
