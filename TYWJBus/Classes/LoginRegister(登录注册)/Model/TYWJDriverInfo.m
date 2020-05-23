//
//  TYWJDriverInfo.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/11.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJDriverInfo.h"
#import "NSObject+ZLDecode.h"
#import <MJExtension.h>

@interface TYWJDriverInfo()<NSCoding>

@end

@implementation TYWJDriverInfo

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self zl_encodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self zl_decodeWithCoder:aDecoder];
    }
    return self;
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}


@end
