//
//  Find_PriceVC.m
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/26.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import "Find_PriceVC.h"
#import "Find_PriceCell.h"
#import "WriteFileManager.h"
#import "FindResultList.h"
@interface Find_PriceVC ()<UITableViewDelegate, UITableViewDataSource, transformDictionary>
@property (weak, nonatomic) IBOutlet UITableView *priceTabView;
@property (nonatomic, strong)Find_PriceCell *cell;

@property (nonatomic, strong) NSMutableArray *conditionSelectArr;//(arr内为一个字典)
@property (nonatomic, copy)NSMutableString *selectKey;
@property (nonatomic, strong)NSMutableDictionary *dictionary;
@property (nonatomic, assign)NSInteger pNum;
@end

@implementation Find_PriceVC


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.priceDelegate transformPrice:self.selectKey andDic:self.dictionary pNum:self.pNum];
   
}
- (void)back{
    [self.cell resetPrimaryNum];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
 
    self.navigationItem.leftBarButtonItem =leftItem;
    [self priceRightBarItem];
    self.priceTabView.delegate = self;
    self.priceTabView.dataSource = self;
    self.priceTabView.tableFooterView = [[UIView alloc]init];
    
//    self.conditionSelectArr = [NSMutableArray arrayWithArray:[WriteFileManager WMreadData:@"findResultPriceCondition"]];
//  
//    NSLog(@"... %@", self.conditionSelectArr);
    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePanGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePanGesture];
    
    
}
- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePanGesture{
}

- (void)priceRightBarItem{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];;
    [btn addTarget:self action:@selector(ensureAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        self.cell = [Find_PriceCell cellWithTableView:tableView];
        self.cell.primaryNum = self.PN;
        self.cell.conditionDic = self.conditionDic;//滑杆上的值
        self.cell.priceStr = self.priceStr;
        self.cell.primaryDic = self.primaryDic;
        
        
        self.cell.chooseDic = self.chooseDic;//其他值
        self.cell.transformDelegate = self;
        
        return self.cell;
    }else{
        
        static NSString *ID = @"FindPriceCell_noLimit";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = @"不限";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 300;
    }else{
        return 50;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        [self.cell resetAction];
        [self.priceTabView deselectRowAtIndexPath:[self.priceTabView indexPathForSelectedRow] animated:YES];
    }
    
}

//- (IBAction)ensureAction:(id)sender {
//    [self.cell ensureAction:sender naV:self.navigationController];
//    
//}
- (void)ensureAction:(UIButton *)sender {
    [self.cell ensureAction:sender];
}

- (void)transformDictionary:(NSMutableDictionary *)dic pNum:(NSInteger)pNum{
    self.dictionary = dic;
    self.pNum = pNum;
    NSArray *keys = [self.chooseDic allKeys];
    self.selectKey  = [keys objectAtIndex:0];//条件返回的键名
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
