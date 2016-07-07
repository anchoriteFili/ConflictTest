//
//  UIButton+InitButton.h
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/29.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (InitButton)
+ (instancetype)buttonWithTitle:(NSString *)title
                          image:(NSString *)image
                backgroundImage:(NSString *)backgroundImage
              seleBackgroundImage:(NSString *)seleBackgroundImage
                          frame:(CGRect)frame
                         target:(id)target
                         action:(SEL)action;
+ (instancetype)buttonWithTitle:(NSString *)title
                          image:(NSString *)image
                        CGFloat:(CGFloat)Cfloat
                          frame:(CGRect)frame;
@end
