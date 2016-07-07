//
//  OrderFindResultCell.m
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/26.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import "OrderFindResultCell.h"

@interface OrderFindResultCell()
@property (weak, nonatomic) IBOutlet UILabel *titleL;


@end
@implementation OrderFindResultCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"OrderFindResultCell";
    OrderFindResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderFindResultCell" owner:nil options:nil] lastObject];
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleL.text = [NSString stringWithFormat:@"%@", titleStr];
    self.titleL.textColor = [UIColor colorWithRed:102.0/225.0f green:102.0/225.0f blue:102.0/225.0f alpha:1];
}

- (void)setContentStr:(NSString *)contentStr{
    _contentStr = contentStr;
    self.noLimitL.text = [NSString stringWithFormat:@"%@", contentStr];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
