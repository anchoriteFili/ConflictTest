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

@interface FindResultList : BaseViewController
@property (nonatomic, assign)FindResultListFrom findListFrom;
@property (nonatomic, copy)NSString *SearchKey;
@property (nonatomic, strong)UIView *shadowView;
@end
