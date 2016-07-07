//
//  FindResListCell.m
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/25.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import "FindResListCell.h"
#import "UIImageView+EMWebCache.h"
#import "textStyle.h"
#define gap 10
@interface FindResListCell()
@property (nonatomic, strong)UIImageView *imageV;
@property (nonatomic, strong)UILabel *titleL;
@property (nonatomic, strong)UILabel *cityL;
@property (nonatomic, strong)UILabel *priceL;
@property (nonatomic, strong)UILabel *flightL;
@property (nonatomic, strong)UIButton *CellRightLB;//右下角标签
@property (nonatomic, strong)UIButton *CellLeftLB;//左上角标签

@end
@implementation FindResListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    FindResListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindResListCell"];
    if (!cell) {
        cell = [[FindResListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FindResListCell"];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    UIImageView *icon = [[UIImageView alloc] init];
    icon.layer.cornerRadius = 5;
//    icon.backgroundColor = [UIColor yellowColor];
    icon.layer.masksToBounds = YES;
    //左上角标签
    UIButton *CellLeftLB = [[UIButton alloc] init];
    CellLeftLB.titleLabel.font = [UIFont systemFontOfSize:10];
    CellLeftLB.titleLabel.textAlignment = NSTextAlignmentCenter;
    CellLeftLB.titleEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 2);
    [icon addSubview:CellLeftLB];
    self.CellLeftLB = CellLeftLB;
    
    [self.contentView addSubview:icon];
    self.imageV = icon;
    
    UILabel *title = [[UILabel alloc] init];
    title.numberOfLines = 0;
    title.textColor = [UIColor colorWithRed:51.0/225.0f green:51.0/225.0f blue:51.0/225.0f alpha:1];
    title.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:title];
    self.titleL = title;
    
    UILabel *cityL = [[UILabel alloc] init];
    cityL.textColor = [UIColor whiteColor];
    cityL.textAlignment = NSTextAlignmentCenter;
    cityL.backgroundColor = [UIColor blackColor];
    cityL.alpha = 0.7;
    cityL.font = [UIFont systemFontOfSize:11.0f];
    [self.imageV addSubview:cityL];
    self.cityL = cityL;
    
    UILabel *priceL = [[UILabel alloc] init];
    priceL.textColor = [UIColor colorWithRed:255.0/225.0f green:102.0/225 blue:0/225.0f alpha:1];
    priceL.numberOfLines = 0;
//    priceL.font = [UIFont systemFontOfSize:19.0f];
    [self.contentView addSubview:priceL];
    self.priceL = priceL;

    UILabel *flightL = [[UILabel alloc] init];
    flightL.numberOfLines = 0;
    flightL.textColor = [UIColor colorWithRed:102.0/225.0f green:102.0/225.0f blue:102.0/225.0f alpha:1];
    flightL.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:flightL];
    self.flightL = flightL;
    
    UIButton *CellRightLB = [[UIButton alloc] init];
    [CellRightLB setTitleColor:[UIColor colorWithRed:51.0/225.0 green:206.0/225.0 blue:161.0/225.0 alpha:1] forState:UIControlStateNormal];
    CellRightLB.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:CellRightLB];
    self.CellRightLB = CellRightLB;

}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    self.imageV.frame = CGRectMake(gap, gap, 80, 80);
    CGFloat titleW = CGRectGetMaxX(self.imageV.frame)+gap;
    self.titleL.frame = CGRectMake(titleW, 5, screenW-gap-CGRectGetMaxX(self.imageV.frame), 50);
    self.cityL.frame = CGRectMake(0, 60, 80, 20);
    self.priceL.frame = CGRectMake(titleW, CGRectGetMaxY(self.titleL.frame), screenW-CGRectGetMaxX(self.imageV.frame)-gap*2, 20);
    self.flightL.frame = CGRectMake(titleW, CGRectGetMaxY(self.priceL.frame), screenW-CGRectGetMaxX(self.imageV.frame)-gap*2, 20);
    self.CellRightLB.frame = CGRectMake(screenW - 70,CGRectGetMaxY(self.titleL.frame)+1 , 60, 21);
    self.CellLeftLB.frame = CGRectMake(0, 0, self.imageV.frame.size.width/2+10, 16);
}

- (void) setModel:(FindResultListModel *)model{
    _model = model;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",  model.PicUrl]] placeholderImage:[UIImage imageNamed:@""]];
    _cityL.text = [NSString stringWithFormat:@"%@出发", model.StartCityName];
    _titleL.text = [NSString stringWithFormat:@"%@", model.Name];
    
    NSString *priceStr = [NSString stringWithFormat:@"¥%@起", model.PersonPrice];
    _priceL.text = priceStr;
    [textStyle textStyleLabel:_priceL text:priceStr FontNumber1:12.0f AndRange1:NSMakeRange(0, 1) AndColor1:[UIColor orangeColor] FontNumber2:20.0f AndRange2:NSMakeRange(1, model.PersonPrice.length) AndColor2:[UIColor orangeColor] FontNumber3:12.0f AndRange3:NSMakeRange(model.PersonPrice.length+1, 1) AndColor3:[UIColor grayColor]];
    
    _flightL.text = [NSString stringWithFormat:@"最近班期:%@", model.LastScheduleDate];
    [self.CellLeftLB setTitle:model.ProductTypeNewName forState:UIControlStateNormal];
    NSLog(@"%@---%@",model.ProductTypeNewName,model.ProductLevelName);
    [self.CellRightLB setTitle:model.ProductLevelName forState:UIControlStateNormal];

    [self GetLabelCate:model.ProductTypeNewName];
    [self GetLabelColor:model.ProductLevelName];
}
-(void)GetLabelColor:(NSString *)string{
    if ([string isEqualToString:@"经典观光"]) {
        [self.CellRightLB setBackgroundImage:[UIImage imageNamed:@"FindPCellRAroundT"] forState:UIControlStateNormal];
        [self.CellRightLB setTitleColor:MyColor(255.0, 144.0, 144.0, 1) forState:UIControlStateNormal];
    }else if ([string isEqualToString:@"特价促销"]){
        [self.CellRightLB setBackgroundImage:[UIImage imageNamed:@"FindPCellRMix"] forState:UIControlStateNormal];
        [self.CellRightLB setTitleColor:MyColor(255.0, 153.0, 0, 1) forState:UIControlStateNormal];

    }else if ([string isEqualToString:@"品质之选"]){
        [self.CellRightLB setBackgroundImage:[UIImage imageNamed:@"FindPCellRDomT"] forState:UIControlStateNormal];
        [self.CellRightLB setTitleColor:MyColor(51.0, 204.0, 160.0, 1) forState:UIControlStateNormal];

    }else if ([string isEqualToString:@"经济热销"]){
        [self.CellRightLB setBackgroundImage:[UIImage imageNamed:@"FindPCellRLoutT"] forState:UIControlStateNormal];
        [self.CellRightLB setTitleColor:MyColor(204.0, 153.0,238.0, 1) forState:UIControlStateNormal];

    }else{
        [self.CellRightLB setBackgroundImage:[UIImage imageNamed:@"FindPCellRLoutT"] forState:UIControlStateNormal];
        [self.CellRightLB setTitleColor:MyColor(255.0, 144.0, 144.0, 1) forState:UIControlStateNormal];

    }
}
-(void)GetLabelCate:(NSString *)string{
    if ([string isEqualToString:@"酒＋景"]){
        [self.CellLeftLB setBackgroundImage:[UIImage imageNamed:@"FindPCellLMix"] forState:UIControlStateNormal];

    }else if ([string isEqualToString:@"出境游"]){
        [self.CellLeftLB setBackgroundImage:[UIImage imageNamed:@"FindPCellLoutTrav"] forState:UIControlStateNormal];

    }else if ([string isEqualToString:@"国内游"]){
        [self.CellLeftLB setBackgroundImage:[UIImage imageNamed:@"FindPCellDomTrav"] forState:UIControlStateNormal];

    }else if ([string isEqualToString:@"周边游"]){
        [self.CellLeftLB setBackgroundImage:[UIImage imageNamed:@"FindPCellAroundTrav"] forState:UIControlStateNormal];

    }else if ([string isEqualToString:@"跟团游"]){
        [self.CellLeftLB setBackgroundImage:[UIImage imageNamed:@"FindPCellCruiseTrav"] forState:UIControlStateNormal];

    }else{
        [self.CellLeftLB setBackgroundImage:[UIImage imageNamed:@"FindPCellLMix"] forState:UIControlStateNormal];
        
    }
    
//        switch (string) {
//        case @"酒＋景":{//酒＋景
//            [self.CellLeftLB setBackgroundImage:[UIImage imageNamed:@"FindPCellLMix"] forState:UIControlStateNormal];
//        }
//            break;
//        case @"出境游":{//出境游
//            [self.CellLeftLB setBackgroundImage:[UIImage imageNamed:@"FindPCellLoutTrav"] forState:UIControlStateNormal];
//        }
//            break;
//        case @"":{//国内游
//            [self.CellLeftLB setBackgroundImage:[UIImage imageNamed:@"FindPCellDomTrav"] forState:UIControlStateNormal];
//        }
//            break;
//        case @"":{//周边游
//            [self.CellLeftLB setBackgroundImage:[UIImage imageNamed:@"FindPCellAroundTrav"] forState:UIControlStateNormal];
//        }
//            break;
//        case @"":{//邮轮游
//            [self.CellLeftLB setBackgroundImage:[UIImage imageNamed:@"FindPCellCruiseTrav"] forState:UIControlStateNormal];
////            [self.CellRightLB setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        }
//
//            
//            
//        default:
//            break;
//    })
}

@end
