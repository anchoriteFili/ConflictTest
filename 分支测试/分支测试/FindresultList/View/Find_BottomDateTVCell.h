//
//  Find_BottomDateTVCell.h
//  TravelConsultant
//
//  Created by 赵宏亚 on 16/7/4.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Find_BottomDateTVCell : UITableViewCell

@property (nonatomic,strong) UIButton *lastButton; // 六个按钮中点击的上一个按钮


@property (weak, nonatomic) IBOutlet UIButton *noLimitButton; // 不限button

@property (weak, nonatomic) IBOutlet UIButton *zhongQiuButton; // 中秋button

@property (weak, nonatomic) IBOutlet UIButton *guoQingButton; // 国庆节button

@property (weak, nonatomic) IBOutlet UIButton *sevenMonthButton; // 七月button

@property (weak, nonatomic) IBOutlet UIButton *eightMonthButton; // 八月button

@property (weak, nonatomic) IBOutlet UIButton *nineMonthButton; // 九月button

#pragma mark 更新cell中内容
- (void)updateCellWithModel:(NSArray *)array;





@end
