//
//  Find_ChooseVC.m
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/26.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import "Find_ChooseVC.h"
#import "conditionModel.h"
#import "WriteFileManager.h"
@interface Find_ChooseVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chooseTabView;
@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic,copy)NSMutableString *selectKey;
@property (nonatomic,copy)NSMutableString *selectValue;
@property (nonatomic,copy)NSMutableString *passValue;

@end

@implementation Find_ChooseVC

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.conDelegate transform:_selectKey andValue:_passValue andSelectIndexPath:self.superViewSelectIndexPath andSelectValue:_selectValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.title;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem =leftItem;
    self.navigationItem.rightBarButtonItem = nil;

    self.chooseTabView.delegate = self;
    self.chooseTabView.dataSource = self;
    self.chooseTabView.tableFooterView = [[UIView alloc] init];
   
    
    [self dealWithData];
    
    [self.conditionSelectArr removeAllObjects];
   
    NSLog(@"...%@", self.aaaa);
    
    self.conditionSelectArr = [NSMutableArray arrayWithArray:[WriteFileManager WMreadData:[NSString stringWithFormat:@"aabbcc"]]];
    
//    self.conditionSelectArr = [NSMutableArray arrayWithArray:[WriteFileManager WMreadData:[NSString stringWithFormat:@"subIndicateDataArr1"]]];
    
    
    
    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePanGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePanGesture];
    
}
- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePanGesture{
}

- (void)dealWithData{
    NSArray *keys = [self.chooseDic allKeys];
    NSString *firstKey = [keys objectAtIndex:0];
    
    for(NSDictionary *dic in self.chooseDic[firstKey]){
        
        conditionModel *model = [conditionModel modalWithDict:dic];
        [self.dataArr addObject:model];
    }
    NSLog(@"%@", self.dataArr);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Find_ChooseVC%ld",(long)indexPath.row]];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"Find_ChooseVC%ld",(long)indexPath.row]];
    }
    cell.textLabel.text = [(conditionModel *)self.dataArr[indexPath.row] Text];
    

    NSString *conditionStr = self.aaaa;

    
    
    if (!conditionStr && indexPath.row == 0) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else if ([[_dataArr[indexPath.row]Text] isEqualToString:conditionStr]) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *keys = [self.chooseDic allKeys];
    
    self.selectKey  = [keys objectAtIndex:0];//条件返回的键名
    NSLog(@"%@", [_dataArr[indexPath.row]Value]);
    
    self.passValue = (NSMutableString *)[_dataArr[indexPath.row]Value];//取得的value
    self.selectValue = (NSMutableString *)[_dataArr[indexPath.row]Text];//取得的value的名称
    
    //储存选择的键值对，便于下次进入时显示
    NSString *title = self.title;

    NSMutableDictionary *dicNew = [NSMutableDictionary dictionary];
    for(NSMutableDictionary *dic in self.conditionSelectArr){
        dicNew = dic;
    }
    [dicNew setObject:_selectValue forKey:title];
    [self.conditionSelectArr removeAllObjects];
    [self.conditionSelectArr addObject:dicNew];
    
//     [WriteFileManager WMsaveData:_conditionSelectArr name:[NSString stringWithFormat:@"aabbcc"]];
    
    [self findResultCondition];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)findResultCondition{
    if ([_selectKey isEqualToString:@"StartCity"]) {
        self.selectKey = [NSMutableString stringWithFormat:@"StartCity"];
        
    }else if ([_selectKey isEqualToString:@"ScheduleDays"]){
        self.selectKey = [NSMutableString stringWithFormat:@"ScheduleDays"];
        
    }else if ([_selectKey isEqualToString:@"ProductBrowseTag"]){
        self.selectKey = [NSMutableString stringWithFormat:@"ProductBrowseTag"];
        
    }else if ([_selectKey isEqualToString:@"GoDate"]){
        self.selectKey = [NSMutableString stringWithFormat:@"GoDate"];
        
    }else if ([_selectKey isEqualToString:@"ProductThemeTag"]){
        self.selectKey = [NSMutableString stringWithFormat:@"ProductThemeTag"];
    }
    
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSMutableArray *)conditionSelectArr{
    if (!_conditionSelectArr) {
        _conditionSelectArr = [NSMutableArray array];
    }
    return _conditionSelectArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
