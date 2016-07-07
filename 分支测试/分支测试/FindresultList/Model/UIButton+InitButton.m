//
//  UIButton+InitButton.m
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/29.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import "UIButton+InitButton.h"

@implementation UIButton (InitButton)
+ (instancetype)buttonWithTitle:(NSString *)title
                          image:(NSString *)image
                backgroundImage:(NSString *)backgroundImage
              seleBackgroundImage:(NSString *)seleBackgroundImage
                          frame:(CGRect)frame
                         target:(id)target
                         action:(SEL)action
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [button setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:seleBackgroundImage] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal],
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    return button;
    
}


+ (instancetype)buttonWithTitle:(NSString *)title
                          image:(NSString *)image
                        CGFloat:(CGFloat)Cfloat
                          frame:(CGRect)frame{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:Cfloat];
    button.userInteractionEnabled = NO;
    button.frame = frame;
    return button;
}


@end
