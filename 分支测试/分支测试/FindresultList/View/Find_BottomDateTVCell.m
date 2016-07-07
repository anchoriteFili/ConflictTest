//
//  Find_BottomDateTVCell.m
//  TravelConsultant
//
//  Created by 赵宏亚 on 16/7/4.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import "Find_BottomDateTVCell.h"

@implementation Find_BottomDateTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCellWithModel:(NSArray *)array {
    
    
    
    
    
}

#pragma mark 留个按钮的点击事件
- (IBAction)sixButtonClick:(UIButton *)sender {
    
    if (!self.lastButton) {
        self.lastButton = sender;
    }
    
    [self.lastButton setBackgroundImage:[UIImage imageNamed:@"findResult_grayCase"] forState:UIControlStateNormal];
    [self.lastButton setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
    
    [sender setBackgroundImage:[UIImage imageNamed:@"findResult_orangeCase"] forState:UIControlStateNormal];
    [sender setTitleColor:RGB_COLOR(255, 153, 0) forState:UIControlStateNormal];
    
    self.lastButton = sender;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
