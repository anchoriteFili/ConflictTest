//
//  FindResultListModel.m
//  TravelConsultant
//
//  Created by 张正梅 on 16/2/25.
//  Copyright © 2016年 冯坤. All rights reserved.
//

#import "FindResultListModel.h"
#import "NSMutableDictionary+QD.h"

@implementation FindResultListModel

+(instancetype)modalWithDict:(NSDictionary *)dic{
    return [[self alloc] initWithDict:dic];
}
-(instancetype)initWithDict:(NSDictionary *)dic{
    if (self = [super init]) {
        self.ID = dic[@"ID"];
        self.Name = dic[@"Name"];
        self.Code = dic[@"Code"];
         self.PicUrl = dic[@"PicUrl"];
         self.PersonPrice = dic[@"PersonPrice"];
         self.StartCity = dic[@"StartCity"];
         self.StartCityName = dic[@"StartCityName"];
         self.LastScheduleDate = dic[@"LastScheduleDate"];
         self.IsFavorites = dic[@"IsFavorites"];
         self.LinkUrl = dic[@"LinkUrl"];
         self.LinkUrlLyq = dic[@"LinkUrlLyq"];
         self.AdvertText = dic[@"AdvertText"];
        self.IsShow = dic[@"IsShow"];
        
        self.MinPrice = dic[@"MinPrice"];
        self.MaxPrice = dic[@"MaxPrice"];
        self.ShareInfo = dic[@"ShareInfo"];
//         [self setValuesForKeysWithDictionary:dic];
        [self setValuesForKeysWithDictionary:[NSMutableDictionary cleanNullResult:dic]];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}





//
//-(void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:self.ID forKey:@"ID"];
//    [aCoder encodeObject:self.Name forKey:@"Name"];
//    [aCoder encodeObject:self.Code forKey:@"Code"];
//    [aCoder encodeObject:self.PicUrl forKey:@"PicUrl"];
//    [aCoder encodeObject:self.PersonPrice forKey:@"PersonPrice"];
//    [aCoder encodeObject:self.StartCity forKey:@"StartCity"];
//    [aCoder encodeObject:self.StartCityName forKey:@"StartCityName"];
//    [aCoder encodeObject:self.LastScheduleDate forKey:@"LastScheduleDate"];
//    [aCoder encodeObject:self.IsFavorites forKey:@"IsFavorites"];
//    [aCoder encodeObject:self.LinkUrl forKey:@"LinkUrl"];
//    [aCoder encodeObject:self.LinkUrlLyq forKey:@"LinkUrlLyq"];
//    [aCoder encodeObject:self.AdvertText forKey:@"AdvertText"];
//    [aCoder encodeObject:self.IsShow forKey:@"IsShow"];
//    [aCoder encodeObject:self.MinPrice forKey:@"MinPrice"];
//    [aCoder encodeObject:self.MaxPrice forKey:@"MaxPrice"];
//
//}
//
//
//-(id)initWithCoder:(NSCoder *)aDecoder{
//    
//    self = [super init];
//    if (self) {
//    }
//    return self;
//}

@end
