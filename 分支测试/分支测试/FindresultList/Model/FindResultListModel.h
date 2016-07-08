//
//  FindResultListModel.h
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/25.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FindResultListModel : NSObject
@property (nonatomic, copy)NSString *ID;//产品ID
@property (nonatomic, copy)NSString *Name;//
@property (nonatomic, copy)NSString *Code;//产品编号
@property (nonatomic, copy)NSString *PicUrl;//产品图片URL
@property (nonatomic, copy)NSString *PersonPrice;//成人门市价
@property (nonatomic, copy)NSString *StartCity;//出发城市
@property (nonatomic, copy)NSString *StartCityName;//出发城市名字
@property (nonatomic, copy)NSString *LastScheduleDate;//最近班期
@property (nonatomic, copy)NSString *IsFavorites;//是否收藏
@property (nonatomic, copy)NSString *LinkUrl;//跳转链接
@property (nonatomic, copy)NSString *LinkUrlLyq;//跳转链接（从旅游顾问APP发送链接到旅游圈APP用的）
@property (nonatomic, copy)NSString *AdvertText;//广告软文
@property (nonatomic, copy)NSString *IsShow;//产品上下架状态 1上架 0下架

@property (nonatomic, copy)NSString *MinPrice;//价格范围最小值
@property (nonatomic, copy)NSString *MaxPrice;//价格范围最大值

@property (nonatomic, copy)NSString *ProductTypeNewName;//左上角标签
@property (nonatomic, copy)NSString *ProductLevelName;//右下角标签


@property (nonatomic, strong)NSMutableDictionary *ShareInfo;

+(instancetype)modalWithDict:(NSDictionary *)dic;
@end
