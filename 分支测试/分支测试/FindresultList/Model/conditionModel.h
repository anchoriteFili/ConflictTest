//
//  conditionModel.h
//  TravelConsultant
//
//  Created by 张正梅 on 16/3/1.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface conditionModel : NSObject
@property (nonatomic, strong)NSMutableArray *StartCity;
@property (nonatomic, strong)NSMutableArray *GoDate;
@property (nonatomic, strong)NSMutableArray *ScheduleDays;
@property (nonatomic, strong)NSMutableArray *ProductBrowseTag;
@property (nonatomic, strong)NSMutableArray *ProductThemeTag;
@property (nonatomic, strong)NSMutableArray *PriceRange;

@property (nonatomic, copy)NSString *Text;
@property (nonatomic, copy)NSString *Value;

+(instancetype)modalWithDict:(NSDictionary *)dic;
@end
