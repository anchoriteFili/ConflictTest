//
//  OrderFindResultCell.h
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/26.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFindResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noLimitL;

@property (nonatomic, copy)NSString *titleStr;
@property (nonatomic, copy)NSString *contentStr;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
