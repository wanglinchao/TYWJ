//
//  TYWJBonus.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/28.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJBonus.h"
#import <MJExtension.h>

@implementation TYWJBonusInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}


@end

@implementation TYWJBonus

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"bonus":@"TYWJBonusInfo"};
}

@end


