//
//  Find_PriceCell.h
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/26.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol transformDictionary <NSObject>
- (void)transformDictionary:(NSMutableDictionary *)dic pNum:(NSInteger)pNum;
@end

@interface Find_PriceCell : UITableViewCell

@property (nonatomic, strong)NSMutableDictionary *conditionDic;//滑杆上的值
@property (nonatomic, strong)NSDictionary *chooseDic;//其他的赋值
@property (nonatomic, strong)NSDictionary *primaryDic;
//@property (strong,nonatomic) NSMutableArray *conditionArr;//post装载的条件数据



@property (weak, nonatomic)id<transformDictionary>transformDelegate;

@property (nonatomic, copy)NSString *priceStr;
@property (nonatomic, assign) NSInteger primaryNum;//价格区间的预选值

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)resetAction;
- (void)ensureAction:(UIButton *)butto;
- (void)resetPrimaryNum;
@end
