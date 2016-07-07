//
//  Find_ChooseVC.h
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/26.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import "BaseViewController.h"
@protocol transformSelectConditionDelegate <NSObject>

-(void)transform:(NSString *)key andValue:(NSString *)value andSelectIndexPath:(NSArray *)selectIndexPath andSelectValue:(NSString *)selectValue;
@end

@interface Find_ChooseVC : BaseViewController
//@property(copy , nonatomic) NSString *title;
@property (nonatomic, strong)NSDictionary *chooseDic;
@property (strong , nonatomic) NSArray *superViewSelectIndexPath;//格式[1,1] (前面代表section，后面代表row)
@property (nonatomic, copy)NSString *searchKey;//目的为了在保存的时候能根据关键字唯一

@property (nonatomic,strong) NSMutableArray *conditionSelectArr;//传递预选值
@property (nonatomic, copy)NSString *contentStr;


@property (nonatomic, copy)NSString *aaaa;
@property (nonatomic, weak)id<transformSelectConditionDelegate>conDelegate;
@end
