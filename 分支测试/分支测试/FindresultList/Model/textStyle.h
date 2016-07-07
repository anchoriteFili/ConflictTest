//
//  textStyle.h
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/29.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface textStyle : NSObject

+(void)textStyleLabel:(UILabel *)label text:(NSString *)text FontNumber:(CGFloat)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor;

+(void)textStyleLabel:(UILabel *)label text:(NSString *)text FontNumber1:(CGFloat)font1 AndRange1:(NSRange)range1 AndColor1:(UIColor *)vaColor1 FontNumber2:(CGFloat)font2 AndRange2:(NSRange)range2 AndColor2:(UIColor *)vaColor2 FontNumber3:(CGFloat)font3 AndRange3:(NSRange)range3 AndColor3:(UIColor *)vaColor3;
@end
