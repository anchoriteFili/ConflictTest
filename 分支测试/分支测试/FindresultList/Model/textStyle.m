//
//  textStyle.m
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/29.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import "textStyle.h"

@implementation textStyle

+ (void)textStyleLabel:(UILabel *)label text:(NSString *)text FontNumber:(CGFloat)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    label.attributedText = str;
}

+ (void)textStyleLabel:(UILabel *)label text:(NSString *)text FontNumber1:(CGFloat)font1 AndRange1:(NSRange)range1 AndColor1:(UIColor *)vaColor1 FontNumber2:(CGFloat)font2 AndRange2:(NSRange)range2 AndColor2:(UIColor *)vaColor2 FontNumber3:(CGFloat)font3 AndRange3:(NSRange)range3 AndColor3:(UIColor *)vaColor3{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font1] range:range1];
    [str addAttribute:NSForegroundColorAttributeName value:vaColor1 range:range1];
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font2] range:range2];
    [str addAttribute:NSForegroundColorAttributeName value:vaColor2 range:range2];

    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font3] range:range3];
    [str addAttribute:NSForegroundColorAttributeName value:vaColor3 range:range3];

    label.attributedText = str;
    
}
@end
