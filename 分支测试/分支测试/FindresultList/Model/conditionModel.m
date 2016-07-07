//
//  conditionModel.m
//  TravelConsultant
//
//  Created by 张正梅 on 16/3/1.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import "conditionModel.h"

@implementation conditionModel
+(instancetype)modalWithDict:(NSDictionary *)dic{
    return [[self alloc] initWithDict:dic];
}
-(instancetype)initWithDict:(NSDictionary *)dic{
    if (self = [super init]) {
        
         [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
