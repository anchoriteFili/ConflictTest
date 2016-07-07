//
//  Find_PriceCell.m
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/26.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import "Find_PriceCell.h"
#import "UIButton+InitButton.h"
#import "NMRangeSlider.h"
#define screenSize [UIScreen mainScreen].bounds.size

@interface Find_PriceCell ()<UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *priceChooseView;
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)NMRangeSlider *slider;
@property (nonatomic, strong)UILabel *startL;
@property (nonatomic, strong)UILabel *endL;
@property (nonatomic, strong)UITextField *textFS;
@property (nonatomic, strong)UITextField *textFE;
@property (nonatomic, strong) NSMutableArray *btnData;
@property (strong, nonatomic) NSMutableDictionary *dinctionary;//存当前条件


@property (nonatomic, copy)NSString *mi;
@property (nonatomic, copy)NSString *ma;


@end

@implementation Find_PriceCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"Find_PriceCell";
    Find_PriceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Find_PriceCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
#pragma mark - 布局
- (void)setLayout{
    NSLog(@"%@", self.btnData);
    for (int i = 0; i < self.btnData.count; i++) {
        self.button = [UIButton buttonWithTitle:[_btnData[i] objectForKey:@"Text"] image:@"" backgroundImage:@"backgroBtn"seleBackgroundImage:@"btnClick" frame:CGRectMake(i%3*(screenSize.width-20)/3+(screenSize.width-255-20)/4, i/3*screenSize.height/14+10, 85, 30) target:self action:@selector(changePrice:)];
        self.button.tag = 1001+i;
        [self.priceChooseView addSubview:self.button];
    }
    
//价格区间滑杆
    self.slider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(self.button.frame)+50, screenSize.width-40, 25)];
    
    self.mi = [NSString stringWithFormat:@"%@", _conditionDic[@"MinPrice"]];
    self.ma = [NSString stringWithFormat:@"%@", _conditionDic[@"MaxPrice"]];
    
    [self.slider addTarget:self action:@selector(updatesliderLab) forControlEvents:UIControlEventAllTouchEvents];
    [self.priceChooseView addSubview:self.slider];
    
    
    self.startL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.button.frame)+20, 50, 30)];
//    self.startL.text = [NSString stringWithFormat:@"¥%@", _conditionDic[@"MinPrice"]];
    self.startL.font = [UIFont systemFontOfSize:11];
    self.startL.textColor = [UIColor orangeColor];
    [self.priceChooseView addSubview:self.startL];
    
    self.endL = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width-55, CGRectGetMaxY(self.button.frame)+20, 50, 30)];
    self.endL.text = [NSString stringWithFormat:@"¥%@", _conditionDic[@"MaxPrice"]];
    self.endL.font = [UIFont systemFontOfSize:11];
    self.endL.textColor = [UIColor orangeColor];
    [self.priceChooseView addSubview:self.endL];
    
    
    if ([self.mi isEqualToString:self.ma]) {
        self.slider.minimumValue = self.mi.floatValue;
    }else{
        self.slider.minimumValue = self.mi.floatValue;
        self.slider.maximumValue = self.ma.floatValue;
        self.slider.upperValue = self.ma.floatValue;
        self.startL.text = [NSString stringWithFormat:@"¥%@", _conditionDic[@"MinPrice"]];
    }
    
//自定义价格
    CGFloat Y = CGRectGetMaxY(self.slider.frame)+30;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, Y, screenSize.width/3, 30)];
    label.text = @"自定义价格";
    [self.priceChooseView addSubview:label];
//填写价格
    self.textFS = [[UITextField alloc] initWithFrame:CGRectMake(screenSize.width/3+5, Y, 80, 30)];
    self.textFS.background = [UIImage imageNamed:@"jiagebian"];
    self.textFS.delegate = self;
    self.textFS.tag = 210;
    self.textFS.placeholder = @"  ¥";
    [self.textFS setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.priceChooseView addSubview:self.textFS];
    
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.textFS.frame)+5, Y+15, 15, 1)];
    midView.backgroundColor = [UIColor lightGrayColor];
    [self.priceChooseView addSubview:midView];

    self.textFE = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(midView.frame)+5, Y, 80, 30)];
    self.textFE.background = [UIImage imageNamed:@"jiagebian"];
    self.textFE.delegate = self;
    self.textFE.tag = 220;
    self.textFE.placeholder = @"  ¥";
    [self.textFE setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.priceChooseView addSubview:self.textFE];
    
    self.slider.lowerValue = [NSString stringWithFormat:@"%@", _conditionDic[@"MinPrice"]].floatValue;
    
    float differenceNum = self.slider.maximumValue - self.slider.lowerValue;
    CGFloat aac;
    if ([UIScreen mainScreen].bounds.size.width == 320.0) {
        aac = screenSize.width/9.5/self.slider.frame.size.width;
    }else if([UIScreen mainScreen].bounds.size.width == 375.0){
        aac = screenSize.width/11.5/self.slider.frame.size.width;
    }else{
        aac = screenSize.width/12.5/self.slider.frame.size.width;
    }
    self.slider.minimumRange = aac*differenceNum;
    NSLog(@".. %f", self.slider.minimumRange);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.slider addGestureRecognizer:tap];

   
     [self primaryTag];
}

- (void)resetPrimaryNum{
    self.primaryNum = 0;
}

#pragma mark - setter方法
//滑杆上的初始值
- (void)setConditionDic:(NSMutableDictionary *)conditionDic{
    _conditionDic = conditionDic;
    NSLog(@"%@", _conditionDic);
}
//6 个 button上的值
- (void)setChooseDic:(NSDictionary *)chooseDic{
    _chooseDic = chooseDic;
    for (NSDictionary *dic in [_chooseDic objectForKey:@"PriceRange"]) {
        [self.btnData addObject:dic];
    }
    
//    for (int i = 0; i < self.btnData.count; i++) {
//        if ([[self.btnData[i] objectForKey:@"Value"] isEqualToString:_priceStr]) {
//            self.primaryNum = 1001 + i;
//        }
//    }
    [self setLayout];
    
    
}
//cell上传过来的数值
- (void)setPriceStr:(NSString *)priceStr{
    _priceStr = priceStr;
  
}
//获取预选值
- (void)setPrimaryDic:(NSDictionary *)primaryDic{
    _primaryDic = primaryDic;
    
//    NSArray *priceArr = [_priceStr componentsSeparatedByString:@"-"];
//  
//    
//    if (![_priceStr isEqualToString:@"不限"]) {
//        
//        if ([priceArr[0] isEqualToString:[_conditionDic objectForKey:@"MinPrice"]]) {
//            self.primaryNum = 8;
//        }else{
//            self.primaryNum = 7;
//        }
//    }else{
////        self.primaryNum = [[[NSUserDefaults standardUserDefaults]objectForKey:@"primaryNumber"] integerValue];
//        self.primaryNum = 0;
//    }
   
}
- (void)setPrimaryNum:(NSInteger)primaryNum{
    _primaryNum = primaryNum;

    NSLog(@"...%ld", _primaryNum);
}

#pragma mark - 点击方法
- (void)tapAction:(UITapGestureRecognizer *)tap{
    self.primaryNum = 7;
    
    self.textFS.text = nil;
    self.textFE.text = nil;
    [self.textFE resignFirstResponder];
    [self.textFS resignFirstResponder];
    [self ChangeBtnState];
    
    if ([self.mi isEqualToString:self.ma]) {
        [self.dinctionary setObject:self.mi  forKey:@"MinPrice"];
        [self.dinctionary setObject:self.ma forKey:@"MaxPrice"];
        return;
    }
    
    CGPoint pc = [tap locationInView:_slider];
    NSString *aab = [NSString stringWithFormat:@"%f",self.slider.minimumValue];
    CGFloat difNum = _slider.maximumValue - aab.floatValue;
    
    //label显示的价格值
    CGFloat ab = pc.x/_slider.frame.size.width;
    CGFloat finalValue = ab * _slider.maximumValue * difNum/_slider.maximumValue + aab.intValue;
    if (pc.x-self.slider.lowerCenter.x > self.slider.upperCenter.x - pc.x) {
        self.endL.text = [NSString stringWithFormat:@"¥%0.f",finalValue];
        _slider.upperValue = finalValue;
        NSInteger parmar = _slider.frame.size.width-30;
        
        self.endL.frame = CGRectMake(ab*parmar+15, CGRectGetMaxY(self.button.frame)+20, 50, 30);
        //增加筛选条件
        [self.dinctionary setObject:[NSString stringWithFormat:@"¥%0.f",_slider.lowerValue]  forKey:@"MinPrice"];
        [self.dinctionary setObject:[NSString stringWithFormat:@"¥%0.f",finalValue] forKey:@"MaxPrice"];
        
    }else if(pc.x-self.slider.lowerCenter.x <= self.slider.upperCenter.x - pc.x){

        self.startL.text = [NSString stringWithFormat:@"¥%0.f",finalValue];
        _slider.lowerValue = finalValue;
        NSInteger parma = _slider.frame.size.width-15;
        CGFloat an = (pc.x-15)/_slider.frame.size.width;
        self.startL.frame = CGRectMake(an*parma+30, CGRectGetMaxY(self.button.frame)+20, 50, 30);
        
        //增加筛选条件
        [self.dinctionary setObject:[NSString stringWithFormat:@"¥%0.f",finalValue]  forKey:@"MinPrice"];
        [self.dinctionary setObject:[NSString stringWithFormat:@"¥%ld",(NSInteger)_slider.upperValue] forKey:@"MaxPrice"];
    }
    
}


- (void)changePrice:(UIButton *)button{

    for (NSInteger qw =1001; qw<1007; qw++) {
        if (button.tag == qw) {
            button.selected = YES;
            [self reset];
        }else{
           
            UIButton *myButton1 = (UIButton *)[self.priceChooseView viewWithTag:qw];
            myButton1.selected = NO;
        }
    }
    [self.textFS resignFirstResponder];
    [self.textFE resignFirstResponder];
    
    switch (button.tag) {
        case 1001:{
            [self clickButton:0 Primary:1001];
        }break;
            
        case 1002:{
            [self clickButton:1 Primary:1002];
        }break;
            
        case 1003:{
            [self clickButton:2 Primary:1003];
        }break;
            
        case 1004:{
            [self clickButton:3 Primary:1004];
        }break;
            
        case 1005:{
            [self clickButton:4 Primary:1005];
        }break;
            
        case 1006:{
            [self clickButton:5 Primary:1006];
        }break;
        default:
            break;
    }
}
- (void)resetAction{
    [self.textFS resignFirstResponder];
    [self.textFE resignFirstResponder];
    self.textFE.text = nil;
    self.textFS.text = nil;
    [self reset];
    for (NSInteger qw =1001; qw<1007; qw++) {
        UIButton *myButton1 = (UIButton *)[self.priceChooseView viewWithTag:qw];
            myButton1.selected = NO;
    }
}
#pragma mark - 点击确定走的
- (void)ensureAction:(UIButton *)butto{

//   [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"primaryNumber"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%f", self.startL.center.x] forKey:@"lowX"];
    [dic setObject:[NSString stringWithFormat:@"%f", self.endL.center.x] forKey:@"uppX"];
    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"lowXuppX"];
    
    
    [self.textFE resignFirstResponder];
    [self.textFS resignFirstResponder];
    BOOL minBool = [self isPureInt:self.textFS.text];
    BOOL maxBool = [self isPureInt:self.textFE.text];
    float minPrice = [self.textFS.text floatValue];
    float maxPrice = [self.textFE.text floatValue];
    
    BOOL minBiger = minPrice > maxPrice;
    
    if (minBool && maxBool && !minBiger) {
        NSLog(@"%@",self.dinctionary);

         if (self.dinctionary.count != 0) {
             
//         [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld", (long)self.primaryNum] forKey:@"number"];
         }
        
        if (_transformDelegate && [_transformDelegate respondsToSelector:@selector(transformDictionary:pNum:)]) {
            [_transformDelegate transformDictionary:self.dinctionary pNum:(NSInteger)self.primaryNum];
        }
        
    }else if(!minBool || !maxBool ){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"您的输入并非纯数字，请重新输入" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
        self.textFS.text = @"";
        self.textFE.text = @"";
        
    }else if (minBiger){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"您输入的最小价格大于最大价格，请重新输入" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
        self.textFS.text = @"";
        self.textFE.text = @"";
    }else if (maxPrice == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"价格不能为0，请重新输入" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
        self.textFS.text = @"";
        self.textFE.text = @"";
    }
    
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    if ([scan scanInt:&val] && [scan isAtEnd]) {
        return YES;
    }else if([string isEqualToString:@""] && [scan isAtEnd]){
        return YES;
    }
    return NO;
}
-(void)clickButton:(NSInteger )number Primary:(NSInteger )Primary{
    self.textFE.text = nil;
    self.textFS.text = nil;
    NSString *str = [_btnData[number] objectForKey:@"Value"];
    NSRange str1 = [str rangeOfString:@"-"];
    if(number == 0){
        [self.dinctionary setObject:@"0" forKey:@"MinPrice"];
        [self.dinctionary setObject:[str substringFromIndex:NSMaxRange(str1)] forKey:@"MaxPrice"];
    }else if(number == 5){
        [self.dinctionary setObject:[str substringToIndex:NSMaxRange(str1)-1] forKey:@"MinPrice"];
        [self.dinctionary setObject:@"0" forKey:@"MaxPrice"];
    }else{
        [self.dinctionary setObject:[str substringToIndex:NSMaxRange(str1)-1] forKey:@"MinPrice"];
        [self.dinctionary setObject:[str substringFromIndex:NSMaxRange(str1)] forKey:@"MaxPrice"];
    }
    self.primaryNum = Primary;
}
//点击下一个 重置上一个
-(void)reset{
    
    if ([self.mi isEqualToString:self.ma]) {
        return;
    }
    self.slider.lowerValue = self.slider.minimumValue;
    self.slider.upperValue = self.slider.maximumValue;
    self.startL.text = [NSString stringWithFormat:@"¥%ld",(NSInteger)(self.slider.minimumValue)];
    self.endL.text = [NSString stringWithFormat:@"¥%ld",(NSInteger)(self.slider.maximumValue)];
    self.startL.frame = CGRectMake(10, CGRectGetMaxY(self.button.frame)+20, 50, 25);
    self.endL.frame = CGRectMake(screenSize.width-55, CGRectGetMaxY(self.button.frame)+20, 50, 30);
}

#pragma mark - 滑杆更新数据
- (void)updatesliderLab{
    self.textFS.text = nil;
    self.textFE.text = nil;
    [self.textFE resignFirstResponder];
    [self.textFS resignFirstResponder];
    [self ChangeBtnState];
    
     self.primaryNum = 7;
    if ([self.mi isEqualToString:self.ma]) {
       
        [self.dinctionary setObject:self.mi  forKey:@"MinPrice"];
        [self.dinctionary setObject:self.ma forKey:@"MaxPrice"];
        return;
    }
    CGPoint lowerCenter;
    lowerCenter.x = (self.slider.lowerCenter.x + self.slider.frame.origin.x+5);
    lowerCenter.y = (self.slider.center.y - 30.0f);
    self.startL.center = lowerCenter;
    self.startL.text = [NSString stringWithFormat:@"¥%d", (int)self.slider.lowerValue];
    CGPoint upperCenter;
    upperCenter.x = (self.slider.upperCenter.x + self.slider.frame.origin.x+15);
    upperCenter.y = (self.slider.center.y - 30.0f);
    self.endL.center = upperCenter;
    self.endL.text = [NSString stringWithFormat:@"¥%d", (int)self.slider.upperValue];
 
    [self.dinctionary setObject:[NSString stringWithFormat:@"%@",self.startL.text]  forKey:@"MinPrice"];
    [self.dinctionary setObject:[NSString stringWithFormat:@"%@",self.endL.text] forKey:@"MaxPrice"];
    
    self.primaryNum = 7;
  
}

#pragma - mark TextField - Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.primaryNum = 8;
    [self reset];
    //改变六个button和滑杆的选种状态
    [self ChangeBtnState];
    
    if (textField.tag == 210) {
        self.textFS.text = nil;
    }else if (textField.tag == 220){
        self.textFE.text = nil;
    }
    
}
-(void)ChangeBtnState{
    for (NSInteger qw =1001; qw<1007; qw++) {
        UIButton *myButton1 = (UIButton *)[self.priceChooseView viewWithTag:qw];
        myButton1.selected = NO;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 210) {
        if(textField.text.integerValue == 0){
            [self.dinctionary setObject:[NSString stringWithFormat:@"¥%@",[self.conditionDic objectForKey:@"MinPrice"]] forKey:@"MinPrice"];
            [self.dinctionary setObject:[NSString stringWithFormat:@"¥%@",[self.conditionDic objectForKey:@"MaxPrice"]] forKey:@"MaxPrice"];
        }else{
            [self.dinctionary setObject:[NSString stringWithFormat:@"¥%@",textField.text] forKey:@"MinPrice"];
            
        }
    }else if(textField.tag == 220){
        if(textField.text.integerValue == 0){
            [self.dinctionary setObject:[NSString stringWithFormat:@"¥%@",[self.conditionDic objectForKey:@"MaxPrice"]] forKey:@"MaxPrice"];
            [self.dinctionary setObject:[NSString stringWithFormat:@"¥%@",[self.conditionDic objectForKey:@"MinPrice"]] forKey:@"MinPrice"];
        }else{
            [self.dinctionary setObject:[NSString stringWithFormat:@"¥%@",textField.text] forKey:@"MaxPrice"];
        }
    }
    
    [self.textFE resignFirstResponder];
    [self.textFS resignFirstResponder];
    
}



- (void)primaryTag{
    if (self.primaryNum>1000) {
        UIButton *but = (UIButton *)[self viewWithTag:self.primaryNum];
        but.selected = YES;
    }else if(self.primaryNum == 7){
        if ([_primaryDic objectForKey:@"MinPrice"] == nil) {
            
        }else{
            
            self.slider.lowerValue = [[[self.primaryDic objectForKey:@"MinPrice"] substringFromIndex:1]floatValue];
            self.slider.upperValue = [[[self.primaryDic objectForKey:@"MaxPrice"] substringFromIndex:1]floatValue];
            
            self.startL.text = [self.primaryDic objectForKey:@"MinPrice"];
            self.endL.text = [self.primaryDic objectForKey:@"MaxPrice"];
            
          float lowX = [[[[NSUserDefaults standardUserDefaults]objectForKey:@"lowXuppX"]objectForKey:@"lowX"]floatValue];
          float uppX = [[[[NSUserDefaults standardUserDefaults]objectForKey:@"lowXuppX"]objectForKey:@"uppX"]floatValue];
            
            self.startL.center =  CGPointMake(lowX, self.slider.center.y-30);
            self.endL.center = CGPointMake(uppX, self.slider.center.y-30);

        }
    }else if(self.primaryNum == 8){
        self.textFS.text = [[_primaryDic objectForKey:@"MinPrice"]substringFromIndex:1];
        self.textFE.text = [[_primaryDic objectForKey:@"MaxPrice"]substringFromIndex:1];
    }
    
    NSLog(@"%f--%f--%f--%f",self.slider.minimumValue,self.slider.lowerValue,self.slider.maximumValue,self.slider.upperValue);
}


#pragma mark - 初始化
- (NSMutableDictionary *)dinctionary{
    if (!_dinctionary) {
        _dinctionary = [NSMutableDictionary dictionary];
    }
    return _dinctionary;
}
-(NSMutableArray *)btnData{
    if (_btnData == nil) {
        self.btnData = [[NSMutableArray alloc] init];
    }
    return _btnData;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//
}

@end
