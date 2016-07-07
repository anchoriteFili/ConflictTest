//
//  FindResultList.m
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/24.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import "FindResultList.h"
#import "FindResultListModel.h"
#import "MGSwipeButton.h"
#import "FindResListCell.h"
#import "OrderFindResultCell.h"


#import "ChooseContentTVCell.h" // 选项内容cell
#import "Find_BottomCustomTVCell.h" // 价钱区间cell
#import "Find_BottomDateTVCell.h" // 出发时间cell


#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "Find_ChooseVC.h"
#import "Find_PriceVC.h"
#import "HttpRequestTools.h"
#import "IWHttpTool.h"
#import "UIButton+InitButton.h"
#import <ShareSDK/ShareSDK.h>
#import "MJRefresh.h"
#import "DetailWebViewController.h"
#import "conditionModel.h"
#import "YYAnimationIndicator.h"
#import "SearchViewController.h"
#import "WriteFileManager.h"
#import "ChatViewController.h"
#import "WriteFileManager.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"

#define screenSize [UIScreen mainScreen].bounds.size
@interface FindResultList ()<UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate, UISearchBarDelegate, transformSelectConditionDelegate, transformSelectPriceDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UITableView *chooseTableView; //选项框tableView
@property (weak, nonatomic) IBOutlet UITableView *chooseContentTableView; //选项显示内容tableView


@property (weak, nonatomic) IBOutlet UITableView *orderTableView;

@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet UIScrollView *HeadScrolView;//标签
@property (strong,nonatomic) UIView *HeadLabelV;//标签下边的view
@property (nonatomic,strong) NSArray *HeadLabelDataArr;//标签数据
@property (nonatomic) UIView *HeadLabelMenuView;//展开的标签view
@property (nonatomic) UIView *HeadLabelBGV;//标签蒙层
@property (nonnull,strong) NSMutableDictionary *conditionDic;//标签栏请求参数


#pragma mark 下部功能栏
@property (weak, nonatomic) IBOutlet UIButton *routeButton; //游玩路线按钮
@property (weak, nonatomic) IBOutlet UIButton *timeButton; //时间天数button
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn; //筛选按钮
@property (weak, nonatomic) IBOutlet UIButton *orderBtn; //排序按钮



@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *backToTop;
@property (nonatomic, strong) UIButton *pageCountBtn;
//@property (nonatomic, copy)NSString *PN;

- (IBAction)chooseBtn:(id)sender;
- (IBAction)orderBtn:(id)sender;
- (IBAction)backToTopBtn:(id)sender;
@property(nonatomic,assign) long productCount;
@property (nonatomic,assign)  CGFloat oldOffset;
@property (nonatomic) BOOL isAnimation;
@property (nonatomic, strong)NSMutableDictionary *shareIn;
@property (nonatomic, assign)BOOL fresh;

@property (nonatomic, assign)BOOL routeFlag; //判断_路线按钮点击
@property (nonatomic, assign)BOOL timeFlag; //判断_时间按钮点击
@property (nonatomic, assign)BOOL chooseFlag; //判断_筛选按钮点击
@property (nonatomic, assign)BOOL orderFlag; //判断_排序按钮点击


@property (weak, nonatomic)UISearchBar *searchB;
@property (nonatomic, strong)NSMutableArray *productListArr;
@property (nonatomic, strong)NSMutableArray *conditionListArr;
@property (nonatomic, strong)NSMutableDictionary *HeadLConditionDic;//头部标签请求参数

@property (nonatomic,assign) BottomViewEnum bottomEnum; // 用来判断底部路线、时间、筛选三个按钮的选择
@property (nonatomic,assign) BottomCellStyleEnum bottomCellStyleEnum; // 定义cell样式

@property (nonatomic,strong) NSArray *routeArray; // 路线左边数据
@property (nonatomic,strong) NSArray *timeArray; // 时间左边数据

@property (nonatomic, strong)NSArray *chooseArr; // 保存了选项框中的内容，自定义
//self.chooseArr = @[@"价格区间", @"出发城市",@"行程天数",@"游览线路",@"出发日期",@"主题推荐"];

@property (nonatomic, strong)NSArray *orderArr; //综合排序中填写内容
//self.orderArr = @[@"综合排序", @"价格从高到低", @"价格从低到高"];


@property(nonatomic,strong) NSArray *keydataArr; //选项tableView中对应的按照对应顺序
//self.keydataArr = @[@"PriceRange",@"StartCity",@"ScheduleDays",@"ProductBrowseTag",@"GoDate",@"ProductThemeTag"];


@property (nonatomic,strong) NSMutableDictionary *bottomViewContentDic; //底部四个按钮的数据的存储

@property (strong,nonatomic) NSMutableArray *subIndicateDataArr1; // 用于存储出发城市数据



@property (nonatomic, copy)NSString *ProductBrowseTagID;//游览路线
@property (nonatomic, copy)NSString *StartDate;
@property (nonatomic, copy)NSString *EndDate;
@property (nonatomic, copy)NSString *GoDate;
@property (nonatomic, copy)NSString *ScheduleDays;
@property (nonatomic, copy)NSString *StartCity;
@property (nonatomic, copy)NSString *ProductThemeTagID;
@property (nonatomic, copy)NSString *MinPrice;
@property (nonatomic, copy)NSString *MaxPrice;
@property (nonatomic, copy)NSString *ProductSortingType;
@property (nonatomic, copy)NSString *SearchSource;//搜索来源 1导航搜索 2关键词搜索

@property (nonatomic, copy)NSString *PageSize;
@property (nonatomic, assign)NSInteger PageIndex;
@property (nonatomic, assign)NSInteger primaryNu;//传过来的价格区间预选值
@property (strong,nonatomic) NSMutableDictionary *dic;//当前条件开关


@property (strong,nonatomic) NSMutableDictionary *dicC;
@property (nonatomic, strong)NSMutableDictionary *showDic;
@property (nonatomic, strong)NSMutableDictionary *SSDic;


@property (nonatomic, assign)BOOL isRefresh;

@property (weak, nonatomic) IBOutlet UIView *FindEmptyView;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (nonatomic, assign)BOOL isEnsure;
@property (nonatomic, assign)BOOL isSearchKey;

@property (nonatomic, assign)NSInteger pNum;
@property (nonatomic,assign)NSInteger tempPNum;

@end

#pragma mark 全局变量部分
static NSString *chooseContentCellIdentifier = @"chooseContentTVCell"; //选项内容tableView标记
static NSString *find_BottomCustomTVCellIdentifier = @"find_BottomCustomTVCell"; //价格区间cell
static NSString *find_BottomDateTVCellIdentifier  = @"find_BottomDateTVCell"; //出发日期cell

@implementation FindResultList
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearData) name:@"clearData" object:@"findResultData"];
    
    self.isText = @"findResultList";
    self.navigationItem.leftBarButtonItem = nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.chooseTableView.delegate = self;
    self.chooseTableView.dataSource = self;
    self.chooseContentTableView.delegate = self;
    self.chooseContentTableView.dataSource = self;
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;
    
    [self findResultListLeftBarItem];
    [self findResultListCenterBarItem];
    [self findResultListRightBarItem];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.indicator];
    
    //    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
    self.bottomEnum = RouteButtonEnum; // 初始化显示旅游路线
    // 游玩路线
    self.routeArray = @[@"出发城市", @"游览路线"];
    
    // 时间天数
    self.timeArray = @[@"出发日期", @"行程天数"];
    
    
    self.tableView.delegate = self;
    self.chooseArr = @[@"价格区间", @"路线等级",@"出行方式",@"酒店类型"];
    self.subIndicateDataArr1 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ",@" ",@" ", nil];
    
    self.orderArr = @[@"综合排序", @"价格从高到低", @"价格从低到高"];
    self.keydataArr = @[@"PriceRange",@"StartCity",@"ScheduleDays",@"ProductBrowseTag",@"GoDate",@"ProductThemeTag"];
    
    self.ProductSortingType = @"0";
    
    [self initPull];
    
    self.pageCountBtn = [UIButton buttonWithTitle:@"" image:nil CGFloat:12.0f frame:CGRectMake(0,self.backToTop.frame.size.height/2+3, self.backToTop.frame.size.width, self.backToTop.frame.size.height/3)];
    self.pageCountBtn.userInteractionEnabled = NO;
    [self.backToTop addSubview:self.pageCountBtn];
    [self.view addSubview:self.backToTop];
    [self.view addSubview:self.chooseView];
    [self.view addSubview:self.orderView];
    self.isAnimation = NO;
    self.isSearchKey = NO;
    
#pragma mark 底部四个按钮部分
    // 选项内容tableView添加标记
    [self.chooseContentTableView registerNib:[UINib nibWithNibName:@"ChooseContentTVCell" bundle:nil] forCellReuseIdentifier:chooseContentCellIdentifier];
    [self.chooseContentTableView registerNib:[UINib nibWithNibName:@"Find_BottomCustomTVCell" bundle:nil] forCellReuseIdentifier:find_BottomCustomTVCellIdentifier];
    [self.chooseContentTableView registerNib:[UINib nibWithNibName:@"Find_BottomDateTVCell" bundle:nil] forCellReuseIdentifier:find_BottomDateTVCellIdentifier];
    
    // 再次对4个按钮进行代码约束
    CGFloat downViewWidth = GETWIDTH(self.downView);
    if (WIDTH == 375.0) {
        
        self.routeButton.center = CGPointMake(WIDTH/8, 25);
        self.timeButton.center = CGPointMake(downViewWidth/8*3+1, 25);
        self.chooseBtn.center = CGPointMake(downViewWidth/8*5-2, 25);
        self.orderBtn.center = CGPointMake(downViewWidth/8*7-5, 25);
    } else if (WIDTH == 414.0) {
        
        self.routeButton.center = CGPointMake(WIDTH/8-2, 25);
        self.timeButton.center = CGPointMake(downViewWidth/8*3+2, 25);
        self.chooseBtn.center = CGPointMake(downViewWidth/8*5-2, 25);
        self.orderBtn.center = CGPointMake(downViewWidth/8*7-8, 25);
    }
    
    [self.view addSubview:self.downView];
    
}
//创建头部标签
-(void)creatHeadLabel{
    self.HeadScrolView.contentSize = CGSizeMake(MyScreenSize.width/5*self.HeadLabelDataArr.count+MyScreenSize.width/5, 45);
    
    _HeadLabelV = [[UIView alloc] initWithFrame:CGRectMake(0, 42, MyScreenSize.width/5, 3)];
    _HeadLabelV.backgroundColor = [UIColor colorWithRed:255.0/225.0 green:153.0/225.0 blue:0/225.0 alpha:1];
    [self.HeadScrolView addSubview:_HeadLabelV];
    
    UIView *HeadLowLabV = [[UIView alloc]initWithFrame:CGRectMake(0, 44, MyScreenSize.width, 1)];
    HeadLowLabV.backgroundColor = [UIColor lightGrayColor];
    HeadLowLabV.alpha = 0.3;
    [self.view addSubview:HeadLowLabV];
    
    if (self.HeadLabelDataArr.count > 4) {
        UIButton *headRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(MyScreenSize.width-45, 0, 45, 45)];
        [headRightBtn addTarget:self action:@selector(HeadLabelRBtn:) forControlEvents:UIControlEventTouchUpInside];
        headRightBtn.tag = 101;
        [headRightBtn setBackgroundColor:[UIColor whiteColor]];
        [headRightBtn setImage:[UIImage imageNamed:@"FindPLableM"] forState:UIControlStateNormal];
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 45)];
        rightView.backgroundColor = [UIColor lightGrayColor];
        rightView.alpha = 0.3;
        [headRightBtn addSubview:rightView];
        UIView *lowRightV = [[UIView alloc] initWithFrame:CGRectMake(0, 44, headRightBtn.frame.size.width, 1)];
        lowRightV.backgroundColor = [UIColor lightGrayColor];
        lowRightV.alpha = 0.3;
        [headRightBtn addSubview:lowRightV];
        [self.view addSubview:headRightBtn];
    }
    for (NSInteger i = 0; i < self.HeadLabelDataArr.count; i++) {
        NSDictionary *dic = self.HeadLabelDataArr[i];
        UIButton *HeadLabelB = [[UIButton alloc] initWithFrame:CGRectMake(i%self.HeadLabelDataArr.count*MyScreenSize.width/4.5,10, MyScreenSize.width/5, 26)];//42
        [HeadLabelB setTitle:[NSString stringWithFormat:@"%@",dic[@"Text"]] forState:UIControlStateNormal];
        [HeadLabelB setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
        [HeadLabelB setTitleColor:[UIColor colorWithRed:255.0/225.0 green:153.0/225.0 blue:0/225.0 alpha:1] forState:UIControlStateSelected];
        HeadLabelB.tag = 301+i;
        HeadLabelB.titleLabel.font = [UIFont systemFontOfSize:14];
        [HeadLabelB addTarget:self action:@selector(HeadLabelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [HeadLabelB setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        if (i == 0) {
            HeadLabelB.selected = YES;
        }
        [self.HeadScrolView addSubview:HeadLabelB];
    }
}
-(void)HeadLabelBtn:(UIButton *)button{
    for (NSInteger i = 301; i < 301 + self.HeadLabelDataArr.count; i++) {
        UIButton *Btn = (UIButton *)[self.view viewWithTag:i];
        if (button.tag == i) {
            Btn.selected = YES;
            [UIView animateWithDuration:0.1 animations:^{
                CGRect headVFrame = _HeadLabelV.frame;
                headVFrame.origin.x = Btn.frame.origin.x;
                _HeadLabelV.frame = headVFrame;
            } completion:nil];
            if (self.HeadLabelBGV) {
                UIButton *RihtHeadBtn = (UIButton *)[self.view viewWithTag:101];
                if (RihtHeadBtn.selected) {
                    RihtHeadBtn.selected = NO;
                }
                [self.HeadLabelMenuView removeFromSuperview];
                [self.HeadLabelBGV removeFromSuperview];
                
            }
            //刷新数据
            
            NSInteger ConditionT = i - 301;
            NSDictionary *dic =self.HeadLabelDataArr[ConditionT];
            [self.HeadLConditionDic setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"Value"]] forKey:@"LineType"];
            NSLog(@"---%@",self.HeadLConditionDic);
            [self initPull];
        }else{
            Btn.selected = NO;
        }
        
    }
}
-(void)HeadLabelRBtn:(UIButton *)button{
    
    if (button.selected) {
        button.selected = NO;
        [self.HeadLabelMenuView removeFromSuperview];
        [self.HeadLabelBGV removeFromSuperview];
    }else{
        button.selected = YES;
        [self.view addSubview:self.HeadLabelBGV];
        [self.view addSubview:self.HeadLabelMenuView];
        for (NSInteger i = 301; i < 301 + self.HeadLabelDataArr.count; i++) {
            UIButton *LowMenuBtn = (UIButton *)[self.view viewWithTag:i];
            if (LowMenuBtn.selected){
                for (NSInteger p = 401; p < 401+self.HeadLabelDataArr.count;p++) {
                    UIButton *tallBtnP = (UIButton *)[self.view viewWithTag:p];
                    if (LowMenuBtn.tag == p - 100) {
                        tallBtnP.selected = true;
                    }else{
                        tallBtnP.selected = false;
                    }
                }
            }
        }
    }
    
}
-(void)HeadLabelMenuBtn:(UIButton *)button{
    for (NSInteger x = 401; x < 401+self.HeadLabelDataArr.count; x++) {
        UIButton *but = (UIButton *)[self.view viewWithTag:x];
        if (button.tag == x) {
            but.selected = YES;
            for (NSInteger y = 301; y <301+self.HeadLabelDataArr.count; y++) {
                UIButton *TallMenuBtn = (UIButton *)[self.view viewWithTag:y];
                if (x == y+100) {
                    TallMenuBtn.selected = YES;
                    //                    NSLog(@"%@",self.HeadScrolView.contentInset);
                    if (self.HeadLabelDataArr.count > 4) {
                        if (y > 304) {
                            NSInteger abc = y-300;
                            NSInteger dce = abc - 4;
                            CGPoint newOffset = self.HeadScrolView.contentOffset;
                            newOffset.x = MyScreenSize.width/5*dce;
                            [self.HeadScrolView setContentOffset:newOffset animated:YES];
                        }else{
                            CGPoint newOffset = self.HeadScrolView.contentOffset;
                            newOffset.x = 0;
                            [self.HeadScrolView setContentOffset:newOffset animated:YES];
                        }
                        
                    }
                    [UIView animateWithDuration:0.1 animations:^{
                        CGRect headVFrame = _HeadLabelV.frame;
                        headVFrame.origin.x = TallMenuBtn.frame.origin.x;
                        _HeadLabelV.frame = headVFrame;
                    } completion:nil];
                }else{
                    TallMenuBtn.selected = NO;
                }
            }
            //刷新数据
            for (NSDictionary *dic in self.HeadLabelDataArr) {
                for (NSString *key in dic) {
                    if ([key isEqualToString:[NSString stringWithFormat:@"%@",but.titleLabel.text]]) {
                        [self.HeadLConditionDic setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"Value"]] forKey:@"LineType"];
                        NSLog(@"---%@",self.HeadLConditionDic);
                        [self initPull];
                    }
                }
            }
        }else{
            but.selected = NO;
        }
    }
    UIButton *HeadRightB = (UIButton *)[self.view viewWithTag:101];
    HeadRightB.selected = NO;
    [self.HeadLabelMenuView removeFromSuperview];
    [self.HeadLabelBGV removeFromSuperview];
}
-(void)findResultListLeftBarItem{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0,0,55,15);
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(-1, -10, 0, 50);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
//- (void)setNav{
//    UIImage * bgimage = [UIImage imageNamed:@"navbar"];
//    UIEdgeInsets insets = UIEdgeInsetsZero;
//    // 指定为拉伸模式，伸缩后重新赋值
//    bgimage = [bgimage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
//    [self.navigationController.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
//}

- (void)back{
    [self clearData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击确定按钮进行刷新
- (void)initPull{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headFresh)];
    [_tableView.mj_header beginRefreshing];
    
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(foodFresh)];
}

- (void)headFresh{
    self.PageIndex = 1;
    self.isRefresh = YES;
    [self loadData];
}
- (void)foodFresh{
    self.isRefresh = NO;
    self.PageIndex ++;
    if (self.PageIndex  > [self getTotalPage]) {
        [_tableView.mj_footer endRefreshing];
    }else{
        [self loadData];
    }
    
}
- (NSInteger)getTotalPage{
    NSInteger cos = self.productCount % 10;
    if (cos == 0) {
        return self.productCount / 10;
    }else{
        return self.productCount / 10 + 1;
    }
}
#pragma mark - 数据加载
- (void)loadData{
    // [self.indicator startAnimation];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.SearchKey forKey:@"SearchKey"];
    [dic setObject:[NSString stringWithFormat:@"%@",self.ProductSortingType] forKey:@"ProductSortingType"];
    [dic setObject:[NSString stringWithFormat:@"%d",self.findListFrom+1] forKey:@"SearchSource"];// /*self.SearchSource]*/
    [dic setObject:@"10" forKey:@"PageSize"];
    [dic setObject:[NSString stringWithFormat:@"%ld",self.PageIndex] forKey:@"PageIndex"];
    [dic addEntriesFromDictionary:self.dic];
    [dic addEntriesFromDictionary:self.HeadLConditionDic];
    NSLog(@"dic  = %@", dic);
    
    
    [HttpRequestTools postWithURL:@"Product/GetProductList" params:dic success:^(id json) {
        // [self.indicator stopAnimationWithLoadText:@"加载完成" withType:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        NSLog(@".json....%@", json);
        
        if (self.isRefresh) {
            [self.productListArr removeAllObjects];
            //            [self.conditionListArr removeAllObjects];
            //            self.conditionDic = nil;
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        for (NSDictionary *dic in json[@"ProductList"]) {
            FindResultListModel *model = [FindResultListModel modalWithDict:dic];
            [self.productListArr addObject:model];
        }
        
        NSLog(@"dic =============== %@",json[@"ProductConditionList"]);
        
        
        for (NSDictionary *dic in json[@"ProductConditionList"]) {
            
            
            
            if (self.isSearchKey == NO) {
                [self.conditionListArr addObject:dic];
            }
            //取出顶部标签数据
            if (self.HeadLabelDataArr.count == 0) {
                for (NSString *key in dic) {
                    NSLog(@"%@",key);
                    if ([key  isEqual: @"ConditionType"]) {
                        self.HeadLabelDataArr = dic[@"ConditionType"];
                        [self creatHeadLabel];
                    } else if ([key isEqualToString:@"StartCity"]) {
                        // 出发城市
                        [self.bottomViewContentDic setObject:dic[@"StartCity"] forKey:@"出发城市"];
                        
                    } else if ([key isEqualToString:@"ScheduleDays"]) {
                        // 行程天数
                        [self.bottomViewContentDic setObject:dic[@"ScheduleDays"] forKey:@"行程天数"];
                        
                    } else if ([key isEqualToString:@"ProductBrowseTag"]) {
                        // 游览路线
                        [self.bottomViewContentDic setObject:dic[@"ProductBrowseTag"] forKey:@"游览路线"];
                        
                    } else if ([key isEqualToString:@"GoDate"]) {
                        // 出发日期
                        [self.bottomViewContentDic setObject:dic[@"GoDate"] forKey:@"出发日期"];
                        
                    } else if ([key isEqualToString:@"HotelStandard"]) {
                        // 酒店类型
                        [self.bottomViewContentDic setObject:dic[@"HotelStandard"] forKey:@"酒店类型"];
                        
                    } else if ([key isEqualToString:@"TrafficType"]) {
                        // 出行方式
                        [self.bottomViewContentDic setObject:dic[@"TrafficType"] forKey:@"出行方式"];
                        
                    } else if ([key isEqualToString:@"ProductLevel"]) {
                        // 路线等级
                        [self.bottomViewContentDic setObject:dic[@"ProductLevel"] forKey:@"路线等级"];
                        
                    } else if ([key isEqualToString:@"PriceRange"]) {
                        // 价格区间
                        [self.bottomViewContentDic setObject:dic[@"PriceRange"] forKey:@"价格区间"];
                    }
                }
            }
        }
        
        if (self.isSearchKey == NO) {
            self.conditionDic = json[@"ProductCondition"];
            
        }
        self.productCount = [json[@"TotalCount"] integerValue];
        
//        NSLog(@"%d", self.findListFrom);
        
        if ([json[@"ProductList"] count] == 0 && self.findListFrom == 1) {
            self.FindEmptyView.hidden = NO;
            [self.view addSubview:self.FindEmptyView];
            self.downView.hidden = YES;
            
        }else if ([json[@"ProductList"] count] == 0 && self.isEnsure == NO){
            
            self.FindEmptyView.hidden = NO;
            [self.view addSubview:self.FindEmptyView];
            
        }
        if (self.isEnsure == NO && [json[@"ProductList"] count]!=0) {
            self.FindEmptyView.hidden = YES;
        }
        
        self.isSearchKey = YES;
        [self.tableView reloadData];
        self.isEnsure = YES;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"请求...%@", error);
    }];
}

#pragma mark - tableView－delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 99) {
        return [self.productListArr count];
    }else if (tableView.tag == 999){
        
        // 对三部分内容进行判断
        if (self.bottomEnum == RouteButtonEnum) {
            return self.routeArray.count;
        } else if (self.bottomEnum == TimeButtonEnum) {
            return self.timeArray.count;
        } else if (self.bottomEnum == ChooseButtonEnum) {
            return self.chooseArr.count;
        }
        
    }else if (tableView.tag == 9999){
        return 3;
    } else if (tableView == self.chooseContentTableView) {
        
        if (self.bottomCellStyleEnum == BottomDateCellEnum || self.bottomCellStyleEnum == TimeButtonEnum) {
            return 1;
        }
        return 10;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 99) {
        FindResListCell *cell = [FindResListCell cellWithTableView:tableView];
        FindResultListModel *model = _productListArr[indexPath.row];
        NSLog(@"%@" , _productListArr);
        self.shareIn = model.ShareInfo;
        cell.model = model;
        //        cell.delegate = self;
        //        cell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
        //        cell.rightButtons = [self createSwipeRightButtons:model];
        return cell;
        
    }else{
        if(tableView.tag == 9999) {
            static NSString *ID = @"FindResListCellChoose";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            cell.textLabel.textColor = [UIColor colorWithRed:102.0/225.0f green:102.0/225.0f blue:102.0/225.0f alpha:1];
            cell.textLabel.text = self.orderArr[indexPath.row];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
            
        } else if (tableView == self.chooseContentTableView) {
#pragma mark 这里编写选项内容cell中数据
            if (self.bottomCellStyleEnum == BottomDateCellEnum) {
                ChooseContentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:find_BottomDateTVCellIdentifier forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // 日期
                
            
                NSLog(@"出发日期：============= %@",self.bottomViewContentDic[@"出发日期"]);
                
                
                
                
                return cell;
                
            } else if (self.bottomCellStyleEnum == BottomPriceCellEnum) {
                
                Find_BottomCustomTVCell *cell = [tableView dequeueReusableCellWithIdentifier:find_BottomCustomTVCellIdentifier forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // 价格区间
                NSLog(@"价格区间：============= %@",self.bottomViewContentDic[@"价格区间"]);
                
                
                return cell;
                
            } else if (self.bottomCellStyleEnum == BottomNormalCellEnum) {
                
                ChooseContentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:chooseContentCellIdentifier forIndexPath:indexPath];
                // 通用cell
                
                
                return cell;
                
            }
            
            return nil;
        } else {
            OrderFindResultCell *cell = [OrderFindResultCell cellWithTableView:tableView];
            cell.backgroundColor = [UIColor clearColor];
            
#pragma mark 添加点击状态时的背景view
            UIView *cellBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GETWIDTH(cell), GETHEIGHT(cell))];
            cellBackgroundView.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = cellBackgroundView;
            
            
            // 对三部分内容进行判断
            if (self.bottomEnum == RouteButtonEnum) {
                
                cell.titleStr = self.routeArray[indexPath.row];
                
                
            } else if (self.bottomEnum == TimeButtonEnum) {
                
                cell.titleStr = self.timeArray[indexPath.row];
                
            } else if (self.bottomEnum == ChooseButtonEnum) {
                
                cell.titleStr = self.chooseArr[indexPath.row];
                
            }
            
            
            
            
            NSLog(@"self.subIndicateDataArr1 ===== %@",self.subIndicateDataArr1);
            
            if (indexPath.row != 0) {
                NSString *detailStr;
                if ([self.subIndicateDataArr1 count]==0) {
                    detailStr = @"";
                }else{
                    detailStr = [NSString stringWithFormat:@"%@",self.subIndicateDataArr1[indexPath.row]];
                }
                if (!detailStr.length|| [detailStr isEqualToString:@" "]) {
                    cell.contentStr = @"不限";
                }else{
                    cell.contentStr = self.subIndicateDataArr1[indexPath.row];
                }
                
                
            }else if (indexPath.row == 0){
                NSString *deStr1 = [self.showDic objectForKey:@"MinPrice"];
                NSString *deStr2 = [self.showDic objectForKey:@"MaxPrice"];
                
                if (!deStr1.length && !deStr2.length) {
                    cell.contentStr = @"不限";
                }else if ([deStr1 isEqual:[NSNull null]] && [deStr2 isEqual:[NSNull null]]){
                    
                }else{
                    if ([deStr2 isEqualToString:@"0"]) {
                        cell.contentStr = [NSString stringWithFormat:@"%@以上", deStr1];
                    }else{
                        NSString *dd = [[deStr1 stringByAppendingString:@"-"] stringByAppendingString:deStr2];
                        cell.contentStr = [NSString stringWithFormat:@"%@", dd];
                    }
                }
            }
            NSRange range = [cell.noLimitL.text rangeOfString:@"不限"];
            if(range.location == NSNotFound){
                cell.noLimitL.textColor = [UIColor orangeColor];
            }else{
                cell.noLimitL.textColor = [UIColor lightGrayColor];
            }
            return cell;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 99) {
        return 100;
    }else if(tableView.tag == 9999){
        return 50;
    } else if (tableView.tag == 999) {
        return 45;
    }  else if (tableView == self.chooseContentTableView) {
        
        if (self.bottomCellStyleEnum == BottomDateCellEnum || self.bottomCellStyleEnum == TimeButtonEnum) {
            return 313;
        }
        
        return 45;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 99) {
        DetailWebViewController *detailVC = [[DetailWebViewController alloc]init];
        detailVC.ShareInfo = [self.productListArr[indexPath.row]ShareInfo];
        
        if ([[self.productListArr[indexPath.row]ShareInfo] count] != 0) {
            detailVC.isReadyToShare = YES;
        }
        detailVC.linkUrl = [NSString stringWithFormat:@"%@",[self.productListArr[indexPath.row]LinkUrl]];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    } else if (tableView == self.chooseContentTableView) {
#pragma mark 选项内容cell点击事件
        
        NSLog(@"点击了这里");
        
        
        
        
        
        
        
        
        
    } else if (tableView.tag == 999){
        
        // 对三部分内容进行判断
        if (self.bottomEnum == RouteButtonEnum) {
            
            self.bottomCellStyleEnum = BottomNormalCellEnum;
            [self.chooseContentTableView reloadData];
            
        } else if (self.bottomEnum == TimeButtonEnum) {
            
            if (indexPath.row == 0) {
                self.bottomCellStyleEnum = BottomDateCellEnum;
                [self.chooseContentTableView reloadData];
            } else {
                self.bottomCellStyleEnum = BottomNormalCellEnum;
                [self.chooseContentTableView reloadData];
            }
            
        } else if (self.bottomEnum == ChooseButtonEnum) {
            
            if (indexPath.row == 0) {
                self.bottomCellStyleEnum = BottomPriceCellEnum;
                [self.chooseContentTableView reloadData];
            } else {
                self.bottomCellStyleEnum = BottomNormalCellEnum;
                [self.chooseContentTableView reloadData];
            }
            
        }
        
        //#pragma mark 选项cell点击事件
        //
        //        if (indexPath.row == 0) {
        //            Find_PriceVC *findPrice_VC = [[Find_PriceVC alloc]init];
        //            findPrice_VC.priceDelegate = self;
        //            NSDictionary *conditionDic;
        //
        //
        //#pragma mark 第一行的传输内容
        //            for (NSInteger i = 0 ; i<[self.conditionListArr count]; i++) {
        //                if ([[_conditionListArr objectAtIndex:i] objectForKey:self.keydataArr[indexPath.row]]) {
        //                    conditionDic = _conditionListArr[i];
        //                }
        //            }
        //
        //            NSLog(@"conditionDic ========= %@",conditionDic);
        //
        //            findPrice_VC.chooseDic = conditionDic;//按钮上的值
        //            findPrice_VC.conditionDic = self.conditionDic;//滑杆上的值
        //            findPrice_VC.primaryDic = self.showDic;
        //            NSLog(@"%@", self.dicC);
        //            findPrice_VC.title = @"价格区间";
        //            OrderFindResultCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        //            findPrice_VC.priceStr = cell.contentStr;
        //            findPrice_VC.PN = self.pNum;
        //            [self.navigationController pushViewController:findPrice_VC animated:YES];
        //
        //        }else{
        //
        //            NSDictionary *conditionDic;
        //
        //            for (NSInteger i = 0 ; i<[self.conditionListArr count]; i++) {
        //                if ([[_conditionListArr objectAtIndex:i] objectForKey:self.keydataArr[indexPath.row]]) {
        //                    conditionDic = _conditionListArr[i];
        //                }
        //            }
        //            NSLog(@"%@", conditionDic);
        //
        //            Find_ChooseVC *find_VC = [[Find_ChooseVC alloc]init];
        //            find_VC.conDelegate = self;
        //            find_VC.title = self.chooseArr[indexPath.row];
        //
        //
        //            find_VC.chooseDic = conditionDic;
        //            NSArray *arr = [NSArray arrayWithObjects:[NSString  stringWithFormat:@"%ld",(long)indexPath.section],[NSString  stringWithFormat:@"%ld",(long)indexPath.row], nil];
        //            find_VC.superViewSelectIndexPath = arr;
        //            find_VC.searchKey = self.SearchKey;
        //
        //            OrderFindResultCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        //                find_VC.aaaa = cell.contentStr;
        //
        //            [self.navigationController pushViewController:find_VC animated:YES];
        //        }
        
//        self.shadowView.hidden = YES;
        
    }else if (tableView.tag == 9999){
        if (indexPath.row == 0) {
            self.ProductSortingType = @"0";
        }else if (indexPath.row == 1){
            self.ProductSortingType = @"6";
        }else if (indexPath.row == 2){
            self.ProductSortingType = @"5";
        }
        [self initPull];
        self.orderFlag = NO;
        [self setBtnStateWith:5];
        _shadowView.hidden = YES;
        _orderView.hidden = YES;
        
    }
    
    [self deselectRowAtIndexPath];
}

- (void)deselectRowAtIndexPath{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.chooseContentTableView deselectRowAtIndexPath:[self.chooseContentTableView indexPathForSelectedRow] animated:YES];
    [self.orderTableView deselectRowAtIndexPath:[self.orderTableView indexPathForSelectedRow] animated:YES];
}
#pragma mark - searchBar-delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [WriteFileManager WMsaveData:[NSMutableArray array] name:[NSString stringWithFormat:@"findResultConditionSearchKey%@", self.SearchKey]];
    //    searchBar.tintColor = [UIColor clearColor];
    //    [searchBar setShowsCancelButton:NO animated:YES];
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:NO];
    return NO;
}

#pragma mark - SwipeTableCell- delegate
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction{
    return YES;
}
- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings{
    return [NSArray array];
}
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion{
    
    if (index == 0) {
        [self collectOrNoCollect:cell];
    }else if (index == 1){
        [self shareInfo:cell];
    }
    return YES;
}

- (void)collectOrNoCollect:(MGSwipeTableCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FindResultListModel *model = self.productListArr[indexPath.row];
    NSString *result;
    MBProgressHUD *hudView;
    if ([model.IsFavorites integerValue]==0) {
        result = @"1";//添加；
        hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        hudView.labelText = @"正在收藏...";
        [hudView show:YES];
        
    }else{
        result = @"2";//删除
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:model.ID forKey:@"ProductId"];
    [dic setObject:result forKey:@"RecordType"];
    
    [HttpRequestTools postWithURL:@"Product/AppSkbUserCollectionRecord" params:dic success:^(id json) {
        if ([json[@"IsSuccess"] integerValue] == 1) {
            if ([model.IsFavorites isEqualToString:@"0"]) {
                [hudView hide:YES afterDelay:0.0];
                [MBProgressHUD showSuccess:@"收藏成功"];
            }else{
                [MBProgressHUD showSuccess:@"取消成功"];
            }
            model.IsFavorites = [NSString stringWithFormat:@"%d",![model.IsFavorites integerValue]];
            [self.productListArr replaceObjectAtIndex:indexPath.row withObject:model];
            [self.tableView reloadData];
        }else{
            //  [MBProgressHUD showError:json[@"ErrorMsg"]];
            [MBProgressHUD showError:@"操作失败"];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"产品收藏网络请求失败 %@", error);
        
    }];
}
- (NSArray *)createSwipeRightButtons:(FindResultListModel *)model{
    NSMutableArray *result = [NSMutableArray array];
    MGSwipeButton *button;
    
    for (int i = 0; i < 2; i ++){
        if ([model.IsFavorites isEqualToString:@"0"]) {
            UIColor *colors[2] = {[UIColor colorWithRed:63.0/225.0f green:165.0/225.0f blue:254.0/225.0f alpha:1], [UIColor colorWithRed:158.0/255.0 green:216.0/255.0 blue:75.0/255.0 alpha:1]};
            button = [MGSwipeButton buttonWithTitle:nil backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
                return YES;
            }];
            
        }else{
            UIColor *colors[2] = {[UIColor colorWithRed:225.0/255.0 green:102.0/255.0 blue:51.0/255.0 alpha:1],[UIColor colorWithRed:63.0/225.0f green:165.0/225.0f blue:254.0/225.0f alpha:1]};
            button = [MGSwipeButton buttonWithTitle:nil backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
                return YES;
            }];
        }
        NSString *imageStr;
        if (i == 0) {
            imageStr = [model.IsFavorites isEqualToString:@"0"] ? @"collectWhite" : @"";
            NSString *btnStr = [model.IsFavorites isEqualToString:@"0"] ? @"收藏" : @"取消成功";
            [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
            [button setTitle:btnStr forState:UIControlStateNormal];
        }else if(i == 1){
            [button setImage:[UIImage imageNamed:@"shareWhite"] forState:UIControlStateNormal];
            [button setTitle:@"分享" forState:UIControlStateNormal];
        }
        if ([imageStr isEqualToString:@""]) {
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 15)];
        }else{
            [button setImageEdgeInsets:UIEdgeInsetsMake(15, 14, 50, 0)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 20, 15)];
        }
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [button.titleLabel setNumberOfLines:0];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        CGRect frame = button.frame;
        frame.size.height = 100;
        frame.size.width = i == 1 ? 60 : 60;
        button.frame = frame;
        [result addObject:button];
    }
    return result;
}

#pragma - mark scrollView-delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger count = self.tableView.contentOffset.y/(100*10);
    int totalCount = (int)self.productCount/10;
    if (self.productCount%10>0) {//如果／10还有余数总页码＋1
        totalCount++;
    }
    if (count+1 == 1) {
        self.backToTop.alpha = 0;
    }else{
        self.backToTop.alpha = 1;
    }
    if (scrollView.contentOffset.y > self.oldOffset){
        NSLog(@"向上滚动，应该隐藏");
        if (count+1 == 1){
        }else{
            if (self.isAnimation == NO) {
                [UIView animateWithDuration:0.6 animations:^{
                } completion:^(BOOL finished) {
                    NSLog(@"执行动画完毕");
                }];
                self.isAnimation = YES;
            }
        }
    }else{
        NSLog(@"向下滚动,应该显示");
        if (self.isAnimation) {
            [UIView animateWithDuration:0.6 animations:^{
            } completion:^(BOOL finished) {
                NSLog(@"执行动画完毕");
            }];
            self.isAnimation = NO;
        }
    }
    self.oldOffset = scrollView.contentOffset.y;
    NSLog(@"%ld", (long)count);
    [self.pageCountBtn setTitle:[NSString stringWithFormat:@"%ld/%d",count+1,totalCount] forState:UIControlStateNormal];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始拖拽");
    if (scrollView.tag == 99) {
                [self hideBottomView];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"结束拖拽");
    if (scrollView.tag == 99) {
                [self showBottomView];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 99) {
                [self hideBottomView];
    }
}   // called on finger up as we are moving

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"停止滚动");
    if (scrollView.tag == 99) {
                [self showBottomView];
    }
}
//显示底部
- (void)showBottomView{
    [UIView animateKeyframesWithDuration:0.8 delay:0.5 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        self.downView.frame = CGRectMake(0, MyScreenSize.height-64-50, MyScreenSize.width, 50);
    } completion:^(BOOL finished) {
    }];
}
//隐藏底部
- (void)hideBottomView{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.downView.frame = CGRectMake(0, MyScreenSize.height-64, MyScreenSize.width, 50);
    }];
}
#pragma mark - 点击按钮的方法
#pragma mark 游玩路线点击事件
- (IBAction)routeButtonClick:(UIButton *)sender {
    
    self.timeFlag = NO;
    self.chooseFlag = NO;
    self.orderFlag = NO;
    
    [_shadowView removeFromSuperview];
    if (self.routeFlag==NO) {
        [self setBtnStateWith:1];
        [self hiddenShadeView:self.chooseView];
        _chooseView.hidden = NO;
        _orderView.hidden = YES;
        //        self.showDic = [self.dicC mutableCopy];
        //
        //        self.subIndicateDataArr1 = [NSMutableArray arrayWithArray:[WriteFileManager WMreadData:[NSString stringWithFormat:@"subIndicateDataArr1"]]];
        
        self.bottomEnum = RouteButtonEnum;
        [self.chooseTableView reloadData];
        [self.view bringSubviewToFront:self.FindEmptyView];
        [self.view bringSubviewToFront:self.chooseView];
        
        // 默认选择第一行
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.chooseTableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        // 刷新chooseContentTableView数据
        self.bottomCellStyleEnum = BottomNormalCellEnum;
        [self.chooseContentTableView reloadData];
        
    }else{
        [self setBtnStateWith:5];
        _shadowView.hidden = YES;
        _chooseView.hidden = YES;
        _orderView.hidden = YES;
    }
    _routeFlag = !_routeFlag;
    
}

#pragma mark 时间天数点击事件
- (IBAction)timeButtonClick:(UIButton *)sender {
    
    self.routeFlag = NO;
    self.chooseFlag = NO;
    self.orderFlag = NO;
    
    [_shadowView removeFromSuperview];
    if (self.timeFlag==NO) {
        [self setBtnStateWith:2];
        
        [self hiddenShadeView:self.chooseView];
        _chooseView.hidden = NO;
        _orderView.hidden = YES;
        //        self.showDic = [self.dicC mutableCopy];
        //
        //        self.subIndicateDataArr1 = [NSMutableArray arrayWithArray:[WriteFileManager WMreadData:[NSString stringWithFormat:@"subIndicateDataArr1"]]];
        
        self.bottomEnum = TimeButtonEnum;
        [self.chooseTableView reloadData];
        [self.view bringSubviewToFront:self.FindEmptyView];
        [self.view bringSubviewToFront:self.chooseView];
        
        // 默认选择第一行
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.chooseTableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        // 刷新chooseContentTableView数据
        self.bottomCellStyleEnum = BottomDateCellEnum;
        [self.chooseContentTableView reloadData];
        
    }else{
        [self setBtnStateWith:5];
        _shadowView.hidden = YES;
        _chooseView.hidden = YES;
        _orderView.hidden = YES;
    }
    _timeFlag = !_timeFlag;
    
}

#pragma mark 筛选按钮点击件事
- (IBAction)chooseBtn:(id)sender {
    
    self.routeFlag = NO;
    self.timeFlag = NO;
    self.orderFlag = NO;
    
    [_shadowView removeFromSuperview];
    self.orderFlag = NO;
    if (self.chooseFlag==NO) {
        [self setBtnStateWith:3];
        [self hiddenShadeView:self.chooseView];
        _chooseView.hidden = NO;
        _orderView.hidden = YES;
        self.showDic = [self.dicC mutableCopy];
        self.bottomEnum = ChooseButtonEnum;
        self.subIndicateDataArr1 = [NSMutableArray arrayWithArray:[WriteFileManager WMreadData:[NSString stringWithFormat:@"subIndicateDataArr1"]]];
        [self.chooseTableView reloadData];
        [self.view bringSubviewToFront:self.FindEmptyView];
        [self.view bringSubviewToFront:self.chooseView];
        
        // 默认选择第一行
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.chooseTableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        // 刷新chooseContentTableView数据
        self.bottomCellStyleEnum = BottomPriceCellEnum;
        [self.chooseContentTableView reloadData];
        
    }else{
        [self setBtnStateWith:5];
        _shadowView.hidden = YES;
        _chooseView.hidden = YES;
        _orderView.hidden = YES;
    }
    _chooseFlag = !_chooseFlag;
}

#pragma mark 排序按钮点击事件
- (IBAction)orderBtn:(id)sender {
    
    self.routeFlag = NO;
    self.timeFlag = NO;
    self.chooseFlag = NO;
    
    [_shadowView removeFromSuperview];
    if (self.orderFlag == NO) {
        [self setBtnStateWith:4];
        [self hiddenShadeView:self.orderView];
        _chooseView.hidden = YES;
        _orderView.hidden = NO;
        [self.view bringSubviewToFront:self.FindEmptyView];
        [self.view bringSubviewToFront:self.orderView];
        
    }else{
        [self setBtnStateWith:5];
        _shadowView.hidden = YES;
        _chooseView.hidden = YES;
        _orderView.hidden = YES;
    }
    _orderFlag = !_orderFlag;
    
}

- (void)hiddenShadeView:(UIView *)shadeView{
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-GETHEIGHT(shadeView))];
    _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShadowViewAction:)];
    [_shadowView addGestureRecognizer:tap];
    [self.view.window addSubview:self.shadowView];
}

- (IBAction)backToTopBtn:(id)sender {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)setBtnStateWith:(int)num{
    if (num == 1) {
        self.routeButton.selected = YES;
        self.timeButton.selected = NO;
        self.chooseBtn.selected = NO;
        self.orderBtn.selected = NO;
    } else if (num == 2) {
        
        self.routeButton.selected = NO;
        self.timeButton.selected = YES;
        self.chooseBtn.selected = NO;
        self.orderBtn.selected = NO;
    } else if (num == 3) {
        
        self.routeButton.selected = NO;
        self.timeButton.selected = NO;
        self.chooseBtn.selected = YES;
        self.orderBtn.selected = NO;
    } else if (num == 4) {
        
        self.routeButton.selected = NO;
        self.timeButton.selected = NO;
        self.chooseBtn.selected = NO;
        self.orderBtn.selected = YES;
    } else if (num == 5) {
        
        self.routeButton.selected = NO;
        self.timeButton.selected = NO;
        self.chooseBtn.selected = NO;
        self.orderBtn.selected = NO;
    }
}

//重置按钮
- (IBAction)resetBtn:(id)sender {
    self.tempPNum = 0;
    [self clearData1];
    
}
//确定按钮
- (IBAction)ensureBtn:(id)sender {
    [WriteFileManager WMsaveData:self.subIndicateDataArr1 name:[NSString stringWithFormat:@"subIndicateDataArr1"]];
    
    self.pNum = self.tempPNum;
    self.dicC = [self.showDic mutableCopy];
    [self.dic removeAllObjects];
    [self.dic addEntriesFromDictionary:self.dicC];
    [self.dic addEntriesFromDictionary:self.SSDic];
    
    NSLog(@"self.dic **************************** %@", self.dic);
    
    
    //    NSLog(@"self.subIndicateDataArr1 **************************** %@", self.subIndicateDataArr1);
    
    
    for (NSString *tem in self.subIndicateDataArr1) {
        NSLog(@"tem ************ %@",tem);
    }
    
    
    
    self.isEnsure = NO;
    self.downView.hidden = NO;
    [self initPull];
    [self closeShadowView];
    
}

//点击阴影消失 未保存当前数据 获取之前数据
- (void)clickShadowViewAction:(UIView *)shadowView{
    
    //重新获取数据 供刷新后
    
    //    self.subIndicateDataArr1 = [NSMutableArray arrayWithArray:[WriteFileManager WMreadData:[NSString stringWithFormat:@"subIndicateDataArr1"]]];
    
    NSLog(@"....%@", self.subIndicateDataArr1);
    
    
    [self closeShadowView];
    //    [self.dicC removeAllObjects];
    //    [self.dicC addEntriesFromDictionary:self.dic];
    
    [self.chooseTableView reloadData];
}



-(void)closeShadowView{
    _shadowView.hidden = YES;
    _chooseView.hidden = YES;
    _orderView.hidden = YES;
    
    [self setBtnStateWith:5];
    if (!self.chooseBtn.selected) {
        self.chooseFlag = NO;
    }
    if (!self.orderBtn.selected) {
        self.orderFlag = NO;
    }
    
}

//清除本地
- (void)clearData{
    [WriteFileManager WMsaveData:[NSMutableArray array] name:[NSString stringWithFormat:@"subIndicateDataArr1"]];
    //    self.subIndicateDataArr1 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ",@" ",@" ", nil];
    //    [self.showDic removeAllObjects];
    //    [self.SSDic removeAllObjects];
    //    [self.chooseTableView reloadData];
    [self clearData1];
}

- (void)clearData1{
    self.subIndicateDataArr1 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ",@" ",@" ", nil];
    [self.showDic removeAllObjects];
    [self.SSDic removeAllObjects];
    [self.chooseTableView reloadData];
}

#pragma mark - 导航上
-(void)findResultListCenterBarItem{
    UISearchBar *searchB = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, screenSize.width-200, 30)];
    self.searchB = searchB;
    self.searchB.barTintColor = [UIColor colorWithRed:252/255.0 green:102/255.0 blue:34/255.0 alpha:1.0];
    self.searchB.delegate = self;
    self.navigationItem.titleView = self.searchB;
}
- (void)findResultListRightBarItem{
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 25, 30)];
    [vi addSubview:btn];
    [btn addTarget:self action:@selector(comeInIM) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:vi];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)comeInIM{
    NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"LYGWUserInfo"];
    NSString * ChatName = userInfo[@"AppUserID"];
    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:ChatName conversationType:eConversationTypeChat];
    chatController.title = ChatName;
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark - 分享
- (void)shareInfo:(id)sender{
    [self.ShareInfo addEntriesFromDictionary:self.shareIn];
    
    if ([self.ShareInfo count] != 0) {
        self.isReadyToShare = YES;
    }else{
        self.isReadyToShare = NO;
    }
    [self shareBtnClickWithType:tpyeFromFindProduct];
    
}
#pragma mark-setter方法
- (void)setResetButton:(UIButton *)resetButton{
    _resetButton = resetButton;
    _resetButton.layer.borderColor = [UIColor colorWithRed:201.0/225.0f green:201.0/225.0f blue:201.0/225.0f alpha:1].CGColor;
    _resetButton.layer.borderWidth = 1;
    _resetButton.layer.masksToBounds = YES;
    _resetButton.layer.cornerRadius = 2;
}

- (void)setChooseBtn:(UIButton *)chooseBtn{
    _chooseBtn = chooseBtn;
    //    [_chooseBtn setTitleColor:[UIColor colorWithRed:102.0/225.0f green:102.0/225.0f blue:102.0/225.0f alpha:1] forState:UIControlStateNormal];
}
- (void)setOrderBtn:(UIButton *)orderBtn{
    _orderBtn = orderBtn;
    //[_orderBtn setTitleColor:[UIColor colorWithRed:102.0/225.0f green:102.0/225.0f blue:102.0/225.0f alpha:1] forState:UIControlStateNormal];
    
}

- (NSMutableArray *)productListArr{
    if (_productListArr == nil) {
        _productListArr = [NSMutableArray array];
    }
    return _productListArr;
}
- (NSMutableArray *)conditionListArr{
    if (!_conditionListArr) {
        _conditionListArr = [NSMutableArray array];
    }
    return _conditionListArr;
}
- (NSMutableDictionary *)ShareInfo{
    if (!_shareIn){
        _shareIn = [NSMutableDictionary dictionary];
    }
    return _shareIn;
}
- (NSArray *)keydataArr{
    if (!_keydataArr) {
        _keydataArr = [NSArray array];
    }
    return _keydataArr;
}
- (NSArray *)HeadLabelDataArr{
    if (!_HeadLabelDataArr) {
        _HeadLabelDataArr = [[NSArray alloc] init];
    }
    return _HeadLabelDataArr;
}
- (NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}
- (NSMutableDictionary *)dicC{
    if (!_dicC) {
        _dicC = [NSMutableDictionary dictionary];
    }
    return _dicC;
}
- (NSMutableDictionary *)SSDic{
    if (!_SSDic) {
        _SSDic = [NSMutableDictionary dictionary];
    }
    return _SSDic;
}

#pragma mark 底部四个按钮中数据懒加载
- (NSMutableDictionary *)bottomViewContentDic {
    if (!_bottomViewContentDic) {
        _bottomViewContentDic = [NSMutableDictionary dictionary];
    }
    return _bottomViewContentDic;
}

-(UIView *)HeadLabelMenuView{
    if (!_HeadLabelMenuView) {
        _HeadLabelMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, MyScreenSize.width, 80)];
        _HeadLabelMenuView.backgroundColor = [UIColor whiteColor];
        for (NSInteger i = 0; i < self.HeadLabelDataArr.count; i++) {
            UIButton *HeadLabelMenuB = [[UIButton alloc] initWithFrame:CGRectMake(i%4*MyScreenSize.width/4+9, i/4*MyScreenSize.height/18+10, MyScreenSize.width/5, 26)];
            //            NSDictionary *HeadLabelTit = self.HeadLabelDataArr[i];
            [HeadLabelMenuB setBackgroundImage:[UIImage imageNamed:@"FindPHeadLD"] forState:UIControlStateNormal];
            [HeadLabelMenuB setBackgroundImage:[UIImage imageNamed:@"FindPHeadLS"] forState:UIControlStateSelected];
            [HeadLabelMenuB setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
            [HeadLabelMenuB setTitleColor:[UIColor colorWithRed:255.0/225.0 green:153.0/225.0 blue:0/225.0 alpha:1] forState:UIControlStateSelected];
            [HeadLabelMenuB setTitle:@"经典" forState:UIControlStateNormal];
            //            [HeadLabelMenuB setTitle:[HeadLabelTit objectForKey:@"Text"] forState:UIControlStateNormal];
            HeadLabelMenuB.tag = 401+i;
            [HeadLabelMenuB addTarget:self action:@selector(HeadLabelMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
            //            HeadLabelMenuB.selected = YES;
            HeadLabelMenuB.titleLabel.font = [UIFont systemFontOfSize:14];
            [_HeadLabelMenuView addSubview:HeadLabelMenuB];
        }
    }
    return _HeadLabelMenuView;
}
-(UIView *)HeadLabelBGV{
    if (!_HeadLabelBGV) {
        _HeadLabelBGV = [[UIView alloc] initWithFrame:CGRectMake(0, 45, MyScreenSize.width, MyScreenSize.height-64-45)];
        _HeadLabelBGV.backgroundColor = [UIColor blackColor];
        _HeadLabelBGV.alpha = 0.4;
    }
    return _HeadLabelBGV;
}
-(NSMutableDictionary *)HeadLConditionDic{
    if (!_HeadLConditionDic) {
        _HeadLConditionDic = [[NSMutableDictionary alloc] init];
    }
    return _HeadLConditionDic;
}
- (void)transformDictionaryToRefreshTableView{
    
}
#pragma mark - 协议
- (void)transform:(NSString *)key andValue:(NSString *)value andSelectIndexPath:(NSArray *)selectIndexPath andSelectValue:(NSString *)selectValue{
    if (value) {
        //        [self.dic setObject:value forKey:key];
        
        [self.SSDic setObject:value forKey:key];
        NSLog(@"%@", self.SSDic);
        
        NSInteger a = [selectIndexPath[1] integerValue];
        if ([self.subIndicateDataArr1 count]==0) {
            self.subIndicateDataArr1 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ",@" ",@" ", nil];
        }
        
        self.subIndicateDataArr1[a] = selectValue;
        [self.chooseTableView reloadData];
    }
    self.shadowView.hidden = NO;
    
}
- (void)transformPrice:(NSString *)key andDic:(NSMutableDictionary *)dic pNum:(NSInteger)pNum{
    if (dic) {
        self.tempPNum = pNum;
        //        [self.dic removeAllObjects];
        //        [self.dic addEntriesFromDictionary:dic];
        
        //        [self.dicC removeAllObjects];
        //        [self.dicC addEntriesFromDictionary:dic];
        self.showDic = dic;
        [self.chooseTableView reloadData];
    }
    self.shadowView.hidden = NO;
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    self.shadowView.hidden = NO;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"Total_search" attributes:dict];
    NSLog(@"//// %@", self.SearchKey);
    if ([self.SearchKey isEqualToString:@""]) {
        self.searchB.text = @"推荐";
    }else{
        self.searchB.text = self.SearchKey;
        
    }
}

@end
