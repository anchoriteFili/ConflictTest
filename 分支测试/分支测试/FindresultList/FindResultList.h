//
//  FindResultList.h
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/24.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import "BaseViewController.h"

typedef enum{
    FromSearchKey,//导航过来
    FromSearchSource//cell关键字过来
}FindResultListFrom;

// 底部三个按钮的选择
typedef NS_ENUM(NSInteger, BottomViewEnum) {
    RouteButtonEnum, // 游览路线
    TimeButtonEnum, // 时间天数
    ChooseButtonEnum // 筛选
};

// 底部三个按钮的选择
typedef NS_ENUM(NSInteger, BottomCellStyleEnum) {
    BottomDateCellEnum, // 出发时间cell
    BottomPriceCellEnum, // 价格区间cell
    BottomNormalCellEnum // 常规cell
};

@interface FindResultList : BaseViewController
@property (nonatomic, assign)FindResultListFrom findListFrom;
@property (nonatomic, copy)NSString *SearchKey;
@property (nonatomic, strong)UIView *shadowView;
@end
