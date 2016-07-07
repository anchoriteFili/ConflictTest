//
//  Find_PriceVC.h
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/26.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import "BaseViewController.h"
@protocol transformSelectPriceDelegate <NSObject>

-(void)transformPrice:(NSString *)key andDic:(NSMutableDictionary *)dic pNum:(NSInteger)pNum;

@end

@interface Find_PriceVC : BaseViewController
@property (nonatomic, strong)NSDictionary *chooseDic;//其他值
@property (nonatomic, strong)NSMutableDictionary *conditionDic;//滑杆上的值
@property (nonatomic, strong)NSDictionary *primaryDic;//预选
@property (nonatomic, copy)NSString *priceStr;

@property (nonatomic, assign)NSInteger PN;
@property (weak, nonatomic)id<transformSelectPriceDelegate>priceDelegate;

@end
