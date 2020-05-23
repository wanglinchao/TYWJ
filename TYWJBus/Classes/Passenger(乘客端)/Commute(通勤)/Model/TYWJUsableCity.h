//
//  TYWJUsableCity.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYWJUsableCityInfo : NSObject

/* 城市编号 */
@property (copy, nonatomic) NSString *cityID;
/* 城市 */
@property (copy, nonatomic) NSString *city;

@end

@interface TYWJUsableCity : NSObject

/* csmc */
@property (copy, nonatomic) NSString *csmc;
/* text */
@property (copy, nonatomic) NSString *text;
/* cityInfo */
@property (strong, nonatomic) TYWJUsableCityInfo *cityInfo;


@end
