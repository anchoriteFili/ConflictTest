//
//  FindResListCell.h
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/25.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import "MGSwipeTableCell.h"
#import "FindResultListModel.h"

@interface FindResListCell : MGSwipeTableCell

@property (nonatomic, strong)FindResultListModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
